//
//  XYOneDriveIndexViewController.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2021/2/6.
//  Copyright © 2021 io.xiyuyanhen. All rights reserved.
//

import Foundation

/* 文档
 
 OneDrive 开发人员平台
 https://docs.microsoft.com/zh-cn/onedrive/developer/rest-api/api/drive_get_specialfolder?view=odsp-graph-online
 
 
 */

class XYOneDriveIndexViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate {
    
    // Update the below to your client ID you received in the portal. The below is for running the demo only
    let kClientID = "b973bda6-daa8-42d1-a90b-f8b33260e9bd"
    let kGraphEndpoint = "https://graph.microsoft.com/"
    let kAuthority = "https://login.microsoftonline.com/common"
    let kRedirectUri = "msauth.xiyuyanhen.XYYHTools://auth"
    
    let kScopes: [String] = ["user.read"]
    
    var accessToken = String()
    var applicationContext : MSALPublicClientApplication?
    var webViewParamaters : MSALWebviewParameters?

    var loggingText: UITextView!
    var signOutButton: UIButton!
    var callGraphButton: UIButton!
    var usernameLabel: UILabel!
    
    var currentAccount: MSALAccount?

    /**
        Setup public client application in viewDidLoad
    */

    override func viewDidLoad() {

        super.viewDidLoad()

        initUI()
        
        do {
            try self.initMSAL()
        } catch let error {
            self.updateLogging(text: "Unable to create Application Context \(error)")
        }
        
        self.loadCurrentAccount()
        self.platformViewDidLoadSetup()
    }
    
    func platformViewDidLoadSetup() {
                
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appCameToForeGround(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.loadCurrentAccount()
    }
    
    @objc func appCameToForeGround(notification: Notification) {
        self.loadCurrentAccount()
    }
}


// MARK: Initialization

extension XYOneDriveIndexViewController {
    
    /**
     
     Initialize a MSALPublicClientApplication with a given clientID and authority
     
     - clientId:            The clientID of your application, you should get this from the app portal.
     - redirectUri:         A redirect URI of your application, you should get this from the app portal.
     If nil, MSAL will create one by default. i.e./ msauth.<bundleID>://auth
     - authority:           A URL indicating a directory that MSAL can use to obtain tokens. In Azure AD
     it is of the form https://<instance/<tenant>, where <instance> is the
     directory host (e.g. https://login.microsoftonline.com) and <tenant> is a
     identifier within the directory itself (e.g. a domain associated to the
     tenant, such as contoso.onmicrosoft.com, or the GUID representing the
     TenantID property of the directory)
     - error                The error that occurred creating the application object, if any, if you're
     not interested in the specific error pass in nil.
     */
    func initMSAL() throws {
        
        guard let authorityURL = URL(string: kAuthority) else {
            self.updateLogging(text: "Unable to create authority URL")
            return
        }
        
        let authority = try MSALAADAuthority(url: authorityURL)
        
        let msalConfiguration = MSALPublicClientApplicationConfig(clientId: kClientID,
                                                                  redirectUri: kRedirectUri,
                                                                  authority: authority)
        self.applicationContext = try MSALPublicClientApplication(configuration: msalConfiguration)
        self.initWebViewParams()
    }
    
    func initWebViewParams() {
        self.webViewParamaters = MSALWebviewParameters(parentViewController: self)
    }
}

// MARK: Shared device

extension XYOneDriveIndexViewController {
    
    @objc func getDeviceMode(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
//            self.applicationContext?.getDeviceInformation(with: nil, completionBlock: { (deviceInformation, error) in
//
//                guard let deviceInfo = deviceInformation else {
//                    self.updateLogging(text: "Device info not returned. Error: \(String(describing: error))")
//                    return
//                }
//
//                let isSharedDevice = deviceInfo.deviceMode == .shared
//                let modeString = isSharedDevice ? "shared" : "private"
//                self.updateLogging(text: "Received device info. Device is in the \(modeString) mode.")
//            })
        } else {
            self.updateLogging(text: "Running on older iOS. GetDeviceInformation API is unavailable.")
        }
    }
}


// MARK: Acquiring and using token

extension XYOneDriveIndexViewController {
    
    /**
     This will invoke the authorization flow.
     */
    
    @objc func callGraphAPI(_ sender: UIButton) {
        
        self.loadCurrentAccount { (account) in
            
            guard let currentAccount = account else {
                
                // We check to see if we have a current logged in account.
                // If we don't, then we need to sign someone in.
                self.acquireTokenInteractively()
                return
            }
            
            self.acquireTokenSilently(currentAccount)
        }
    }
    
    func acquireTokenInteractively() {
        
        guard let applicationContext = self.applicationContext else { return }

        let parameters = MSALInteractiveTokenParameters(scopes: kScopes)
        
        applicationContext.acquireToken(with: parameters) { (result, error) in
            
            if let error = error {
                
                self.updateLogging(text: "Could not acquire token: \(error)")
                return
            }
            
            guard let result = result else {
                
                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }
            
            self.accessToken = result.accessToken
            self.updateLogging(text: "Access token is \(self.accessToken)")
            self.updateCurrentAccount(account: result.account)
            self.getContentWithToken()
        }
    }
    
    func acquireTokenSilently(_ account : MSALAccount!) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        /**
         
         Acquire a token for an existing account silently
         
         - forScopes:           Permissions you want included in the access token received
         in the result in the completionBlock. Not all scopes are
         guaranteed to be included in the access token returned.
         - account:             An account object that we retrieved from the application object before that the
         authentication flow will be locked down to.
         - completionBlock:     The completion block that will be called when the authentication
         flow completes, or encounters an error.
         */
        
        let parameters = MSALSilentTokenParameters(scopes: kScopes, account: account)
        
        applicationContext.acquireTokenSilent(with: parameters) { (result, error) in
            
            if let error = error {
                
                let nsError = error as NSError
                
                // interactionRequired means we need to ask the user to sign-in. This usually happens
                // when the user's Refresh Token is expired or if the user has changed their password
                // among other possible reasons.
                
                if (nsError.domain == MSALErrorDomain) {
                    
                    if (nsError.code == MSALError.interactionRequired.rawValue) {
                        
                        DispatchQueue.main.async {
                            self.acquireTokenInteractively()
                        }
                        return
                    }
                }
                
                self.updateLogging(text: "Could not acquire token silently: \(error)")
                return
            }
            
            guard let result = result else {
                
                self.updateLogging(text: "Could not acquire token: No result returned")
                return
            }
            
            self.accessToken = result.accessToken
            self.updateLogging(text: "Refreshed Access token is \(self.accessToken)")
            self.updateSignOutButton(enabled: true)
            self.getContentWithToken()
        }
    }
    
    func getGraphEndpoint() -> String {
        return kGraphEndpoint.hasSuffix("/") ? (kGraphEndpoint + "v1.0/me/") : (kGraphEndpoint + "/v1.0/me/");
    }
    
    /**
     This will invoke the call to the Microsoft Graph API. It uses the
     built in URLSession to create a connection.
     */
    
    func getContentWithToken() {
        
        // Specify the Graph API endpoint
        let graphURI = getGraphEndpoint()
        let url = URL(string: graphURI)
        var request = URLRequest(url: url!)
        
        // Set the Authorization header for the request. We use Bearer tokens, so we specify Bearer + the token we got from the result
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                self.updateLogging(text: "Couldn't get graph result: \(error)")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                
                self.updateLogging(text: "Couldn't deserialize result JSON")
                return
            }
            
            self.updateLogging(text: "Result from Graph: \(result))")
            
        }.resume()
    }

}


// MARK: Get account and removing cache

extension XYOneDriveIndexViewController {
    
    typealias AccountCompletion = (MSALAccount?) -> Void

    func loadCurrentAccount(completion: AccountCompletion? = nil) {
        
        guard let applicationContext = self.applicationContext else { return }
        
        guard let accounts = try? applicationContext.allAccounts(),
            let currentAccount = accounts.first else {
            
            self.updateLogging(text: "Found a signed in account \(""). Updating data for that account...")

            self.updateCurrentAccount(account: nil)
            
            if let completion = completion {
                completion(nil)
            }
            return
        }
        
        self.updateLogging(text: "Account signed out. Updating UX")
        self.accessToken = ""
        self.updateCurrentAccount(account: currentAccount)

        if let completion = completion {
            completion(currentAccount)
        }
    }
    
    /**
     This action will invoke the remove account APIs to clear the token cache
     to sign out a user from this application.
     */
    @objc func signOut(_ sender: UIButton) {
        
        guard let applicationContext = self.applicationContext,
            let account = self.currentAccount else { return }
        
        do {
            
            try applicationContext.remove(account)
            
            self.updateLogging(text: "Sign out completed successfully")
            self.accessToken = ""
            self.updateCurrentAccount(account: nil)
            
        }catch let e {
            
            let error = XYError(error: e)
            
            self.updateLogging(text: "Couldn't sign out account with error: \(error.detailMsg)")
        }
    }
}


// MARK: UI Helpers
extension XYOneDriveIndexViewController {
    
    func initUI() {
        
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = ""
        usernameLabel.textColor = .darkGray
        usernameLabel.textAlignment = .right
        
        self.view.addSubview(usernameLabel)
        
        usernameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // Add call Graph button
        callGraphButton  = UIButton()
        callGraphButton.translatesAutoresizingMaskIntoConstraints = false
        callGraphButton.setTitle("Call Microsoft Graph API", for: .normal)
        callGraphButton.setTitleColor(.blue, for: .normal)
        callGraphButton.addTarget(self, action: #selector(callGraphAPI(_:)), for: .touchUpInside)
        self.view.addSubview(callGraphButton)
        
        callGraphButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callGraphButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 120.0).isActive = true
        callGraphButton.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        callGraphButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // Add sign out button
        signOutButton = UIButton()
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.blue, for: .normal)
        signOutButton.setTitleColor(.gray, for: .disabled)
        signOutButton.addTarget(self, action: #selector(signOut(_:)), for: .touchUpInside)
        self.view.addSubview(signOutButton)
        
        signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signOutButton.topAnchor.constraint(equalTo: callGraphButton.bottomAnchor, constant: 10.0).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        let deviceModeButton = UIButton()
        deviceModeButton.translatesAutoresizingMaskIntoConstraints = false
        deviceModeButton.setTitle("Get device info", for: .normal);
        deviceModeButton.setTitleColor(.blue, for: .normal);
        deviceModeButton.addTarget(self, action: #selector(getDeviceMode(_:)), for: .touchUpInside)
        self.view.addSubview(deviceModeButton)
        
        deviceModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deviceModeButton.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 10.0).isActive = true
        deviceModeButton.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        deviceModeButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        // Add logging textfield
        loggingText = UITextView()
        loggingText.isUserInteractionEnabled = false
        loggingText.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(loggingText)
        
        loggingText.topAnchor.constraint(equalTo: deviceModeButton.bottomAnchor, constant: 10.0).isActive = true
        loggingText.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10.0).isActive = true
        loggingText.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10.0).isActive = true
        loggingText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10.0).isActive = true
    }
    
    func updateLogging(text : String) {
        
        XYLog.LogNote(msg: text)
        
        if Thread.isMainThread {
            self.loggingText.text = text
        } else {
            DispatchQueue.main.async {
                self.loggingText.text = text
            }
        }
    }
    
    func updateSignOutButton(enabled : Bool) {
        if Thread.isMainThread {
            self.signOutButton.isEnabled = enabled
        } else {
            DispatchQueue.main.async {
                self.signOutButton.isEnabled = enabled
            }
        }
    }
    
    func updateAccountLabel() {
        
        guard let currentAccount = self.currentAccount else {
            self.usernameLabel.text = "Signed out"
            return
        }
        
        self.usernameLabel.text = currentAccount.username
    }
    
    func updateCurrentAccount(account: MSALAccount?) {
        self.currentAccount = account
        self.updateAccountLabel()
        self.updateSignOutButton(enabled: account != nil)
    }
}

//
//  Cell+Extension.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/3/20.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

import Foundation

protocol XYViewExtensionReuseIdentifierProtocol: UIView { }

extension XYViewExtensionReuseIdentifierProtocol {
    
    /// ReuseIdentifier
    static func ReuseIdentifier() -> String {
        
        return "\(NSStringFromClass(self))_ReuseIdentifier"
    }
}

// MARK: - UITable

extension UITableViewCell: XYViewExtensionReuseIdentifierProtocol { }

extension UITableView {
    
    func xyRegister(_ cellClasss: AnyClass...) {
        
        for cellClass in cellClasss {
            
            guard let cClass = cellClass as? XYViewExtensionReuseIdentifierProtocol.Type else {
                
                fatalError("类型不是UITableViewCell的子类")
            }
            
            self.register(cClass, forCellReuseIdentifier: cClass.ReuseIdentifier())
        }
    }
    
    func xyRegisterNib(_ cellClasss: AnyClass...) {
        
        for cellClass in cellClasss {
            
            guard let cClass = cellClass as? XYViewExtensionReuseIdentifierProtocol.Type else {
                
                fatalError("类型不是UITableViewCell的子类")
            }
            
            /// nib文件名
            let nibName: String = cClass.XYClassName
            
            guard XYBundle.NibFileIsExist(name: nibName) else {
                
                fatalError("Cell的Nib文件缺失")
            }
            
            /// nib文件
            let nib = UINib(nibName: nibName, bundle: nil)
            
            self.register(nib, forCellReuseIdentifier: cClass.ReuseIdentifier())
        }
    }
}

// MARK: - UICollection

extension UICollectionViewCell: XYViewExtensionReuseIdentifierProtocol { }

extension UICollectionView {
    
    func xyRegister(_ cellClasss: AnyClass...) {
        
        for cellClass in cellClasss {
        
            guard let cClass = cellClass as? XYViewExtensionReuseIdentifierProtocol.Type else {
                
                fatalError("类型不是UICollectionViewCell的子类")
            }
            
            self.register(cClass, forCellWithReuseIdentifier: cClass.ReuseIdentifier())
        }
    }
    
    func xyRegisterNib(_ cellClasss: AnyClass...) {
        
        for cellClass in cellClasss {
            
            guard let cClass = cellClass as? XYViewExtensionReuseIdentifierProtocol.Type else {
                
                fatalError("类型不是UICollectionViewCell的子类")
            }
            
            /// nib文件名
            let nibName: String = cClass.XYClassName
            
            guard XYBundle.NibFileIsExist(name: nibName) else {
                
                fatalError("Cell的Nib文件缺失")
            }
            
            /// nib文件
            let nib = UINib(nibName: nibName, bundle: nil)
            
            self.register(nib, forCellWithReuseIdentifier: cClass.ReuseIdentifier())
        }
    }
    
    func xyRegisterSupplementaryViewNibBy(_ cellClass: AnyClass, kind: String) {
        
        guard let cClass = cellClass as? XYViewExtensionReuseIdentifierProtocol.Type else {
            
            fatalError("类型不是UICollectionViewCell的子类")
        }
        
        /// nib文件名
        let nibName: String = cClass.XYClassName
        
        guard XYBundle.NibFileIsExist(name: nibName) else {
            
            fatalError("Cell的Nib文件缺失")
        }
        
        /// nib文件
        let nib = UINib(nibName: nibName, bundle: nil)
        
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: cClass.ReuseIdentifier())
    }
}

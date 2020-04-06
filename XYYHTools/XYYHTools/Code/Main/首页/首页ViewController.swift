//
//  首页ViewController.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/4/6.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import Foundation

class 首页ViewController : BaseViewController {
    
    override func initProperty() {
        super.initProperty()

        self.navigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RequestData_Bitstamp.Ticker()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func layoutAddViews() {
        super.layoutAddViews()
        
        
    }
    
    override func layoutAllViews() {
        super.layoutAllViews()
        
    }
    
    override func xyLocationNotificationAddObservers() {
        
    }
    
    override func xyLocationNotificationHandle(notification: Notification) {
        
    }
    
    /// 创建班级的提示语
     @IBOutlet weak var createNewClazzTipLabel: UILabel! {
            
         willSet {
    
         }
     }
     
     /// 创建班级
     @IBOutlet weak var createNewClazzBtn: UIButton! {
         
         willSet {
             
         }
     }
     
     /// 滚动视图
     @IBOutlet weak var scrollView: UIScrollView! {
            
         willSet {
     
             newValue.showsVerticalScrollIndicator = false
             newValue.showsHorizontalScrollIndicator = false
             
             newValue.contentInset = UIEdgeInsetsMake(0, 0, XYUIAdjustment.Share().tabbarHeight+UIW(20), 0)
             
             newValue.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                 
                 guard let weakSelf = self else { return }
                 
                weakSelf.scrollView.mj_header?.beginRefreshing()
                 
                XYDispatchQueueType.Main.after(time: 0.5) {
                    
                    weakSelf.scrollView.mj_header?.endRefreshing()
                }
             })
         }
     }
     
     /// banner容器
     @IBOutlet weak var bannerContainerView: UIView! {
            
         willSet {
    
         }
     }
     
     /// 布置作业容器
     @IBOutlet weak var arrangeHomeworkContainerView: UIView!
     
     /// 布置作业详情容器
     @IBOutlet weak var arrangeHomeworkDetailContainerView: UIView!
     
     /// 检查作业容器
     @IBOutlet weak var checkHomeworkContainerView: UIView!
     
     /// 检查作业 查看更多
     @IBOutlet weak var checkHomeworkMoreBtn: UIButton! {
         
         willSet {

         }
     }
     
     /// 检查作业详情容器
     @IBOutlet weak var checkHomeworkDetailContainerView: UIView!
    
    
}

extension 首页ViewController {
    
    
    
}

extension 首页ViewController {
    
    
    
}

extension 首页ViewController {
    
    
    
}

extension 首页ViewController: XYStoryboardLoadProtocol {
    
    static var StoryboardName: String { return "首页_Storyboard"}
    
    static var StoryboardIdentifier: String { return "首页ViewController" }
}

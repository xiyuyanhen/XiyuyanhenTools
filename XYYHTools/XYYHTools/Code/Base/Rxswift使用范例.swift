//
//  Rx使用范例.swift
//  EStudy
//
//  Created by 细雨湮痕 on 2019/5/10.
//  Copyright © 2019 xiyuyanhen. All rights reserved.
//

import Foundation

// MARK: - BehaviorRelay
/*
 
 BehaviorRelay 作为Variable 的替代者出现，本质上也是对BehaviorSubject的封装。不同的是Variable他不是观察者也不是序列，没有任何继承。
 BehaviorRelay 只遵守 ObservableType协议，所以它其实是一个序列，但它有一个value 属性，通过这属性能拿到最新的值。
 而通过它的 accept() 方法可以对值进行修改，通过它里面的subject将修改的值发送出去。
 例:
 func behaviorRelay() {
     let subject = BehaviorRelay(value: "A")
     subject.asObservable().subscribe(onNext: { element in
         print("第1次订阅：", element)
     }, onCompleted: {
         print("第1次订阅：completed")
     }).disposed(by: bag)
     
     subject.accept("B")
     subject.asObservable().subscribe(onNext: { element in
         print("第2次订阅：", element)
     }, onCompleted: {
         print("第2次订阅：completed")
     }).disposed(by: bag)
     
     subject.accept("C")
 }
 
 运行结果：
 第1次订阅： A
 第1次订阅： B
 第2次订阅： B
 第1次订阅： C
 第2次订阅： C
 
 */


// MARK: - UIButton的Rx响应使用
/*
 
lazy var bgBtn : UIButton = {
    
    let btn = UIButton.newAutoLayout()
    btn.setContentMode(.scaleToFill)
    btn.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.black)
    btn.alpha = 0.3
    
    weak var weakSelf = self
    btn.rx.tap.asObservable()
        .subscribe(onNext: { () in
            
            weakSelf?.changeExpandStatus()
            
        })
        .disposed(by: self.disposeBag)
    
    return btn
}()

*/

// MARK: - UIGestureRecognizer的Rx响应使用
/*
lazy var tableView : BaseTableView = {
    
    let tableView = BaseTableView.newAutoLayout()
    tableView.backgroundColor = UIColor.FromXYColor(color: XYColor.CustomColor.clear)
    //        tableView.contentInset = UIEdgeInsetsMake(0, 0, UIH(30), 0)
    
    tableView.bounces = false
    
    tableView.xyRegister(TableViewCell.self, forCellReuseIdentifier: TableViewCell.ReuseIdentifier())
    
    tableView.delegate = self
    tableView.dataSource = self
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    weak var weakSelf = self
    tapGestureRecognizer.rx.event
        .subscribe(onNext: { (tapGR) in
            
            let point = tapGR.location(in: tableView)
            
            guard let indexPath = tableView.indexPathForRow(at: point) else {
                
                weakSelf?.changeExpandStatus()
                return
            }
            
            weakSelf?.tableView(tableView, didSelectRowAt: indexPath)
            
        }).disposed(by: self.disposeBag)
    
    tableView.addGestureRecognizer(tapGestureRecognizer)
    
    return tableView
}()
 */

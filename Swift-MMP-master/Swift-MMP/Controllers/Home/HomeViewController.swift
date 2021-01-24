//
//  HomeViewController.swift
//  Swift-MMP
//
//  Created by John Lui on 2017/9/11.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    weak var viewController: ViewController!
    
    var currentPage = 0

    @IBOutlet var pageTitleButtonCollection: [UIButton]!
    @IBOutlet weak var scrollBarScrollView: UIScrollView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var menuContainerViewTopConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        let shadowPath = UIBezierPath(rect: self.menuContainerView.bounds)
        self.menuContainerView.layer.masksToBounds = false
        self.menuContainerView.layer.shadowColor = UIColor.black.cgColor
        self.menuContainerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.menuContainerView.layer.shadowOpacity = 0.6
        self.menuContainerView.layer.shadowPath = shadowPath.cgPath
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bar = UIView(frame: CGRect(x: 0, y: 0, width: self.scrollBarScrollView.frame.width / 3, height: self.scrollBarScrollView.frame.height))
        bar.backgroundColor = UIColor.white
        self.scrollBarScrollView.addSubview(bar)
        self.scrollBarScrollView.contentSize = self.scrollBarScrollView.frame.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSideButtonBeTapped(_ sender: Any) {
        self.viewController.showSide()
    }
    @IBAction func pageTitleButtonBeTapped(_ sender: Any) {
        if let button = sender as? UIButton,
            let index = self.pageTitleButtonCollection.index(of: button) {
            for b in self.pageTitleButtonCollection {
                b.alpha = 0.7
            }
            button.alpha = 1
            self.contentScrollView.setContentOffset(CGPoint(x: Common.screenWidth * CGFloat(index), y: 0), animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeMusicListSegue" {
            if let a = segue.destination as? HomeMusicListTableViewController {
                a.viewController = self.viewController
                a.homeViewController = self
            }
        }
    }

}

private typealias ScrollViewDelegate = HomeViewController

extension ScrollViewDelegate: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case self.contentScrollView:
            self.currentPage = Int(self.contentScrollView.contentOffset.x / Common.screenWidth + 0.5)
            self.scrollBarScrollView.setContentOffset(CGPoint(x: self.contentScrollView.contentOffset.x * -80 / Common.screenWidth, y: 0), animated: false)
        case self.scrollBarScrollView:
            let index = Int((self.scrollBarScrollView.contentOffset.x - 40 ) / -80)
            if index >= 0 && index <= self.pageTitleButtonCollection.count {
                for b in self.pageTitleButtonCollection {
                    b.alpha = 0.7
                }
                self.pageTitleButtonCollection[index].alpha = 1
            }
        default:
            break
        }
    }
}

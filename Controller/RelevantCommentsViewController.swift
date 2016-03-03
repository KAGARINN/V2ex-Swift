//
//  RelevantCommentsViewController.swift
//  V2ex-Swift
//
//  Created by huangfeng on 3/3/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
import FXBlurView

class RelevantCommentsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource ,UIViewControllerTransitioningDelegate {
    
    var commentsArray:[TopicCommentModel] = []
    
    private var _tableView :UITableView!
    private var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
            
            _tableView.backgroundColor = UIColor.clearColor()
            _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
            regClass(_tableView, cell: TopicDetailCommentCell.self)
            
            _tableView.delegate = self
            _tableView.dataSource = self
            return _tableView!;
            
        }
    }
    
    var frostedView = FXBlurView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.transitioningDelegate = self
        
        frostedView.underlyingView = V2Client.sharedInstance.centerNavigation!.view
        frostedView.dynamic = false
        frostedView.blurRadius = 35
        frostedView.tintColor = UIColor.blackColor()
        frostedView.frame = self.view.frame
        self.view.addSubview(frostedView)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            sleep(3)
            dispatch_sync(dispatch_get_main_queue()) { () -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.view.addSubview(self.tableView);
        self.tableView.snp_remakeConstraints{ (make) -> Void in
            make.left.right.equalTo(self.view);
            make.height.equalTo(self.view)
            make.top.equalTo(self.view.snp_bottom)
        }
    }

    override func viewDidAppear(animated: Bool) {
        self.tableView.snp_remakeConstraints{ (make) -> Void in
            make.left.right.equalTo(self.view);
            make.height.equalTo(self.view)
            make.top.equalTo(self.view)
        }
        
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 8, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentsArray.count;
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let layout = self.commentsArray[indexPath.row].textLayout!
        return layout.textBoundingRect.size.height + 12 + 35 + 12 + 12 + 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: TopicDetailCommentCell.self, indexPath: indexPath)
        cell.bind(self.commentsArray[indexPath.row])
        return cell
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return RelevantCommentsViewControllerTransionPresent()
    }
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return V2PhotoBrowserTransionDismiss()
//    }
}

class RelevantCommentsViewControllerTransionPresent:NSObject,UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! RelevantCommentsViewController
        let container = transitionContext.containerView()
        container!.addSubview(toVC.view)
        toVC.view.alpha = 0
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
        
            toVC.view.alpha = 1
            
        }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
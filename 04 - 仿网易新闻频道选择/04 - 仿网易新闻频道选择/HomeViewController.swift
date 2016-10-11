//
//  HomeViewController.swift
//  04 - 仿网易新闻频道选择
//
//  Created by 林君杨 on 2016/10/10.
//  Copyright © 2016年 linjunyang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTitle()
    }
    
    
    /// 设置标题栏
    fileprivate func setUpTitle(){
        let titleViewHeight : CGFloat = 40
        let titleView = UIView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: titleViewHeight))
        titleView.backgroundColor = UIColor.green
        self.view.addSubview(titleView)
        
        let titleScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: titleViewHeight))
        titleView.addSubview(titleScrollView)
        titleScrollView.contentSize = CGSize(width: 500, height: 0)
        
        let addMoreChannelButtonWidth : CGFloat = 25
        let addMoreChannelButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 10 - addMoreChannelButtonWidth, y: 8, width: addMoreChannelButtonWidth, height: addMoreChannelButtonWidth))
        addMoreChannelButton.setImage(UIImage(named:"plus"), for: .normal)
        titleView.addSubview(addMoreChannelButton)
        addMoreChannelButton.addTarget(self, action: #selector(HomeViewController.addMoreChannelButtonClick(button:)), for: .touchUpInside)
    }
    
    /// addMoreChannelButton点击事件
    @objc fileprivate func addMoreChannelButtonClick(button:UIButton){
        
        
        let channelVC = UIStoryboard(name: "ChannelViewController", bundle: Bundle.main)
        
        guard let channelVC1 = channelVC.instantiateInitialViewController() else{
            return
        }
        
        //  设置modal的转场样式为自定义
        channelVC1.modalPresentationStyle = .custom
        
        //  设置modal转场代理
        channelVC1.transitioningDelegate = self
        
        if button.isSelected == false{
            present(channelVC1, animated: true) {}
        }
        
    }
}

//  MARK: - 遵守转场协议代理
extension HomeViewController : UIViewControllerTransitioningDelegate{
    /// 当弹出一个控制器时会调用该方法
    //  所以就要自定义一个UIPresentationController
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ChannelPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    /// 弹出时候会调用
    //  UIViewControllerAnimatedTransitioning?返回值带？，表示这个返回值是一个协议
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    /// 消失时候会调用
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension HomeViewController : UIViewControllerAnimatedTransitioning{
    
    //  设置动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1.拿到弹出的View,如果可以取到值表示弹出
        if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
            // 2.将弹出的View添加到容器的视图中
            transitionContext.containerView.addSubview(presentedView)
            
            // 3.给弹出的View一个动画
            presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0)
            presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                presentedView.transform = CGAffineTransform.identity
                }, completion: { (isFinished) -> Void in
                    transitionContext.completeTransition(true)
            })
        } else { // 如果presentedView没有取到值,表示是消失动画
            // 1.取出消失的View
            let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
            
            // 2.给消失的View添加动画
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
                dismissView.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
                }, completion: { (_) -> Void in
                    dismissView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }
}


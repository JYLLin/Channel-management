//
//  ChannelPresentationController.swift
//  04 - 仿网易新闻频道选择
//
//  Created by 林君杨 on 2016/10/10.
//  Copyright © 2016年 linjunyang. All rights reserved.
//

import UIKit

class ChannelPresentationController: UIPresentationController {

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 1.改变弹出控制器的View的尺寸
        presentedView?.frame = CGRect(x: 0, y: 64 + 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 104)
        
    }
}

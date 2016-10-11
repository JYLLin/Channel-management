//
//  MyChannelModel.swift
//  04 - 仿网易新闻频道选择
//
//  Created by 林君杨 on 2016/10/10.
//  Copyright © 2016年 linjunyang. All rights reserved.
//

import UIKit

class MyChannelModel: NSObject {
    var id :Int = 0
    var name: String? = nil
    
    init(dic:[String : Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override init() {
        super.init()
    }
    
    //  重写该方法 避免KVC找不到属性报错
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

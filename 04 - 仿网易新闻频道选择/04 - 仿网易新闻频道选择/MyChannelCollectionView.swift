//
//  MyChannelCollectionView.swift
//  04 - 仿网易新闻频道选择
//
//  Created by 林君杨 on 2016/10/10.
//  Copyright © 2016年 linjunyang. All rights reserved.
//

import UIKit

private let MyChannelCollectionViewCellID = "MyChannelCollectionView"

class MyChannelCollectionView: UICollectionView {
    
    var myChannelModels = [MyChannelModel]()
    
    var myChannelLastFrame : CGRect?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
        self.isScrollEnabled = false
        
        register(MyChannelCollectionViewCell.self, forCellWithReuseIdentifier: MyChannelCollectionViewCellID)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}


extension MyChannelCollectionView : UICollectionViewDataSource{
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return myChannelModels.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChannelCollectionViewCellID, for: indexPath) as! MyChannelCollectionViewCell
        
        if indexPath.row >= myChannelModels.count {
            cell.isHidden = true
            myChannelLastFrame = cell.frame
        }else{
            cell.isHidden = false
            cell.tag = indexPath.row
            cell.viewModel = myChannelModels[indexPath.row]
        }
        
        
        return cell
    }
}

class MyChannelCollectionViewCell: UICollectionViewCell {
    
    var viewModel: MyChannelModel?{
        didSet{
            mainButton.setTitle(viewModel?.name, for: .normal)
        }
    }
    
    lazy var mainButton : UIButton = {
       let mainButton = UIButton(type: .custom)
        mainButton.setBackgroundImage(UIImage(named:"Small_label"), for: .normal)
        mainButton.addTarget(self, action: #selector(MyChannelCollectionViewCell.mainButtonClick), for: .touchUpInside)
        mainButton.setTitleColor(UIColor.black, for: .normal)
        mainButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return mainButton
    }()
    
    lazy var cancelButton : UIButton = {
        let cancelButton = UIButton(type: .custom)
        cancelButton.setBackgroundImage(UIImage(named:"Small_deletion"), for: .normal)
        cancelButton.isHidden = true
        cancelButton.addTarget(self, action: #selector(MyChannelCollectionViewCell.cancelButtonClick), for: .touchUpInside)
        return cancelButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainButton)
        addSubview(cancelButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainButton.frame = CGRect(x: 0, y: 8, width: self.frame.size.width - 8, height: self.frame.size.height - 8)
        cancelButton.frame = CGRect(x: self.frame.size.width - 16, y: 0, width: 16, height: 16)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 主按钮点击事件
    @objc private func mainButtonClick(){
        print("主按钮点击事件")
    }
    
    /// 取消按钮点击事件
    @objc private func cancelButtonClick(){
        print("取消按钮点击事件")
    }
}

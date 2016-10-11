//
//  RecommendCollectionView.swift
//  04 - 仿网易新闻频道选择
//
//  Created by 林君杨 on 2016/10/10.
//  Copyright © 2016年 linjunyang. All rights reserved.
//

import UIKit

private let RecommendCollectionViewCellID = "RecommendCollectionView"

//  写一个协议通知代理，按钮被点击
protocol RecommendCollectionViewDelegate : NSObjectProtocol{
    //代理方法
    func RecommendCollectionViewMainButtonClick(viewModel: MyChannelModel, frame : CGRect, indexPath: IndexPath,recommendCollectionView:RecommendCollectionView)
}

class RecommendCollectionView: UICollectionView {
    
    var recommendCollectionViewDelegate : RecommendCollectionViewDelegate?
    
    var recommendCollectionViewHeight : CGFloat {
        let cellCount : Int = recommendModels.count
        return CGFloat((((cellCount - 1) / 4) + 1) * 33 + 7 * ((cellCount - 1) / 4 + 1))
    }
    
    var recommendModels = [MyChannelModel]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCellID)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension RecommendCollectionView : UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return recommendModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCellID, for: indexPath) as! RecommendCollectionViewCell
        
        cell.viewModel = recommendModels[indexPath.row]
        cell.isHidden = false
        return cell
    }
}

extension RecommendCollectionView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let temp = recommendCollectionViewDelegate {
            
            guard let cell = collectionView.cellForItem(at: indexPath) else {
                return
            }
            cell.isHidden = true
            temp.RecommendCollectionViewMainButtonClick(viewModel: recommendModels[indexPath.row], frame : cell.frame , indexPath:indexPath,recommendCollectionView:self)
        }
    }
}

class RecommendCollectionViewCell: UICollectionViewCell {
    
    var viewModel: MyChannelModel?{
        didSet{
            mainButton.setTitle(viewModel?.name, for: .normal)
        }
    }
    
    lazy var mainButton : UIButton = {
        let mainButton = UIButton(type: .custom)
        mainButton.setBackgroundImage(UIImage(named:"Small_label"), for: .normal)
        mainButton.setTitleColor(UIColor.black, for: .normal)
        mainButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        mainButton.isUserInteractionEnabled = false
        return mainButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainButton.frame = CGRect(x: 0, y: 8, width: self.frame.size.width - 8, height: self.frame.size.height - 8)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

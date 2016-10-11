//
//  ChannelViewController.swift
//  04 - 仿网易新闻频道选择
//
//  Created by 林君杨 on 2016/10/10.
//  Copyright © 2016年 linjunyang. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var myChannelModels = [MyChannelModel]()
    var recommendModels = [MyChannelModel]()
    
    lazy var moveCell : MyChannelCollectionViewCell = {
       return MyChannelCollectionViewCell()
    }()
    
    /// 本地频道
    lazy var myChannelCollectionView : MyChannelCollectionView = {
        
        let followLayout = UICollectionViewFlowLayout()
        
        //  修改水平间距
        followLayout.minimumInteritemSpacing = 5
        //  修改垂直方向间距
        followLayout.minimumLineSpacing = 7
        
        followLayout.itemSize = CGSize(width:CGFloat((UIScreen.main.bounds.width - 20) / 4 - 5 * 3), height: CGFloat(33))
        
        let myChannelCollectionView = MyChannelCollectionView(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 0), collectionViewLayout: followLayout)
        
        myChannelCollectionView.backgroundColor = UIColor.blue
        
        return myChannelCollectionView
    }()
    
    /// 分隔标题
    lazy var titleView : UIView = {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        titleView.backgroundColor = UIColor.lightGray
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 0, height: 0))
        titleView.addSubview(label)
        label.text = "点击添加更多栏目"
        label.font = UIFont.systemFont(ofSize: 12)
        label.sizeToFit()
        label.center.y = titleView.center.y
        
        return titleView
    }()
    
    /// 推荐频道
    lazy var recommendCollectionView : RecommendCollectionView = {
        let followLayout = UICollectionViewFlowLayout()
        
        //  修改水平间距
        followLayout.minimumInteritemSpacing = 5
        //  修改垂直方向间距
        followLayout.minimumLineSpacing = 7
        followLayout.itemSize = CGSize(width:CGFloat((UIScreen.main.bounds.width - 20) / 4 - 5 * 3), height: CGFloat(33))
        
        let recommendCollectionView = RecommendCollectionView(frame: CGRect(), collectionViewLayout: followLayout)
        recommendCollectionView.backgroundColor = UIColor.purple
        
        
        return recommendCollectionView
    }()
    
    @objc private func dismissMe(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  监听通知
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.dismissMe), name: NSNotification.Name(rawValue: "dismisschannelVC1"), object: nil)
        
        loadData()
        
        myChannelCollectionView.myChannelModels = myChannelModels
        myChannelCollectionView.frame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: CGFloat((((myChannelModels.count - 1) / 4) + 1) * 33 + 7 * ((myChannelModels.count - 1) / 4 + 1)))
        
        titleView.frame = CGRect(x:0, y: myChannelCollectionView.frame.maxY + 10, width: UIScreen.main.bounds.width, height: 30)
        
        recommendCollectionView.recommendModels = recommendModels
        recommendCollectionView.frame = CGRect(x: 10, y: titleView.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: recommendCollectionView.recommendCollectionViewHeight)
        
        recommendCollectionView.backgroundColor = view.backgroundColor
        myChannelCollectionView.backgroundColor = view.backgroundColor
        
        scrollView.addSubview(myChannelCollectionView)
        scrollView.addSubview(titleView)
        scrollView.addSubview(recommendCollectionView)
        
        scrollView.contentSize = CGSize(width: 0, height: recommendCollectionView.frame.maxY + 10)
        
        recommendCollectionView.recommendCollectionViewDelegate = self
        
        //  添加手势
        let longpressP = UILongPressGestureRecognizer(target: self, action: #selector(ChannelViewController.panClick(pan:)))
        scrollView.addGestureRecognizer(longpressP)
    }
    
    /// 手势对应事件
    @objc private func panClick(pan:UILongPressGestureRecognizer){
        
        //  判断手势触发点是否在本地频道的Cell中
        //  取出手势的点
        let panPoint = pan.location(in: myChannelCollectionView)
        
        if pan.state == UIGestureRecognizerState.began {
            for cell in myChannelCollectionView.subviews {
                if cell.frame.contains(panPoint){
                    let item = cell as! MyChannelCollectionViewCell
                    
                    self.moveCell.viewModel = item.viewModel
                    item.mainButton.setTitle("", for: .normal)
                    let fromFrame = myChannelCollectionView.convert(item.frame, to: self.view)
                    self.moveCell.frame = fromFrame
                    self.moveCell.tag = item.tag
                    self.view.addSubview(self.moveCell)
                }
            }

        }else if pan.state == UIGestureRecognizerState.changed{
            
            //  让Cell跟随移动
            self.moveCell.center = panPoint
            
            //  遍历所有我的频道按钮
            for cell in myChannelCollectionView.subviews {
                
                //  判断当前移动到了Cell上面，且不能是当前被移动的Cell
                if cell.frame.contains(panPoint){
                    
                    guard let item = cell as? MyChannelCollectionViewCell else {
                        return
                    }
                    
                    if item.tag != self.moveCell.tag,item.tag != 0{
                        
                        //  移除myChannelCollectionView里被拖起来的Cell及其模型
                        self.myChannelCollectionView.myChannelModels.remove(at: self.moveCell.tag)
                        self.myChannelCollectionView.deleteItems(at: [IndexPath(item: self.moveCell.tag, section: 0)])
                        
                        // 取出被移动Cell的模型
                        let moveModel = myChannelModels[self.moveCell.tag]
                        
                        //  在移到的位置添加移动的Cell和模型
                        self.myChannelCollectionView.myChannelModels.insert(moveModel, at: item.tag)
                        self.myChannelCollectionView.insertItems(at: [IndexPath(item: item.tag, section: 0)])
                        
                        //  和移到cell交换
                        self.moveCell.tag = item.tag
                        
                        self.myChannelModels = self.myChannelCollectionView.myChannelModels
                        
                        //  延时一点刷新数据，这样才能将Cell绑定的Tag更新
                        let delay = DispatchTime.now() + DispatchTimeInterval.seconds(1)
                        DispatchQueue.main.asyncAfter(deadline: delay) {
                            self.myChannelCollectionView.reloadData()
                        }
                    }
                }
                
            }
        }else if pan.state == UIGestureRecognizerState.ended{
            self.myChannelCollectionView.myChannelModels = self.myChannelModels
            self.moveCell.removeFromSuperview()
        }
        
    }
    
    /// 加载频道数据
    private func loadData(){
        //  加载本地频道数据
        guard let path = Bundle.main.path(forResource: "localList", ofType: "plist") else {
            return
        }
        
        guard let localArray = NSArray(contentsOfFile: path) else{
            return
        }
        
        for dic in localArray {
            let model = MyChannelModel(dic: dic as! [String : Any])
            myChannelModels.append(model)
        }
        
        //  加载推荐频道数据
        guard let recommendPath = Bundle.main.path(forResource: "recommendChannel", ofType: "plist") else {
            return
        }
        
        guard let recommendArray = NSArray(contentsOfFile: recommendPath) else{
            return
        }
        
        for dic in recommendArray {
            let model = MyChannelModel(dic: dic as! [String : Any])
            recommendModels.append(model)
        }
    }

}

extension ChannelViewController : RecommendCollectionViewDelegate{
    
    func RecommendCollectionViewMainButtonClick(viewModel: MyChannelModel ,frame : CGRect, indexPath: IndexPath,recommendCollectionView:RecommendCollectionView){
        
        UIView.animate(withDuration: 0.1, animations: {
            //  从推荐频道的模型数组中移除点中的模型
            self.recommendModels.remove(at: indexPath.row)
            
            //  将移除的添加到本地频道中
            self.myChannelModels.append(viewModel)
            
            //  更新布局
            self.myChannelCollectionView.frame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height:CGFloat((((self.myChannelModels.count - 1) / 4) + 1) * 33 + 7 * ((self.myChannelModels.count - 1) / 4 + 1)))
            
            self.titleView.frame = CGRect(x:0, y: self.myChannelCollectionView.frame.maxY + 10, width: UIScreen.main.bounds.width, height: 30)
            recommendCollectionView.frame = CGRect(x: 10, y: self.titleView.frame.maxY + 10, width: UIScreen.main.bounds.width - 20, height: recommendCollectionView.recommendCollectionViewHeight)
        }) { (_) in
            //  显示动画的View
            let tempView = UIView(frame: CGRect(x: 0, y: 64 + 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 104))
            UIApplication.shared.keyWindow?.addSubview(tempView)
            
            //  转化frame
            let fromFrame = recommendCollectionView.convert(frame, to: tempView)
            //  创建一个被点击Cell一样的Cell
            let view1 = RecommendCollectionViewCell(frame: fromFrame)
            tempView.addSubview(view1)
            view1.viewModel = viewModel
            
            //  转化frame
            let toFrame = self.myChannelCollectionView.convert(self.myChannelCollectionView.myChannelLastFrame!, to: tempView)
            
            //  做动画
            UIView.animate(withDuration: 0.3, animations: {
                
                view1.frame = toFrame
                
            }) { (_) in
                //  移除动画View
                tempView.removeFromSuperview()
                self.recommendCollectionView.recommendModels = self.recommendModels
                self.myChannelCollectionView.myChannelModels = self.myChannelModels
                self.recommendCollectionView.reloadData()
                self.myChannelCollectionView.reloadData()
                
            }
        }
    }
    
}


//
//  HJCContentView.swift
//  JCPageView
//
//  Created by aZu on 2020/7/27.
//  Copyright © 2020 aZu. All rights reserved.
//

import UIKit

protocol HJCContentViewDelegate : class {
    func contentView(_ contentView :HJCContentView , targetIndex : Int)
    func contentView(_ contentView :HJCContentView , targetIndex : Int , progress : CGFloat)
}

private let kContentCellID = "kContentCellID"


class HJCContentView: UIView {

    weak var delegate : HJCContentViewDelegate?
    
    fileprivate var childVcs : [UIViewController]
    fileprivate var parentVc : UIViewController
    
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isForbidScroll :Bool = false
    
    
    fileprivate lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        
        let collectionView = UICollectionView(frame: self.bounds ,collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        
        
        return collectionView
    }()
  
    init(frame:CGRect,childVcs:[UIViewController],parentVc:UIViewController){
        
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        
       
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension HJCContentView{
    fileprivate func setupUI(){
        
        for childVc in childVcs{
            parentVc.addChild(childVc)
            
        }
        
        addSubview(collectionView)
    }
    
    
}

extension HJCContentView :UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        
        for subView in cell.contentView.subviews{
            subView.removeFromSuperview()
        }
        
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        
        return cell
        
        
    }
    
    
    
}

extension HJCContentView : UICollectionViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate{
            
            contentEndScroll()
            
        }
        
    }
    
    private func contentEndScroll(){
        
        guard !isForbidScroll else{ return }
        
      let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        delegate?.contentView(self, targetIndex: currentIndex)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard startOffsetX != scrollView.contentOffset.x , !isForbidScroll else{
            return
        }
        
        
        
        var targetIndex = 0
        var progress : CGFloat = 0.0
        
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        if startOffsetX < scrollView.contentOffset.x {
            
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count - 1{
                targetIndex = childVcs.count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
            
        }else{
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
            
        }
        
        
       
        
        
        
        
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
        
    }
    
}


extension HJCContentView : HJCTitleViewDelegate{
    func titleView(_ titleView: HJCTitleView, targetIndex: Int) {
        
        isForbidScroll = true
        
        let indexPath = IndexPath(item: targetIndex, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        
    }
}

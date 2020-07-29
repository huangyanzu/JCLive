//
//  HJCWaterfallLayout.swift
//  瀑布流
//
//  Created by aZu on 2020/7/28.
//  Copyright © 2020 aZu. All rights reserved.
//

import UIKit

protocol HJCWaterfallLayoutDataSource : class  {
    func numberOfCols(_ waterfallLayout : HJCWaterfallLayout) -> Int
    
    func waterfall(_ waterfallLayout : HJCWaterfallLayout , _ item : Int) -> CGFloat
}


class HJCWaterfallLayout: UICollectionViewFlowLayout {

    weak var dataSource : HJCWaterfallLayoutDataSource?
    
    fileprivate lazy var cellAttrs : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    fileprivate lazy var cols : Int = {
        self.dataSource?.numberOfCols(self) ?? 2
    }()
    
    fileprivate lazy var totleHeights : [CGFloat] = Array(repeating: sectionInset.top, count: cols)
    
    
}

extension HJCWaterfallLayout{
    override func prepare() {
        super.prepare()
        
        
        
       
        
        
//        UICollectionViewLayoutAttributes
        guard  let itemCount = collectionView?.numberOfItems(inSection: 0) else{
            return
        }
        
        let w1 : CGFloat = collectionView!.bounds.width - sectionInset.left - sectionInset.right
        let w2 : CGFloat = w1 - CGFloat((cols - 1)) * minimumInteritemSpacing
        
        let cellW : CGFloat = w2 / CGFloat(cols)
        
        for i in 0..<itemCount{
            let indexPath = IndexPath(item: i, section: 0)
            
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            guard let cellH : CGFloat = dataSource?.waterfall(self, i) else{
                fatalError("请实现对应的数据源方法，并且返回Cell的高度")
            }
            
            guard let minH = totleHeights.min() else { return  }
            
            guard let minIndex = totleHeights.firstIndex(of: minH) else{ return }
            
            
            let cellX : CGFloat = sectionInset.left + (minimumInteritemSpacing + cellW) * CGFloat(minIndex)
            
            let cellY : CGFloat = minH + minimumLineSpacing
            
     
            attr.frame = CGRect(x: cellX  , y: cellY, width: cellW, height: cellH)
            
            
            cellAttrs.append(attr)
            
            totleHeights[minIndex] = minH + minimumLineSpacing + cellH
            
            
        }
        
        
        
    }
}


extension HJCWaterfallLayout{
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttrs
    }
    
    
    
    
    
}

extension HJCWaterfallLayout{
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: 0, height: totleHeights.max()! + sectionInset.bottom )
    }
    
    
}

//
//  RecommendViewController.swift
//  JCLive
//
//  Created by aZu on 2020/7/29.
//  Copyright © 2020 aZu. All rights reserved.
//

import UIKit
private let kContentCellID = "kContentCellID"



class RecommendViewController: UIViewController {
    
    fileprivate lazy var collectionView : UICollectionView = {
           
           let layout = HJCWaterfallLayout()
           
           layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
           layout.minimumInteritemSpacing = 10
           layout.minimumLineSpacing = 10
           layout.dataSource = self
           
           

           
           let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
           
           collectionView.dataSource = self
           
           collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
           
           
           return collectionView
       }()
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    

    
}

extension RecommendViewController : HJCWaterfallLayoutDataSource{
    func numberOfCols(_ waterfallLayout: HJCWaterfallLayout) -> Int {
        return 2
    }
    
    func waterfall(_ waterfallLayout: HJCWaterfallLayout, _ item: Int) -> CGFloat {
        
        return CGFloat(arc4random_uniform(150) + 150)
        
    }
    
    
}


extension RecommendViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        cell.backgroundColor =  UIColor.randomColor()
        
        return cell
        
    }
    
}

//
//  HJCPageView.swift
//  JCPageView
//
//  Created by aZu on 2020/7/27.
//  Copyright © 2020 aZu. All rights reserved.
//

import UIKit


class HJCPageView: UIView {

    
    fileprivate var titles : [String]
    fileprivate var childVcs : [ UIViewController]
    fileprivate var parentVc: UIViewController
    fileprivate var style : HJCTitleStyle
    fileprivate var titleView : HJCTitleView!
    
    
  
    
    init(frame: CGRect , titles:[String], childVcs:[UIViewController],parentVc:UIViewController,style : HJCTitleStyle) {
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

extension HJCPageView{
    
    fileprivate func setupUI(){
        
        setupTitleView()
        setupContentView()
    }
    fileprivate func setupTitleView(){
        
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = HJCTitleView(frame: titleFrame,titles:titles,style: style)
        
        
        addSubview(titleView)
        
        titleView.backgroundColor = UIColor.white    }
    
    fileprivate func setupContentView(){
     
        
        
        let contentFrame = CGRect(x: 0, y: titleView.frame.maxY, width: bounds.width, height: bounds.height - titleView.frame.height)
        
        let contentView = HJCContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
     
        
        titleView.delegate = contentView
        contentView.delegate = titleView
        
        addSubview(contentView)
    }
    
}


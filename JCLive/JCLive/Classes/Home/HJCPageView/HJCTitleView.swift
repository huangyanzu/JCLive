//
//  HJCTitleView.swift
//  JCPageView
//
//  Created by aZu on 2020/7/27.
//  Copyright © 2020 aZu. All rights reserved.
//

import UIKit


protocol  HJCTitleViewDelegate : class   {
    
    func titleView(_ titleView : HJCTitleView, targetIndex : Int)
    
}




class HJCTitleView: UIView {
    
    
    weak var delegate : HJCTitleViewDelegate?

    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate var titles:[String]
    fileprivate var style : HJCTitleStyle
    fileprivate lazy var currentIndex : Int = 0
    
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        
        return scrollView
    }()
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor =  self.style.scrollLineColor
        scrollLine.frame.size.height = self.style.scrollLineHeight
        scrollLine.frame.origin.y = self.bounds.height - self.style.scrollLineHeight
        return scrollLine
    
    }()
    
    
    
    init(frame:CGRect ,titles:[String] ,style : HJCTitleStyle){
        
        self.titles = titles
        
        self.style = style
        
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HJCTitleView{
    
    fileprivate func setupUI(){
        
        addSubview(scrollView)
        
        
        setupTitleLabels()
        
        setupTitleLabelFrame()
        
        if style.isShowScrollLine{
            
            scrollView.addSubview(scrollLine)
        }
        
        
        
    }
    
    private func setupTitleLabels(){
        
        for(i,title) in titles.enumerated(){
            let titleLabel = UILabel()
            
            titleLabel.text = title
            
            titleLabel.textColor = style.normalColor
            
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            
            titleLabel.textColor = i == 0 ? style.selectedColor : style.normalColor
            
            titleLabel.isUserInteractionEnabled = true
            
            let tapGes = UITapGestureRecognizer(target: self , action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapGes)
            
            
            scrollView.addSubview(titleLabel)
            
            titleLabels.append(titleLabel)
        }
        
    }
    
    private func setupTitleLabelFrame(){
        let count = CGFloat(titles.count)
        
        for (i,label) in titleLabels.enumerated(){
            
            var w : CGFloat = 0
            let h : CGFloat = bounds.height
            var x : CGFloat = 0
            let y : CGFloat = 0
            
            if style.isScrollEnable {
             
              w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin
                , attributes: [NSAttributedString.Key.font : label.font! ], context: nil).width
                
                if i == 0 {
                    x = style.itemMargin * 0.5
                    
                    if  style.isShowScrollLine {
                        
                        scrollLine.frame.origin.x = x
                        scrollLine.frame.size.width = w
                    }
                    
                }else{
                    x = titleLabels[i - 1].frame.maxX + style.itemMargin
                }
                
            }else{
                w = bounds.width / count
                
                x = w * CGFloat(i)
                
                if i == 0  && style .isShowScrollLine{
                    scrollLine.frame.origin.x = 0
                    scrollLine.frame.size.width = w
                }
                
            }
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            
            
            
            
        }
        
        
        
        
        scrollView.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin * 0.5, height: 0) : CGSize.zero
        
    }
    
    
    
}

extension HJCTitleView {
    @objc fileprivate func titleLabelClick(_ tapGes : UITapGestureRecognizer){
        
        guard let targetLabel = tapGes.view as? UILabel else{ return }
        
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        if style.isShowScrollLine{
            UIView.animate(withDuration: 0.25) {
                      self.scrollLine.frame.origin.x = targetLabel.frame.origin.x
                      self.scrollLine.frame.size.width = targetLabel.frame.size.width
                  }
        }
        
        
               
        delegate?.titleView(self , targetIndex: currentIndex)
               
        
        
        
    }
    
    private func adjustTitleLabel(targetIndex: Int){
        
        if targetIndex == currentIndex { return }
        
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        targetLabel.textColor = style.selectedColor
        sourceLabel.textColor = style.normalColor
        
        currentIndex = targetIndex
        
        if style.isScrollEnable {
                   
                   
                   
                   var offsetX = targetLabel.center.x - scrollView.bounds.width * 0.5
                   
                   if offsetX < 0 {
                       offsetX = 0
                   }
                   
                   
                   if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
                       offsetX = scrollView.contentSize.width - scrollView.bounds.width
                   }
                   
                   scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
               }
               
    }
    
    
}

extension HJCTitleView : HJCContentViewDelegate{
    func contentView(_ contentView: HJCContentView, targetIndex: Int) {
        
        
        adjustTitleLabel(targetIndex: targetIndex)
        
        
        
    }
    
    func contentView(_ contentView: HJCContentView, targetIndex: Int, progress: CGFloat) {
       
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        let deltaRGB = UIColor.getRGBDelta(style.selectedColor,style.normalColor)
        
        
        let selectedRGB = style.selectedColor.getRGB()
        let normalRGB = style.normalColor.getRGB()
        
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(r: selectedRGB.0 - deltaRGB.0 * progress, g: selectedRGB.1 - deltaRGB.1 * progress, b: selectedRGB.2 - deltaRGB.2 * progress)
        
        if style.isShowScrollLine{
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            
            scrollLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            scrollLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
            
            
            
        }
        
    }
   
    
    
}

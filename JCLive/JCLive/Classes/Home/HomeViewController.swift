//
//  HomeViewController.swift
//  JCLive
//
//  Created by aZu on 2020/7/27.
//  Copyright © 2020 aZu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
       
        
        view.backgroundColor = UIColor.randomColor()
        
    }
    
   
    
}

extension HomeViewController{
    
    private func setupUI(){
           
           setupNavigationBar()
           
       }

    private func setupNavigationBar(){
           
        let logoImage = UIImage(named: "home-logo")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: nil, action: nil )
        
        
        let collectImage = UIImage(named: "search_btn_follow")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: collectImage, style: .plain, target: self , action: #selector(followItemClick))
        
    
        
        let searchFrame = CGRect(x: 0, y: 0, width:100, height: 32)
        
        let searchBar = UISearchBar(frame: searchFrame)
        
        searchBar.placeholder = "主播昵称/房间号/链接"
       
        searchBar.searchBarStyle = .minimal
        
         navigationItem.titleView = searchBar
        
        let searchField = searchBar.value(forKey: "searchField") as? UITextField
        searchField?.textColor = UIColor.white
        
        
        
        
       }
       
}

extension HomeViewController{
    
    @objc private func followItemClick(){
        
        print("XXXXXX")
        
    }
    
}

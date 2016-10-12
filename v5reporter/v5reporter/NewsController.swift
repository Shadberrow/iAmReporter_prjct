//
//  ViewController.swift
//  v5reporter
//
//  Created by Yevhenii Veretennikov on 12.10.16.
//  Copyright © 2016 Yevhenii Veretennikov. All rights reserved.
//

import UIKit

let newsCellId = "NewsCellID"

class NewsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var loadMore = true
    var page = 0
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNews()
        
        // make navigation bar not translucent
        navigationController?.navigationBar.isTranslucent = false
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(NewsCell.self, forCellWithReuseIdentifier: newsCellId)
        
        // title logo
        let titleView = UIImageView(image: UIImage(named: "logo"))
        titleView.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2, width: 30, height: 30)
        titleView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleView
        
        setupNavBarButtons()
    }
    
    func fetchNews() {
        
        if page == 0 {
            posts.removeAll()
        }
        
        var url = URLRequest(url: URL(string: "http://test.mediaretail.com.ua:8095/category/all/\(page)")!)
        url.httpMethod = "POST"
        let postString = ("{\"city\":\"\"}").data(using: String.Encoding.utf8)
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.httpBody = postString
        
        URLSession.shared.dataTask(with: url) { (data, response, jsonErr) in
            if jsonErr != nil {
                print(jsonErr)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                
                let postArray = json["news"] as? [[String: AnyObject]]
                
                for dictionary in postArray! {
                    let post = Post()
                    post.setValuesForKeys(dictionary)
                    self.posts.append(post)
                }
                
                if let load = json["available"] as? Bool {
                    if load == true {
                        self.page += 1
                    } else {
                        self.loadMore = false
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            } catch let err {
                print(err)
            }
            
            }.resume()
    }

    func setupNavBarButtons() {
        let leftBarButton = UIButton(type: .custom)
        leftBarButton.setImage(UIImage(named: "menu"), for: UIControlState.normal)
        leftBarButton.addTarget(self, action: #selector(leftMenu), for: UIControlEvents.touchUpInside)
        leftBarButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        let barItemLeft = UIBarButtonItem.init(customView: leftBarButton)
        navigationItem.leftBarButtonItem = barItemLeft
        
        let rightBarButton = UIButton(type: .custom)
        rightBarButton.setImage(UIImage(named: "addNews"), for: UIControlState.normal)
        rightBarButton.addTarget(self, action: #selector(rightMenu), for: UIControlEvents.touchUpInside)
        rightBarButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        let barItemRight = UIBarButtonItem.init(customView: rightBarButton)
        navigationItem.rightBarButtonItem = barItemRight
    }
    
//    let leftMenuController = LeftMenuBar()
    
    func leftMenu() {
//        leftMenuController.showLeftMenu()
        print("left")
    }
    
    func rightMenu() {
        print("right")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCellId, for: indexPath) as! NewsCell
        cell.post = posts[indexPath.item]
        if indexPath.item == (posts.count) - 1 {
            if loadMore {
                fetchNews()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 150)
    }
    
}













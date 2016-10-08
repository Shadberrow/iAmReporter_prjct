//
//  ViewController.swift
//  iAmReporter_V2
//
//  Created by Yevhenii Veretennikov on 06.10.16.
//  Copyright © 2016 Yevhenii Veretennikov. All rights reserved.
//

import UIKit

let cellID = "NewsCell"

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var posts = [Post]()
    var newsCategory = "all"
    var city = ""
    var page = 0
    var load = true
    var refreshControl:UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memoryCapasity = 500 * 1024 * 1024
        let diskCapasity = 500 * 1024 * 1024
        let urlCache = URLCache(memoryCapacity: memoryCapasity, diskCapacity: diskCapasity, diskPath: "myDiskPath")
        URLCache.shared = urlCache
        
        self.fetchNews(newsCategory: newsCategory, city: city)
        
        let titleView = UIImageView(image: UIImage(named: "logo"))
        titleView.frame = CGRect(x: view.frame.width/2, y: view.frame.height/2, width: 30, height: 30)
        titleView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleView
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(NewsCell.self, forCellWithReuseIdentifier: cellID)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: Selector(("refresh:")), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refreshControl)
        
        
        
    }
    
    func refresh(sender:AnyObject) {
        self.collectionView?.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func fetchNews(newsCategory: String, city: String) {
        
        var url = URLRequest(url: URL(string: "http://test.mediaretail.com.ua:8095/category/\(newsCategory)/\(page)")!)
        url.httpMethod = "POST"
        let postString = ("{\"city\":\"\(city)\"}").data(using: String.Encoding.utf8)
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.httpBody = postString
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                
                if let didLoad = json["available"] as? Int {
                    if didLoad == 1 {
                        self.page += 1
                    } else {
                        self.load = false
                    }
                }
                
                if let postArray = json["news"] as? [[String: AnyObject]] {
                    for dictionary in postArray {
                        let post = Post()
                        post.setValuesForKeys(dictionary)
                        self.posts.append(post)
                    }
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
    
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! NewsCell
        newsCell.post = posts[indexPath.item]
        if indexPath.item == posts.count - 1 {
            if load {
                fetchNews(newsCategory: newsCategory, city: city)
            }
        }
        return newsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    
}



















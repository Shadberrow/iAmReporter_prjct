//
//  NewsCell.swift
//  v5reporter
//
//  Created by Yevhenii Veretennikov on 12.10.16.
//  Copyright © 2016 Yevhenii Veretennikov. All rights reserved.
//

import UIKit

private var imageCache = NSCache<AnyObject, AnyObject>()

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewsCell: BaseCell {
    
    var post: Post? {
        didSet {
            
            self.setupImage()
            
            text.text = self.post?.text
            
            if let postTheme = self.post?.theme {
                self.theme.text = postTheme
            }
            
            if let postViewCount = self.post?.countViews {
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "eye")
                attachment.bounds = CGRect.init(x: 0, y: -3, width: 12, height: 12)
                let attributedText = NSMutableAttributedString()
                attributedText.append(NSAttributedString(attachment: attachment))
                
                attributedText.append(NSAttributedString(string: " \(postViewCount)", attributes: [NSForegroundColorAttributeName: UIColor.rgb(red: 127, green: 48, blue: 103)]))
                
                self.countViews.attributedText = attributedText
            }
            
            if let postDateView = self.post?.date {
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "dd.MM.YYYY hh.mm"
                let formattedStringDate = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: postDateView as! TimeInterval))
                let str = NSAttributedString(string: "| \(formattedStringDate)", attributes: [NSForegroundColorAttributeName: UIColor.black])
                
                self.date.attributedText = str
            }
        }
    }
    
    var imageUrlString: String?
    
    func setupImage() {
        if let imageURL = post?.smallPhotoURL {
            
            let encode = imageURL.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) // encode url string
            let url = URL(string: encode!)
            
            imageUrlString = imageURL
            
            smallPhotoUrl.image = nil
            
            if let imgFromCache = imageCache.object(forKey: imageURL as AnyObject) {
                self.smallPhotoUrl.image = imgFromCache as? UIImage
                return
            }
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        let loadedImg = UIImage(data: data)
                        imageCache.setObject(loadedImg!, forKey: imageURL as AnyObject)
                        self.smallPhotoUrl.image = loadedImg
                    }
                } catch {
                    print("error load img")
                }
            }
        }
    }
    
    var smallPhotoUrl: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return image
    }()
    
    let countViews: UILabel = {
        let views = UILabel()
        views.font = UIFont(name: "HelveticaNeue-Light", size: 8)
//        views.backgroundColor = UIColor.gray
        return views
    }()
    
    let date: UILabel = {
        let date = UILabel()
        date.textAlignment = .right
        date.font = UIFont(name: "HelveticaNeue-Light", size: 8)
//        date.backgroundColor = UIColor.orange
        return date
    }()
    
    var theme: UILabel = {
        let theme = UILabel()
        theme.numberOfLines = 2
        theme.font = UIFont.boldSystemFont(ofSize: 17)
//        theme.backgroundColor = UIColor.blue
        return theme
    }()

    var text: UILabel = {
        let text = UILabel()
        text.numberOfLines = 4
        text.font = UIFont.boldSystemFont(ofSize: 17)
//        text.backgroundColor = UIColor.red
        return text
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    override func setupViews() {
        
        backgroundColor = UIColor.white
        
        addSubview(smallPhotoUrl)
        addSubview(countViews)
        addSubview(date)
        addSubview(theme)
        addSubview(text)
        addSubview(separator)
        
        addConstraintsWithFormat("H:|-8-[v0(110)]-8-[v1]-8-|", views: smallPhotoUrl, theme)
        addConstraintsWithFormat("H:|-8-[v0(35)]", views: countViews)
        addConstraintsWithFormat("H:|[v0]|", views: separator)
        
        addConstraintsWithFormat("V:|-8-[v0(100)]-9-[v1]-9-|", views: smallPhotoUrl, countViews)
        addConstraintsWithFormat("V:[v0(1)]|", views: separator)
        
        addConstraint(NSLayoutConstraint(item: date, attribute: .top, relatedBy: .equal, toItem: smallPhotoUrl, attribute: .bottom, multiplier: 1, constant: 9))
        addConstraint(NSLayoutConstraint(item: date, attribute: .left, relatedBy: .equal, toItem: countViews, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: date, attribute: .right, relatedBy: .equal, toItem: smallPhotoUrl, attribute: .right, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat("V:[v0]-9-|", views: date)
        
        addConstraint(NSLayoutConstraint(item: theme, attribute: .top, relatedBy: .equal, toItem: smallPhotoUrl, attribute: .top, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat("V:[v0(40)]", views: theme)
        
        addConstraint(NSLayoutConstraint(item: text, attribute: .top, relatedBy: .equal, toItem: theme, attribute: .bottom, multiplier: 1, constant: 3))
        addConstraint(NSLayoutConstraint(item: text, attribute: .left, relatedBy: .equal, toItem: smallPhotoUrl, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: text, attribute: .bottom, relatedBy: .equal, toItem: countViews, attribute: .bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: text, attribute: .right, relatedBy: .equal, toItem: theme, attribute: .right, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat("V:[v0]", views: text)
    }
    
}



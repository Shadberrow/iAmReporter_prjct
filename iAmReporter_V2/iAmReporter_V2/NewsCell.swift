//
//  NewsCell.swift
//  iAmReporter_V2
//
//  Created by Yevhenii Veretennikov on 06.10.16.
//  Copyright © 2016 Yevhenii Veretennikov. All rights reserved.
//

import UIKit

private var imageCache = NSCache<AnyObject, AnyObject>()

class NewsCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
            smallPhotoUrl.image = nil
            
            if let imageURL = post?.smallPhotoURL {
                
                let encode = imageURL.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) // encode url string
                let url = URL(string: encode!)
                
                if let image = imageCache.object(forKey: url as AnyObject) {
                    smallPhotoUrl.image = image as? UIImage
                } else {
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        imageCache.setObject(image!, forKey: imageURL as AnyObject)
                        
                        DispatchQueue.main.async(execute: {
                            self.smallPhotoUrl.image = image
                        })
                        
                    }).resume()
                }
                
                
//                if let image = imageCache.object(forKey: encode! as AnyObject) {
//                    smallPhotoUrl.image = image as? UIImage
//                } else {
//                    let image = UIImage(data: try! Data(contentsOf: URL(string: encode!)!))
//                    imageCache.setObject(image!, forKey: encode! as AnyObject)
//                    smallPhotoUrl.image = image
//                }
            }
            
            if let views = post?.countViews {
                
                let str = NSMutableAttributedString()
                
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "eye")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                
                str.append(NSAttributedString(attachment: attachment))
                
                str.append(NSAttributedString(string: "\(views)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8), NSForegroundColorAttributeName: UIColor(red: 127/255, green: 48/255, blue: 103/255, alpha: 1)]))
                
                countViews.attributedText = str
            }
            
            if let dateView = post?.date {
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "dd.MM.YYYY hh.mm"
                let formattedStringDate = dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: dateView as! TimeInterval))
                
                let str = NSAttributedString(string: "| \(formattedStringDate)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8), NSForegroundColorAttributeName: UIColor.black])
                
                date.attributedText = str
            }
            
            if let themeView = post?.theme {
                theme.text = themeView
            }
            
            if let textView = post?.text {
                text.text = textView
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let smallPhotoUrl: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let countViews: UILabel = {
        let views = UILabel()
        views.textColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)
//        views.backgroundColor = UIColor.yellow
        return views
    }()
    
    let date: UILabel = {
        let date = UILabel()
        date.textAlignment = .right
//        date.backgroundColor = UIColor.brown
        
        return date
    }()
    
    let theme: UILabel = {
        let theme = UILabel()
//        theme.backgroundColor = UIColor.blue
        return theme
    }()
    
    let text: UITextView = {
        let text = UITextView()
        text.textAlignment = .natural
        text.isScrollEnabled = false
        text.isUserInteractionEnabled = false
        text.font = UIFont(name: "Myriad Pro", size: 12)
        text.textColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1)
        text.textContainer.lineBreakMode = .byTruncatingTail
//        text.backgroundColor = UIColor.cyan
        return text
    }()
    
    func setupCell() {
        
        backgroundColor = UIColor.white
        
        addSubview(smallPhotoUrl)
        addSubview(countViews)
        addSubview(date)
        addSubview(theme)
        addSubview(text)
        
        addConstraintsWithFormat("H:|-8-[v0(120)]-8-[v1]|", views: smallPhotoUrl, theme)
        addConstraintsWithFormat("H:|-8-[v0(120)]-8-[v1]|", views: smallPhotoUrl, text)
        addConstraintsWithFormat("H:|-8-[v0(35)][v1(85)]", views: countViews, date)
        addConstraintsWithFormat("V:|-8-[v0(100)]-8-[v1]-8-|", views: smallPhotoUrl, countViews)
        addConstraintsWithFormat("V:|-8-[v0(100)]-8-[v1]-8-|", views: smallPhotoUrl, date)
        addConstraintsWithFormat("V:|[v0(40)][v1]|", views: theme, text)
        
        
    }
    
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}



















//
//  ApiService.swift
//  v5reporter
//
//  Created by Yevhenii Veretennikov on 12.10.16.
//  Copyright © 2016 Yevhenii Veretennikov. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    
    let baseUrl = "http://test.mediaretail.com.ua:8095/"
    
    func fetchVideos(_ completion: @escaping ([Post]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/category/all/0", completion: completion)
    }
    
//    func fetchTrendingFeed(_ completion: @escaping ([Video]) -> ()) {
//        fetchFeedForUrlString("\(baseUrl)/trending.json", completion: completion)
//    }
//    
//    func fetchSubscriptionFeed(_ completion: @escaping ([Video]) -> ()) {
//        fetchFeedForUrlString("\(baseUrl)/subscriptions.json", completion: completion)
//    }
    
    func fetchFeedForUrlString(_ urlString: String, completion: @escaping ([Post]) -> ()) {
        let city = ""
        var url = URLRequest(url: URL(string: urlString)!)
        url.httpMethod = "POST"
        let postString = ("{\"city\":\"\(city)\"}").data(using: String.Encoding.utf8)
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.httpBody = postString
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: AnyObject]] {
                    
                    DispatchQueue.main.async(execute: {
//                        completion(jsonDictionaries.map({return Post(dictionary: $0)}))
                    })
                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }) .resume()
    }
    
}

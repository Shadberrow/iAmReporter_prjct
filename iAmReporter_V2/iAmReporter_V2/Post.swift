//
//  Post.swift
//  iAmReporter_V2
//
//  Created by Yevhenii Veretennikov on 06.10.16.
//  Copyright © 2016 Yevhenii Veretennikov. All rights reserved.
//

import UIKit

class Post: NSObject {
    var city: String? // город поста
    var bigPhotoURL: String? // большая фотка
    var text: String? // сам пост
    var date: AnyObject? // дата поста
    var countViews: NSValue? // количество просмотров
    var newsUUID: String? // айди поста
    var smallPhotoURL: String? // маленькая фотка
    var theme: String? // тема/заголовок поста
}

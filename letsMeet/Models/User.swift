//
//  User.swift
//  letsMeet
//
//  Created by aisenur on 15.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

struct User: CreateProfileViewModel {
    
    var userName: String?
    var job: String?
    var age: Int?
    var imageURL: String?
    var imageURL2: String?
    var imageURL3: String?
    var minAgeCriteria: Int?
    var maxAgeCriteria: Int?
    var userId: String
    
    init(informations: [String: Any]) {
        self.userName = informations["nameSurname"] as? String ?? ""
        self.age = informations["age"] as? Int
        self.job = informations["job"] as? String
    
        self.imageURL = informations["imageURL"] as? String
        self.imageURL2 = informations["imageURL2"] as? String
        self.imageURL3 = informations["imageURL3"] as? String
        
        self.userId = informations["uuid"] as? String ?? ""
        
        self.minAgeCriteria = informations["minAgeCriteria"] as? Int
        self.maxAgeCriteria = informations["maxAgeCriteria"] as? Int
    }
    
    func createUserProfileViewModel() -> UserProfileViewModel {
        let attrText = NSMutableAttributedString(string: userName ?? "", attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .semibold)])
        
        let ageStr = age != nil ? "\(age!)" : "--"
        attrText.append(NSMutableAttributedString(string: ", \(ageStr)", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .thin)]))
        
        let jobStr = job != nil ? "\(job!)" : "--"
        attrText.append(NSMutableAttributedString(string: "\n\(jobStr)", attributes: [.font: UIFont.systemFont(ofSize: 21, weight: .regular)]))
        
        var imgURLs = [String]()
        
        if let url = imageURL, !(url.isEmpty) { imgURLs.append(url) }
        if let url = imageURL2, !(url.isEmpty) { imgURLs.append(url) }
        if let url = imageURL3, !(url.isEmpty) { imgURLs.append(url) }
        
        return UserProfileViewModel(attrString: attrText, imageNames: imgURLs, informationAlignment: .left, userId: self.userId)
    }
}

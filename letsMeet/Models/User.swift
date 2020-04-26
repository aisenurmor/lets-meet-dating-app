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
    var imageURL: String
    var userId: String
    
    init(informations: [String: Any]) {
        self.userName = informations["nameSurname"] as? String ?? ""
        self.age = informations["age"] as? Int
        self.job = informations["job"] as? String
    
        let imageURL = informations["imageURL"] as? String ?? ""
        self.imageURL = imageURL
        
        self.userId = informations["uuid"] as? String ?? ""
    }
    
    func createUserProfileViewModel() -> UserProfileViewModel {
        let attrText = NSMutableAttributedString(string: userName ?? "", attributes: [.font: UIFont.systemFont(ofSize: 28, weight: .semibold)])
        
        let ageStr = age != nil ? "\(age!)" : "--"
        attrText.append(NSMutableAttributedString(string: ", \(ageStr)", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .thin)]))
        
        let jobStr = job != nil ? "\(job!)" : "--"
        attrText.append(NSMutableAttributedString(string: "\n\(jobStr)", attributes: [.font: UIFont.systemFont(ofSize: 21, weight: .regular)]))
        
        return UserProfileViewModel(attrString: attrText, imageNames: [imageURL], informationAlignment: .left)
    }
}

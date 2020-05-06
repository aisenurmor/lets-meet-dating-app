//
//  Advertisement.swift
//  letsMeet
//
//  Created by aisenur on 16.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

struct Advertisement: CreateProfileViewModel {
    
    let title: String
    let brandName: String
    let bannerImageName: String
    
    func createUserProfileViewModel() -> UserProfileViewModel {
        let attrText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 35, weight: .heavy)])
        attrText.append(NSMutableAttributedString(string: "\n\(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .bold)]))
        
        return UserProfileViewModel(attrString: attrText, imageNames: [bannerImageName], informationAlignment: .center, userId: "")
    }
}

//
//  MatchingCell.swift
//  letsMeet
//
//  Created by aisenur on 14.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class MatchingCell: ListCell<Matching> {
    
    let imgProfile = UIImageView(image: UIImage(named: "person3"), contentMode: .scaleAspectFill)
    let lblUserName = UILabel(text: "Aise", font: .systemFont(ofSize: 15), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
    override var data: Matching! {
        didSet {
            lblUserName.text = data.username
            imgProfile.sd_setImage(with: URL(string: data.profileImageURL))
        }
    }
    
    override func creatViews() {
        super.creatViews()
        
        imgProfile.clipsToBounds = true
        imgProfile.resize(.init(width: 80, height: 80))
        imgProfile.layer.cornerRadius = 40
        imgProfile.addBorder(width: 3, color: .darkGray)
        
        createStackView(createStackView(imgProfile, alignment: .center), lblUserName)
    }
}

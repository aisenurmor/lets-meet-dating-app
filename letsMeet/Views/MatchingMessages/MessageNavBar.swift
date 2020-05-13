//
//  MessageNavBar.swift
//  letsMeet
//
//  Created by aisenur on 12.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class MessageNavBar: UIView {
    
    let userImageProfile = CircleImageView(width: 50, image: #imageLiteral(resourceName: "person2"))
    let lblUserName = UILabel(text: "Yusuf", font: .systemFont(ofSize: 17), textColor: .darkGray, textAlignment: .center)
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.4392156863, green: 0.631372549, blue: 1, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.4392156863, green: 0.631372549, blue: 1, alpha: 1))
    
    fileprivate let matching: Matching
    
    init(matching: Matching) {
        self.matching = matching
        lblUserName.text = matching.username
        userImageProfile.sd_setImage(with: URL(string: matching.profileImageURL))
        super.init(frame: .zero)
        
        backgroundColor = .white
        addShadow(opacity: 0.2, radius: 10, offset: .init(width: 0, height: 6), color: .init(white: 0, alpha: 0.4))
        
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.resize(.init(width: 25, height: 25))
        flagButton.imageView?.contentMode = .scaleAspectFit
        flagButton.resize(.init(width: 25, height: 25))
        
        let centerSV = createHorizontalStackView(createStackView(userImageProfile, lblUserName, spacing: 10, alignment: .center), alignment: .center)
        createHorizontalStackView(backButton, centerSV, flagButton).withMargin(.init(top: 0, left: 18, bottom: 0, right: 18))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


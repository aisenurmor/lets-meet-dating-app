//
//  NavbarStackView.swift
//  letsMeet
//
//  Created by aisenur on 15.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class NavbarStackView: UIStackView {
    
    let logo = UIImageView(image: #imageLiteral(resourceName: "Untitled"))
    let profileButton = UIButton(type: .system)
    let chatButton = UIButton(type: .system)
    
    let userImage = UIImage(named: "user")
    let chatImage = UIImage(named: "talk")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 60).isActive = true
//        isLayoutMarginsRelativeArrangement = true
//        layoutMargins = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        logo.contentMode = .scaleAspectFit
        
        profileButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.contentMode = .left
        profileButton.setImage(userImage!.withRenderingMode(.alwaysOriginal), for: .normal)
        profileButton.imageView?.contentMode = .scaleAspectFit
        
        chatButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        chatButton.contentMode = .right
        chatButton.setImage(chatImage!.withRenderingMode(.alwaysOriginal), for: .normal)
        chatButton.imageView?.contentMode = .scaleAspectFit
        
        [profileButton, logo, chatButton].forEach { (i) in
           addArrangedSubview(i)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init oluşturulmadı.")
    }
}

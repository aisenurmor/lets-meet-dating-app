//
//  MatchingNavBar.swift
//  letsMeet
//
//  Created by aisenur on 10.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class MatchingNavBar: UIView {
    
    var backButton = UIButton(image: UIImage(named: "back")!, tintColor: #colorLiteral(red: 0.4392156863, green: 0.631372549, blue: 1, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addShadow(opacity: 0.2, radius: 10, offset: .init(width: 0, height: 6), color: .init(white: 0, alpha: 0.4))
        
        let imgIcon = UIImageView(image: UIImage(named: "talk")?.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        imgIcon.tintColor = #colorLiteral(red: 0.2, green: 0.8509803922, blue: 0.6980392157, alpha: 1)
        
        let lblMessage = UILabel(text: "Messages", font: UIFont.boldSystemFont(ofSize: 21), textColor: #colorLiteral(red: 0.4392156863, green: 0.4352941176, blue: 0.8274509804, alpha: 1), textAlignment: .center, numberOfLines: 1)
        let lblFeed = UILabel(text: "Feed", font: UIFont.boldSystemFont(ofSize: 21), textColor: #colorLiteral(red: 0.2, green: 0.8509803922, blue: 0.6980392157, alpha: 1), textAlignment: .center, numberOfLines: 1)
        
        createStackView(imgIcon.setHeight(35), createHorizontalStackView(lblMessage, lblFeed, distribution: .fillEqually)).withMargin(.init(top: 10, left: 18, bottom: 0, right: 18))
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 25, height: 25))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

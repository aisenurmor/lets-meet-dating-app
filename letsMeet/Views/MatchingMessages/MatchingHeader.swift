//
//  MatchingHeader.swift
//  letsMeet
//
//  Created by aisenur on 14.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class MatchingHeader: UICollectionReusableView {
    
    let lblMatches = UILabel(text: "Your Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.4392156863, green: 0.631372549, blue: 1, alpha: 1))
    let lblMessages = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.4392156863, green: 0.631372549, blue: 1, alpha: 1))
    let matchesHorizontalVC = MatchingHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createStackView(createStackView(lblMatches).padLeft(16), matchesHorizontalVC.view, createStackView(lblMessages).padLeft(16), spacing: 20).withMargin(.init(top: 22, left: 0, bottom: 16, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

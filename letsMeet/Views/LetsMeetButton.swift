//
//  LetsMeetButton.swift
//  letsMeet
//
//  Created by aisenur on 30.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class LetsMeetButton: UIButton {
    
    init(title: String, height: CGFloat?) {
        super.init(frame: .zero)
        
        heightAnchor.constraint(equalToConstant: 45).isActive = true
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.cornerRadius = 8
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        setTitle(title, for: .normal)
        setTitleColor(.gray, for: .normal)
        
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

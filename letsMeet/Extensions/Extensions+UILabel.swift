//
//  Extensions+UILabel.swift
//  letsMeet
//
//  Created by aisenur on 9.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    convenience init(text: String? = nil, font: UIFont? = .systemFont(ofSize: 15), textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}

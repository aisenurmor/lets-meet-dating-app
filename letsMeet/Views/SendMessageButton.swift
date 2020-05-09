//
//  SendMessageButton.swift
//  letsMeet
//
//  Created by aisenur on 7.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {
    
    let gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        editLayer(rect: rect)
    }
    
    fileprivate func editLayer(rect: CGRect) {
        let startColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        let finishColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        
        gradientLayer.colors = [startColor.cgColor, finishColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}

//
//  KeepSwipingButton.swift
//  letsMeet
//
//  Created by aisenur on 7.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class KeepSwipingButton: UIButton {
    
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
        
        let cornerRad = rect.height / 2
        
        let maskLayer = CAShapeLayer()
        let maskPath = CGMutablePath()
        
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRad).cgPath)
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerRadius: cornerRad).cgPath)
        maskLayer.fillRule = .evenOdd
        maskLayer.path = maskPath
        gradientLayer.mask = maskLayer
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.cornerRadius = cornerRad
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}


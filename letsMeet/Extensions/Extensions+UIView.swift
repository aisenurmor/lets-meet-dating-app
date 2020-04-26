//
//  Extensions+UIView.swift
//  letsMeet
//
//  Created by aisenur on 14.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

struct AnchorConstraints {
    var top: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var trailing: NSLayoutConstraint?
    var leading: NSLayoutConstraint?
    var width: NSLayoutConstraint?
    var height: NSLayoutConstraint?
    
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) -> AnchorConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchorConstraints = AnchorConstraints()
        
        if let top = top {
            anchorConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        if let bottom = bottom {
            anchorConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        if let leading = leading {
            anchorConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        if let trailing = trailing {
            anchorConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchorConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        if size.height != 0 {
            anchorConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchorConstraints.top, anchorConstraints.bottom, anchorConstraints.leading, anchorConstraints.trailing, anchorConstraints.width, anchorConstraints.height].forEach { $0?.isActive = true }
        
        return anchorConstraints
    }
    
    func fillSuperView(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let sTop = superview?.topAnchor {
            topAnchor.constraint(equalTo: sTop, constant: padding.top).isActive = true
        }
        if let sBottom = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: sBottom, constant: -padding.bottom).isActive = true
        }
        if let sLeading = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: sLeading, constant: padding.left).isActive = true
        }
        if let sTrailing = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: sTrailing, constant: -padding.right).isActive = true
        }
    }
    
    func centerPositionSuperView(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
}

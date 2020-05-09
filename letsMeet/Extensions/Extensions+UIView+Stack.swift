//
//  Extensions+UIView+Stack.swift
//  letsMeet
//
//  Created by aisenur on 9.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    fileprivate func _createStackView(_ axis: NSLayoutConstraint.Axis = .vertical, views: [UIView], spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        
        let sv = UIStackView(arrangedSubviews: views)
        sv.axis = axis
        sv.spacing = spacing
        sv.alignment = alignment
        sv.distribution = distribution
        addSubview(sv)
        sv.fillSuperView()
        
        return sv
    }
    
    @discardableResult
    func createStackView(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _createStackView(.vertical, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    func createHorizontalStackView(_ views: UIView..., spacing: CGFloat = 0, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
        return _createStackView(.horizontal, views: views, spacing: spacing, alignment: alignment, distribution: distribution)
    }
    
    @discardableResult
    func resize<T: UIView>(_ size: CGSize) -> T {
        translatesAutoresizingMaskIntoConstraints = true
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self as! T
    }
    
    func setHeight(_ height: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    func setWidth(_ width: CGFloat) -> UIView {
        translatesAutoresizingMaskIntoConstraints = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    func addBorder<T: UIView>(width: CGFloat, color: UIColor) -> T {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        return self as! T
    }
}


extension UIEdgeInsets {
    static public func allEdge(_ value: CGFloat) -> UIEdgeInsets {
        return .init(top: value, left: value, bottom: value, right: value)
    }
}

extension UIImageView {
    convenience init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
}

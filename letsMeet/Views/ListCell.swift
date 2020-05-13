//
//  ListCell.swift
//  letsMeet
//
//  Created by aisenur on 9.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

open class ListCell<T>: UICollectionViewCell {
    
    var data: T!
    var controllerToAdd: UIViewController?
    
    public let seperateView = UIView(backgroundColor: UIColor(white: 0, alpha: 0.65))
    
    func addSeperate(leftSpacing: CGFloat = 0) {
        addSubview(seperateView)
        seperateView.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: leftSpacing, bottom: 0, right: 0), size: .init(width: 0, height: 0.5))
    }
    
    func addSeperate(leadingAnchor: NSLayoutXAxisAnchor) {
        addSubview(seperateView)
        seperateView.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        creatViews()
    }
    
    open func creatViews() {}
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  TabbarStackView.swift
//  letsMeet
//
//  Created by aisenur on 14.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class TabbarStackView: UIStackView {
    
    static func createButton(image: UIImage, tintColor: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = tintColor
        btn.imageView?.contentMode = .scaleAspectFill
        
        return btn
    }
    
    let btnReload = createButton(image: #imageLiteral(resourceName: "reload"), tintColor: #colorLiteral(red: 0.2, green: 0.8509803922, blue: 0.6980392157, alpha: 1))
    let btnClose = createButton(image: #imageLiteral(resourceName: "close"), tintColor: #colorLiteral(red: 0.9882352941, green: 0.3607843137, blue: 0.3960784314, alpha: 1))
    let btnSuperLike = createButton(image: #imageLiteral(resourceName: "star"), tintColor: #colorLiteral(red: 0.9960784314, green: 0.8274509804, blue: 0.1882352941, alpha: 1))
    let btnLike = createButton(image: #imageLiteral(resourceName: "heart"), tintColor: #colorLiteral(red: 0.9882352941, green: 0.3607843137, blue: 0.3960784314, alpha: 1))
    let btnBoost = createButton(image: #imageLiteral(resourceName: "thunder"), tintColor: #colorLiteral(red: 0.4235294118, green: 0.4745098039, blue: 0.8823529412, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        [btnReload, btnClose, btnSuperLike, btnLike, btnBoost].forEach { (btn) in
            self.addArrangedSubview(btn)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init eklenmedi.")
    }
}

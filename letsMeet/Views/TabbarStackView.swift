//
//  TabbarStackView.swift
//  letsMeet
//
//  Created by aisenur on 14.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class TabbarStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let btn = UIButton(type: .system)
        btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        
        return btn
    }
    
    let btnReload = createButton(image: #imageLiteral(resourceName: "reload (1)"))
    let btnClose = createButton(image: #imageLiteral(resourceName: "close"))
    let btnSuperLike = createButton(image: #imageLiteral(resourceName: "star"))
    let btnLike = createButton(image: #imageLiteral(resourceName: "heart (4)"))
    let btnBoost = createButton(image: #imageLiteral(resourceName: "boost"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 60).isActive = true
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

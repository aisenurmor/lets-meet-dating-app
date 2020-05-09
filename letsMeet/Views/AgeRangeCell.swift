//
//  AgeRangeCell.swift
//  letsMeet
//
//  Created by aisenur on 26.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 90
        
        return slider
    }()
    
    let lblMin: UILabel = {
        let lbl = AgeRangeLabel()
        lbl.text = "Min 18"
        lbl.font = UIFont.systemFont(ofSize: 15)
        
        return lbl
    }()
    
    let lblMax: UILabel = {
        let lbl = AgeRangeLabel()
        lbl.text = "Max 32"
        lbl.font = UIFont.systemFont(ofSize: 15)
        
        return lbl
    }()
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 70, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [lblMin, minSlider]),
            UIStackView(arrangedSubviews: [lblMax, maxSlider])
        ])
        stackView.axis = .vertical
        stackView.spacing = 15
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 15, left: 15, bottom: 15, right: 15))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

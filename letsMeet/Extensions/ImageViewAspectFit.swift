//
//  ImageViewAspectFit.swift
//  letsMeet
//
//  Created by aisenur on 9.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import UIKit

class ImageViewAspectFit: UIImageView {
    
    convenience init(image: UIImage? = nil, cornerRadius: CGFloat = 0) {
        self.init(image: image)
        self.layer.cornerRadius = cornerRadius
    }
    
    convenience init() {
        self.init(image: nil)
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

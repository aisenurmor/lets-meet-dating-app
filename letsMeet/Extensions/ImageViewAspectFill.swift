//
//  ImageViewAspectFill.swift
//  letsMeet
//
//  Created by aisenur on 9.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import UIKit

class ImageViewAspectFill: UIImageView {
    
    convenience init() {
        self.init(image: nil)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}

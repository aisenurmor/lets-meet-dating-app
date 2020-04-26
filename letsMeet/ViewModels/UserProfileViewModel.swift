//
//  UserProfileViewModel.swift
//  letsMeet
//
//  Created by aisenur on 16.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class UserProfileViewModel {
    let attrString: NSAttributedString
    let imageNames: [String]
    let informationAlignment: NSTextAlignment
    
    init(attrString: NSAttributedString, imageNames: [String], informationAlignment: NSTextAlignment) {
        self.attrString = attrString
        self.imageNames = imageNames
        self.informationAlignment = informationAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imgURL = imageNames[imageIndex]
            
            if imageNames.count > 1 {
                imageIndexObserver?(imgURL, imageIndex)
            }
        }
    }
    
    var imageIndexObserver: ((String, Int) -> ())?
    
    func nextImage() {
        imageIndex = imageIndex + 1 >= imageNames.count ? 0 : imageIndex + 1
    }
    
    func previousImage() {
        imageIndex = imageIndex - 1 < 0 ? imageNames.count - 1 : imageIndex - 1
    }
}


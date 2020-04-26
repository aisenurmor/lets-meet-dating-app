//
//  Bindable.swift
//  letsMeet
//
//  Created by aisenur on 20.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation

class Bindable<K> {
    var value: K? {
        didSet {
           observer?(value)
        }
    }
    
    var observer: ((K?) -> ())?
    
    func assignValue(observer: @escaping (K?) -> ()) {
        self.observer = observer
    }
}

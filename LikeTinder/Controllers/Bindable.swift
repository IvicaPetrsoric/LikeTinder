//
//  Bindable.swift
//  LikeTinder
//
//  Created by ivica petrsoric on 05/01/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping(T?) -> ()) {
        self.observer = observer
    }
    
}

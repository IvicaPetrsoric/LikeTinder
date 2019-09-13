//
//  Match.swift
//  LikeTinder
//
//  Created by ivica petrsoric on 13/09/2019.
//  Copyright © 2019 ivica petrsoric. All rights reserved.
//

import Foundation

struct Match {
    let name, profileImageUrl, uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}

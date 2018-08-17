//
//  PrototypePage.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation

struct PrototypePage: Codable {
    
    let id: Int
    let imageName: String
    var transitions: [PrototypeTransition]
    var image: Image?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageName
        case transitions
    }
    
    init(id: Int, imageName: String, transitions: [PrototypeTransition] = [], image: Image? = nil) {
        self.id = id
        self.imageName = imageName
        self.transitions = transitions
        self.image = image
    }
}

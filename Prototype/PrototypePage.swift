//
//  PrototypePage.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import Foundation

class PrototypePage: Codable {
    let id: Int
    let imageName: String
    let transitions: [PrototypeTransition]
    var image: Image?
    
    enum CodingKeys: String, CodingKey {
        case id
        case imageName
        case transitions
    }
    
    init(id: Int, imageName: String, transitions: [PrototypeTransition], image: Image?) {
        self.id = id
        self.imageName = imageName
        self.transitions = transitions
        self.image = image
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(Int.self, forKey: .id)
        imageName = try values.decode(String.self, forKey: .imageName)
        transitions = try values.decode([PrototypeTransition].self, forKey: .transitions)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(transitions, forKey: .transitions)
    }
}

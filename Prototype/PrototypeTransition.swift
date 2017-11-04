//
//  PrototypeTransition.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
    import CoreGraphics
#endif

enum PrototypeTransitionTyp: String, Codable {
    case none
    case fade
    case pushRight
    case pushLeft
    case slideUp
    case slideDown
}

class PrototypeTransition: Codable {
    let id: Int
    let frame: CGRect
    let destinationID: Int
    let transitionType: PrototypeTransitionTyp
    
    init(id: Int, frame: CGRect, destinationID: Int, transitionType: PrototypeTransitionTyp) {
        self.id = id
        self.frame = frame
        self.destinationID = destinationID
        self.transitionType = transitionType
    }
}

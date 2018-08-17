//
//  PrototypeTransition.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
    import CoreGraphics
#endif

struct PrototypeTransition: Codable {
    
    let id: Int
    let frame: CGRect
    let transitionType: PrototypeTransitionType
    var destination: PrototypeTransitionDestination
    let automaticTransitionTimer: Double?
    
    init(id: Int,
         frame: CGRect,
         transitionType: PrototypeTransitionType,
         destination: PrototypeTransitionDestination,
         automaticTransitionTime: Double? = nil) {
        
        self.id = id
        self.frame = frame
        self.transitionType = transitionType
        self.destination = destination
        self.automaticTransitionTimer = automaticTransitionTime
    }
}

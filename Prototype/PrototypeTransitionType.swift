//
//  PrototypeTransitionType.swift
//  Pods
//
//  Created by Paul Schmiedmayer on 11/12/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

enum PrototypeTransitionType: String, Codable {
    case none
    case fade
    case pushRight
    case pushLeft
    case slideUp
    case slideDown
}

extension PrototypeTransitionType {
    static prefix func ! (transitionType: PrototypeTransitionType) -> PrototypeTransitionType {
        switch transitionType {
        case .pushRight:
            return .pushLeft
        case .pushLeft:
            return .pushRight
        case .slideUp:
            return .slideDown
        case .slideDown:
            return .slideUp
        default:
            return transitionType
        }
    }
}

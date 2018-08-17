//
//  CGPointExtension.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import CoreGraphics
import Foundation

extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func + (lhs: CGSize, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.width + rhs.x, y: lhs.height + rhs.y)
    }
    
    static func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
    
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func - (lhs: CGSize, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.width - rhs.x, y: lhs.height - rhs.y)
    }
    
    static func - (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
    }
}

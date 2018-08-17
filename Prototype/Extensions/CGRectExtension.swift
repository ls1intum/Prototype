//
//  CGRectExtension.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import CoreGraphics

extension CGRect {
    static func * (rect: CGRect, scalar: CGFloat) -> CGRect {
        return CGRect(x: rect.origin.x * scalar,
                      y: rect.origin.y * scalar,
                      width: rect.width * scalar,
                      height: rect.height * scalar)
    }
    
    static func * (rect: CGRect, scalar: CGVector) -> CGRect {
        return CGRect(x: rect.origin.x * scalar.dx,
                      y: rect.origin.y * scalar.dy,
                      width: rect.width * scalar.dx,
                      height: rect.height * scalar.dy)
    }
    
    func flipiOSCS(inRect rect: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: self.origin.x,
                                      y: rect.size.height - self.origin.y - self.size.height),
                      size: self.size)
    }
}

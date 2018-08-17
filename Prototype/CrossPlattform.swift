//
//  CrossPlattform.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
    
    public typealias View = NSView
    typealias Label = NSTextField
    typealias Button = NSButton
    typealias Image = NSImage
    typealias ImageView = NSImageView
    typealias Color = NSColor
    
#elseif os(iOS) || os(tvOS)
    import UIKit
    
    public typealias View = UIView
    typealias Label = UILabel
    typealias Button = UIButton
    typealias Image = UIImage
    typealias ImageView = UIImageView
    typealias Color = UIColor
    
#endif

#if os(OSX)
    extension NSView {
        var alpha: CGFloat {
            set {
                alphaValue = newValue
            }
            get {
                return alphaValue
            }
        }
        
        var transform: CGAffineTransform {
            set {
                wantsLayer = true
                layer?.setAffineTransform(transform)
            }
            get {
                wantsLayer = true
                guard let layer = layer else {
                    return CGAffineTransform.identity
                }
                return layer.affineTransform()
            }
        }
    }
#endif

//
//  ViewController.swift
//  Prototype Example macOS
//
//  Created by Paul Schmiedmayer on 7/15/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import Cocoa
import Prototype

class ViewController: NSViewController, PrototypeViewDelegate {

    func willChange(toPageID pageID: Int) {
        print("Prototype Example macOS - Will change to PrototypePage with ID: \(pageID)")
    }
    
    func didChange(toPageID pageID: Int) {
        print("Prototype Example macOS - Did change to PrototypePage with ID: \(pageID)")
    }
}

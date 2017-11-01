//
//  ViewController.swift
//  Prototype Example
//
//  Created by Paul Schmiedmayer on 7/15/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import UIKit
import Prototype

class ViewController: UIViewController, PrototypeViewDelegate {
    
    func willChange(toPageID pageID: Int) {
        print("Prototype Example iOS - Will change to PrototypePage with ID: \(pageID)")
    }
    
    func didChange(toPageID pageID: Int) {
        print("Prototype Example iOS - Did change to PrototypePage with ID: \(pageID)")
    }
    
}

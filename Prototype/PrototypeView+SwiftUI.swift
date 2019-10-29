//
//  PrototypeView+SwiftUI.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 10/29/19.
//  Copyright © 2019 Paul Schmiedmayer. All rights reserved.
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI
#if os(OSX)
    import Cocoa
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif

#if os(OSX)
    public typealias ViewController = NSViewController
    @available(macOS 10.15, *)
    public typealias ViewControllerRepresentable = NSViewControllerRepresentable
#elseif os(iOS) || os(tvOS)
    public typealias ViewController = UIViewController
    @available(iOS 13.0, tvOS 13.0, *)
    public typealias ViewControllerRepresentable = UIViewControllerRepresentable
#endif

@available(iOS 13.0, tvOS 13.0, macOS 10.15, *)
public class PrototypeViewController: ViewController {
    fileprivate var prototypeView: PrototypeView? {
        get {
            self.view as? PrototypeView
        }
        set {
            guard let newValue = newValue else {
                return
            }
            self.view = newValue
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
public struct PrototypeContainer: ViewControllerRepresentable {
    public var prototypeName: Binding<String>
    @State public var delegate: PrototypeViewDelegate?
    @State public var startPage: Int?

    public init(prototypeName: Binding<String>, delegate: PrototypeViewDelegate? = nil, startPage: Int? = nil) {
        self.prototypeName = prototypeName
        self.delegate = delegate
        self.startPage = startPage
    }
    
    #if os(OSX)
    public func makeNSViewController(context: NSViewControllerRepresentableContext<PrototypeContainer>) -> PrototypeViewController {
        makeViewController(context: context)
    }

    public func updateNSViewController(_ prototypeViewController: PrototypeViewController, context: NSViewControllerRepresentableContext<PrototypeContainer>) {
        updateViewController(prototypeViewController, context: context)
    }

    #elseif os(iOS) || os(tvOS)
    public func makeUIViewController(context: Context) -> PrototypeViewController {
        makeViewController(context: context)
    }

    public func updateUIViewController(_ prototypeViewController: PrototypeViewController, context: Context) {
        updateViewController(prototypeViewController, context: context)
    }
    #endif
    
    private func makeViewController(context: Context) -> PrototypeViewController {
        PrototypeViewController()
    }
    
    private func updateViewController(_ prototypeViewController: PrototypeViewController, context: Context) {
        prototypeViewController.prototypeView?.prototypeName = prototypeName.wrappedValue
        prototypeViewController.prototypeView?.delegate = delegate
        if let startPage = startPage {
            prototypeViewController.prototypeView?.startPage = startPage
        }
    }
}
#endif

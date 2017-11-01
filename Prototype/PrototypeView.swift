//
//  PrototypeView.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

#if os(OSX)
    import Cocoa
#elseif os(iOS) || os(tvOS)
    import UIKit
#endif

@objc public protocol PrototypeViewDelegate: class {
    func willChange(toPageID pageID: Int)
    func didChange(toPageID pageID: Int)
}

@IBDesignable public class PrototypeView: View {
    
    private struct Constants {
        static let buttonColor = Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        static let fadeInAndOutButtonsTime = 0.1
        static let showButtonsTime = 0.5
        static let animationTime = 0.25
        
        static let noPrototypeName = ""
        static let noStartPage = -1
    }
    
    @IBInspectable public var prototypeName: String = Constants.noPrototypeName {
        didSet {
            loadPrototype()
        }
    }
    @IBInspectable public var startPage: Int = Constants.noStartPage {
        didSet {
            if startPage != Constants.noStartPage, let page = prototype?.pages.filter({$0.id == startPage}).first {
                currentPage = page
            }
        }
    }
    @IBInspectable public var showTransitionsInIB: Bool = false
    @IBOutlet public weak var delegate: PrototypeViewDelegate?
    
    var prototype: Prototype? {
        didSet {
            if let prototype = prototype {
                currentPage = prototype.startPage
            }
        }
    }
    
    private var currentPage: PrototypePage? {
        didSet {
            if let currentPage = currentPage, let delegate = delegate {
                delegate.didChange(toPageID: currentPage.id)
            }
            loadPage()
        }
    }
    private let imageView = ImageView()
    
    // MARK: - Initializers
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadPrototype()
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadPrototype()
        setupView()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        loadPrototype()
        setupView()
    }
    
    private func setupView(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topConstaint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstaint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        
        self.addSubview(imageView)
        self.addConstraints([topConstaint, bottomConstaint, leftConstraint, rightConstraint])
        
        #if os(OSX)
            imageView.imageScaling = .scaleProportionallyUpOrDown
            imageView.wantsLayer = true
            imageView.layerContentsRedrawPolicy = .onSetNeedsDisplay
        #elseif os(iOS) || os(tvOS)
            imageView.contentMode = .scaleToFill
            
            let touchRecognizer = UITapGestureRecognizer(target:self, action: #selector(outsideTap(touchRecognizer:)))
            self.addGestureRecognizer(touchRecognizer)
        #endif
    }
    
    private func loadPrototype() {
        if prototype == nil && prototypeName != Constants.noPrototypeName {
            #if !TARGET_INTERFACE_BUILDER
                prototype = PrototypeFileHandler.prototype(forName: prototypeName)
            #else
                prototype = PrototypeFileHandler.prototypeInInterfaceBuilder(withName: prototypeName)
            #endif
        }
    }
    
    private func loadPage() {
        if let image = currentPage?.image {
            imageView.image = image
            
            #if os(OSX)
                imageView.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.defaultLow, for: NSLayoutConstraint.Orientation.horizontal)
                imageView.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.defaultLow, for: NSLayoutConstraint.Orientation.vertical)
                self.setNeedsDisplay(self.frame)
            #elseif os(iOS) || os(tvOS)
                self.setNeedsDisplay()
            #endif
        }
    }
    
    // MARK: - Drawing
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let currentPage = currentPage, let image = currentPage.image else {
            return
        }
        
        for subView in subviews where subView is Button {
            subView.removeFromSuperview()
        }
        
        let scale = CGVector(dx: self.bounds.size.width/image.size.width,
                             dy: self.bounds.size.height/image.size.height)
        for prototypeTransition in currentPage.transitions {
            let button = Button(frame: prototypeTransition.frame*scale)
            button.tag = prototypeTransition.id
            
            #if os(OSX)
                button.frame = button.frame.flipiOSCS(inRect: imageView.bounds)
                button.title = ""
                button.bezelStyle = .texturedSquare
                button.layerContentsRedrawPolicy = .onSetNeedsDisplay
                button.isBordered = false
                button.wantsLayer = true
                button.layer?.backgroundColor = Color.clear.cgColor
                button.target = self
                button.action = #selector(buttonPressed(button:))
                #if TARGET_INTERFACE_BUILDER
                    if showTransitionsInIB {
                        button.layer?.backgroundColor = Constants.buttonColor.cgColor
                    }
                #endif
            #elseif os(iOS) || os(tvOS)
                button.addTarget(self, action: #selector(buttonPressed(button:)), for: .primaryActionTriggered)
                
                #if os(tvOS)
                    button.backgroundColor = Constants.buttonColor
                #endif
                #if TARGET_INTERFACE_BUILDER
                    if showTransitionsInIB {
                        button.backgroundColor = Constants.buttonColor
                    }
                #endif
            #endif
            
            self.addSubview(button)
        }
    }
    
    private func perform(transition: PrototypeTransition, completion: @escaping ((Bool) -> Void)) {
        guard let image = prototype?.pages.filter({$0.id == transition.destinationID}).first?.image else {
            completion(false)
            return
        }
        
        let imageView = ImageView(image: image)
        #if os(OSX)
            imageView.imageScaling = .scaleProportionallyDown
            imageView.wantsLayer = true
            imageView.layerContentsRedrawPolicy = .onSetNeedsDisplay
        #elseif os(iOS) || os(tvOS)
            imageView.contentMode = .scaleToFill
        #endif
        
        switch transition.transitionType {
        case .none:
            completion(true)
            return
        case .pushRight:
            imageView.frame = CGRect(x: bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)
            addSubview(imageView)
        case .pushLeft:
            imageView.frame = CGRect(x: -bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)
            addSubview(imageView)
        }
        
        #if os(OSX)
            NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) in
                context.duration = Constants.animationTime
                imageView.animator().frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
            }, completionHandler: {
                imageView.removeFromSuperview()
                completion(true)
            })
        #elseif os(iOS) || os(tvOS)
            View.animate(withDuration: Constants.animationTime, animations: {
                imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            }, completion: { (finished: Bool) in
                imageView.removeFromSuperview()
                completion(finished)
            })
        #endif
    }
    
    // MARK: - User Interaction
    
    @objc func buttonPressed(button: Button) {
        guard let transition = currentPage?.transitions.filter({$0.id == button.tag}).first else {
            return
        }
        delegate?.willChange(toPageID: transition.id)
        
        perform(transition: transition, completion: { (finished: Bool) in
            if let newPage = self.prototype?.pages.filter({$0.id == transition.destinationID}).first {
                self.currentPage = newPage
            }
        })
    }
    
    #if os(OSX)
        override public func mouseDown(with event: NSEvent) {
            flashButtons()
        }
    #elseif os(iOS) || os(tvOS)
        @objc public func outsideTap(touchRecognizer: UIGestureRecognizer) {
            flashButtons()
        }
    #endif
    
    private func flashButtons() {
        for button in subviews where button is Button {
            #if os(OSX)
                button.layer?.backgroundColor = Constants.buttonColor.cgColor
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.showButtonsTime, execute: {
                    button.layer?.backgroundColor = Color.clear.cgColor
                })
            #elseif os(iOS) || os(tvOS)
                View.animate(withDuration: Constants.fadeInAndOutButtonsTime, delay: 0.0, options: .allowUserInteraction, animations: {
                    button.backgroundColor = Constants.buttonColor
                }, completion: { (finished: Bool) in
                    View.animate(withDuration: Constants.fadeInAndOutButtonsTime, delay: Constants.showButtonsTime, options: .allowUserInteraction, animations: {
                        button.backgroundColor = .clear
                    })
                })
            #endif
        }
    }
}

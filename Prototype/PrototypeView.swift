//
//  PrototypeView.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
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
    
    private enum Constants {
        static let buttonColor = #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
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
            if startPage != Constants.noStartPage, let page = prototype?.pages.first(where: { $0.id == startPage }) {
                currentPage = page
            }
        }
    }
    @IBInspectable public var showTransitionsInIB: Bool = false
    @IBOutlet public weak var delegate: PrototypeViewDelegate? // swiftlint:disable:this private_outlet
    
    var prototype: Prototype? {
        didSet {
            if let prototype = prototype {
                currentPage = prototype.startPage
            }
        }
    }
    
    private var currentPage: PrototypePage? {
        didSet {
            guard let currentPage = currentPage else {
                return
            }
            
            delegate?.didChange(toPageID: currentPage.id)
            if let automaticTransition = currentPage.transitions.filter({ $0.automaticTransitionTimer != nil })
                                              .min(by: { $0.automaticTransitionTimer! < $1.automaticTransitionTimer! }),
                                               // swiftlint:disable:previous force_unwrapping
               let automaticTransitionTime = automaticTransition.automaticTransitionTimer {
                timer = Timer.scheduledTimer(withTimeInterval: automaticTransitionTime, repeats: false, block: { _ in
                    self.perform(transition: automaticTransition)
                })
            }
            
            loadPage()
        }
    }
    private let imageView = ImageView()
    private var transitionHistory = [(originalPageId: Int, transitionType: PrototypeTransitionType)]()
    private var timer: Timer?
    
    // MARK: - Initializers
    
    public required init?(coder aDecoder: NSCoder) {
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
    
    private func loadPrototype() {
        if prototype == nil && prototypeName != Constants.noPrototypeName {
            #if !TARGET_INTERFACE_BUILDER
                prototype = PrototypeFileHandler.prototype(forName: prototypeName)
            #else
                prototype = PrototypeFileHandler.prototypeInInterfaceBuilder(withName: prototypeName)
            #endif
        }
    }
    
    private func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let topConstaint = NSLayoutConstraint(item: imageView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0)
        let bottomConstaint = NSLayoutConstraint(item: imageView,
                                                 attribute: .bottom,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .bottom,
                                                 multiplier: 1,
                                                 constant: 0)
        let leftConstraint = NSLayoutConstraint(item: imageView,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let rightConstraint = NSLayoutConstraint(item: imageView,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        
        self.addSubview(imageView)
        self.addConstraints([topConstaint, bottomConstaint, leftConstraint, rightConstraint])
        
        #if os(OSX)
            imageView.imageScaling = .scaleProportionallyUpOrDown
            imageView.wantsLayer = true
            imageView.layerContentsRedrawPolicy = .onSetNeedsDisplay
        #elseif os(iOS) || os(tvOS)
            imageView.contentMode = .scaleToFill
            
            let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(outsideTap(touchRecognizer:)))
            self.addGestureRecognizer(touchRecognizer)
        #endif
    }
    
    private func loadPage() {
        if let image = currentPage?.image {
            imageView.image = image
            
            #if os(OSX)
                imageView.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.defaultLow,
                                                                  for: NSLayoutConstraint.Orientation.horizontal)
                imageView.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.defaultLow,
                                                                  for: NSLayoutConstraint.Orientation.vertical)
                self.setNeedsDisplay(self.frame)
            #elseif os(iOS) || os(tvOS)
                self.setNeedsDisplay()
            #endif
        }
    }
    
    // MARK: - Drawing
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let currentPage = currentPage,
              let image = currentPage.image else {
            return
        }
        
        for subView in subviews where subView is Button {
            subView.removeFromSuperview()
        }
        
        let scale = CGVector(dx: self.bounds.size.width / image.size.width,
                             dy: self.bounds.size.height / image.size.height)
        for prototypeTransition in currentPage.transitions {
            let button = Button(frame: prototypeTransition.frame * scale)
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
                button.addTarget(self,
                                 action: #selector(buttonPressed(button:)),
                                 for: UIControl.Event.primaryActionTriggered)
                
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
    
    private func perform(transition: PrototypeTransition) { // swiftlint:disable:this function_body_length
        timer?.invalidate()
        
        guard let currentPage = currentPage else {
            return
        }
        
        let (destinationPageId, transitionType): (Int, PrototypeTransitionType) = {
            switch transition.destination {
            case let .page(destinationPageId):
                transitionHistory.append((currentPage.id, transition.transitionType))
                return (destinationPageId, transition.transitionType)
            case .back:
                let lastTransition = transitionHistory.popLast()
                return (lastTransition?.originalPageId ?? currentPage.id,
                        !(lastTransition?.transitionType ?? .none))
            }
        }()
        delegate?.willChange(toPageID: destinationPageId)
        
        guard let destinationPage = prototype?.pages.first(where: { $0.id == destinationPageId }),
              let destinationImage = destinationPage.image else {
            return
        }
        
        func completion() {
            self.currentPage = destinationPage
        }
        
        let destinationImageView = ImageView(image: destinationImage)
        #if os(OSX)
            destinationImageView.imageScaling = .scaleProportionallyDown
            destinationImageView.wantsLayer = true
            destinationImageView.layerContentsRedrawPolicy = .onSetNeedsDisplay
        #elseif os(iOS) || os(tvOS)
            destinationImageView.contentMode = .scaleToFill
        #endif
        destinationImageView.frame = imageView.frame
        addSubview(destinationImageView)
        
        var currentImageViewTransform = CGAffineTransform.identity
        
        switch transitionType {
        case .none:
            destinationImageView.removeFromSuperview()
            completion()
            return
        case .fade:
            destinationImageView.alpha = 0.0
        case .pushLeft: // Similar to iOS "Show" segue
            destinationImageView.transform = CGAffineTransform(translationX: -bounds.size.width / 4, y: 0)
            currentImageViewTransform = CGAffineTransform(translationX: bounds.size.width, y: 0)
            addSubview(imageView)
        case .pushRight: // Similar to reversed iOS "Show" segue
            destinationImageView.transform = CGAffineTransform(translationX: bounds.size.width, y: 0)
            currentImageViewTransform = CGAffineTransform(translationX: -bounds.size.width / 4, y: 0)
        case .slideUp:
            destinationImageView.transform = CGAffineTransform(translationX: 0, y: -bounds.size.height)
        case .slideDown:
            destinationImageView.transform = CGAffineTransform(translationX: 0, y: bounds.size.height)
        }
        
        #if os(OSX)
            NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext) in
                context.duration = Constants.animationTime
                destinationImageView.animator().transform = .identity
                destinationImageView.animator().alpha = 1.0
                self.imageView.animator().transform = currentImageViewTransform
            }, completionHandler: {
                destinationImageView.removeFromSuperview()
                self.imageView.transform = .identity
                completion()
            })
        #elseif os(iOS) || os(tvOS)
            View.animate(withDuration: Constants.animationTime,
                         animations: {
                destinationImageView.transform = .identity
                destinationImageView.alpha = 1.0
                self.imageView.transform = currentImageViewTransform
            }, completion: { (_: Bool) in
                destinationImageView.removeFromSuperview()
                self.imageView.transform = .identity
                completion()
            })
        #endif
    }
    
    // MARK: - User Interaction
    
    @objc func buttonPressed(button: Button) {
        guard let transition = currentPage?.transitions.first(where: { $0.id == button.tag }) else {
            return
        }
        
        perform(transition: transition)
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
                View.animate(withDuration: Constants.fadeInAndOutButtonsTime,
                             delay: 0.0,
                             options: UIView.AnimationOptions.allowUserInteraction,
                             animations: {
                    button.backgroundColor = Constants.buttonColor
                }, completion: { (_: Bool) in
                    View.animate(withDuration: Constants.fadeInAndOutButtonsTime,
                                 delay: Constants.showButtonsTime,
                                 options: UIView.AnimationOptions.allowUserInteraction,
                                 animations: {
                        button.backgroundColor = .clear
                    })
                })
            #endif
        }
    }
}

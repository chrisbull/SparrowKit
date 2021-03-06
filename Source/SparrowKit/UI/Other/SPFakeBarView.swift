// The MIT License (MIT)
// Copyright © 2017 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

open class SPFakeBarView: UIView {
    
    public var style: SPNavigationTitleStyle = .small {
        didSet {
            self.updateStyle()
        }
    }
    
    private var settedHeight: CGFloat = 0
    public var height: CGFloat {
        get {
            return (self.settedHeight) + (self.addStatusBarHeight ? UIViewController.statusBarHeight : 0)
        }
        set {
            self.settedHeight = newValue
            self.updateHeight()
        }
        
    }
    
    public var addStatusBarHeight: Bool = true {
        didSet {
            self.updateHeight()
        }
    }
    
    public var elementsColor: UIColor = UINavigationController.elementsColor {
        didSet {
            self.leftButton.setTitleColor(self.elementsColor)
            self.rightButton.setTitleColor(self.elementsColor)
        }
    }
    
    public var closeButtonPossition: CloseButtonPosition = .none {
        didSet {
            self.leftButton.titleLabel?.font = UIFont.system(weight: .regular, size: 17)
            self.rightButton.titleLabel?.font = UIFont.system(weight: .regular, size: 17)
            switch self.closeButtonPossition {
            case .left:
                self.leftButton.titleLabel?.font = UIFont.system(weight: .demiBold, size: 17)
            case .right:
                self.rightButton.titleLabel?.font = UIFont.system(weight: .demiBold, size: 17)
            case .none:
                break
            }
        }
    }
    
    public var titleLabel = UILabel.init()
    public var subtitleLabel = UILabel.init()
    public var leftButton = UIButton.init()
    public var rightButton = UIButton.init()
    
    private let blurView = UIVisualEffectView.init(style: .extraLight)
    private let separatorView = UIView()
    
    private var titleBottomConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    public init(style: SPNavigationTitleStyle) {
        super.init(frame: CGRect.zero)
        self.style = style
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.style = .small
        self.commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.blurView)
        self.blurView.translatesAutoresizingMaskIntoConstraints = false
        self.blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.blurView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(self.separatorView)
        self.separatorView.backgroundColor = UIColor.init(hex: "BFBFBF")
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.titleBottomConstraint = self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        self.titleBottomConstraint?.isActive = true
        
        self.addSubview(self.subtitleLabel)
        self.subtitleLabel.textColor = UIColor.init(hex: "8E8E92")
        self.subtitleLabel.font = UIFont.system(weight: .demiBold, size: 13)
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        self.subtitleLabel.bottomAnchor.constraint(equalTo: self.titleLabel.topAnchor, constant: 0).isActive = true
        
        self.leftButton.setTitleColor(self.elementsColor)
        self.leftButton.titleLabel?.textAlignment = .left
        self.leftButton.titleLabel?.font = UIFont.system(weight: .demiBold, size: 16)
        self.leftButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 0)
        self.addSubview(self.leftButton)
        self.leftButton.translatesAutoresizingMaskIntoConstraints = false
        self.leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
        self.rightButton.setTitleColor(self.elementsColor)
        self.rightButton.titleLabel?.textAlignment = .right
        self.rightButton.titleLabel?.font = UIFont.system(weight: .demiBold, size: 17)
        self.rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        self.addSubview(self.rightButton)
        self.rightButton.translatesAutoresizingMaskIntoConstraints = false
        self.rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
        self.closeButtonPossition = .none
        
        self.setContraints()
        self.updateStyle()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setContraints()
    }
    
    private func setContraints() {
        if let superview = self.superview {
            if self.topConstraint == nil {
                
                self.topConstraint = self.topAnchor.constraint(equalTo: superview.topAnchor)
                self.topConstraint?.isActive = true
                self.leadingConstraint = self.leadingAnchor.constraint(equalTo: superview.leadingAnchor)
                self.leadingConstraint?.isActive = true
                self.trailingConstraint = self.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
                self.trailingConstraint?.isActive = true
                
                self.heightConstraint = self.heightAnchor.constraint(equalToConstant: self.height)
                self.heightConstraint?.isActive = true
                self.updateHeight()
            }
        }
    }
    
    private func updateStyle() {
        switch self.style {
        case .small:
            if UIViewController.statusBarHeight == 44 {
                self.height = 88 - 44
                self.titleBottomConstraint?.constant = -12
            } else {
                self.height = 64 - 20
                self.titleBottomConstraint?.constant = -12
            }
            self.addStatusBarHeight = true
            self.titleLabel.font = UIFont.system(weight: .demiBold, size: 17)
            self.titleLabel.setCenterAlignment()
        case .stork:
            self.height = 66
            self.titleBottomConstraint?.constant = -12
            self.addStatusBarHeight = false
            self.titleLabel.font = UIFont.system(weight: .demiBold, size: 17)
            self.titleLabel.setCenterAlignment()
        case .large:
            if UIViewController.statusBarHeight == 44 {
                self.height = 140 - 44
                self.titleBottomConstraint?.constant = -8
            } else {
                self.height = 112 - 20
                self.titleBottomConstraint?.constant = -4
            }
            self.addStatusBarHeight = true
            self.titleLabel.font = UIFont.system(weight: .bold, size: 34)
            self.titleLabel.textAlignment = .left
            break
        }
        
        self.updateConstraints()
    }
    
    private func updateHeight() {
        self.heightConstraint?.constant = self.height
        self.updateConstraints()
    }
    
    public enum CloseButtonPosition {
        case left
        case right
        case none
    }
}


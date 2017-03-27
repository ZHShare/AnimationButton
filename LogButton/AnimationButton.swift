//
//  AnimationButton.swift
//  LogButton
//
//  Created by YE on 2017/3/27.
//  Copyright © 2017年 Eter. All rights reserved.
//

import UIKit

class AnimationButton: UIButton {

    // MARK: - 公开属性
    /// 标识是否是向下切换title
    var upToDown: Bool = false
    /// borderColor
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    /// borderWidth
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    /// cornerRadius
    var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    public override var isEnabled: Bool {
        didSet {
            if oldValue != isEnabled {
                if oldValue {
                    // 动画切换title，显示菊花
                    lastDisabledTitle = title(for: .disabled)
                    ib_loadingWithTitle(title: lastDisabledTitle)
                    setTitle("", for: .disabled)
                } else {
                    // 重置按钮，隐藏菊花
                    ib_resetToNormalState()
                    setTitle(lastDisabledTitle, for: .disabled)
                }
            }
        }
    }
    
    // MARK: - 私有属性
    lazy var backView = UIView()
    lazy var lblMessage = UILabel()
    lazy var indicatorView = UIActivityIndicatorView()
    fileprivate var lastTitle: String?
    fileprivate var lastDisabledTitle: String?
    fileprivate let margin: CGFloat = 8
    fileprivate var transformY: CGFloat {
        get {
            return self.frame.origin.y * (upToDown ? (-1) : 1)
        }
    }
    // MARK: - 构造方法
    required public init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        // 初始化
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        // 初始化
        setup()
    }
    
    public override var frame: CGRect {
        didSet {
            backView.frame = frame
            backView.center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        }
    }
    
    public func setBackgroundColor(_ color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let _ = imageView {
            self.setImage(nil, for: .normal)
            self.setImage(nil, for: .selected)
        }
    }
}


fileprivate extension AnimationButton {
    
    // MARK: - 私有方法
    // 初始化
    
    func setup() {
        layer.masksToBounds = true
        // 初始化backView及其子视图
        lblMessage.textColor = titleLabel?.textColor
        lblMessage.font = titleLabel?.font
        backView.addSubview(lblMessage)
        
        indicatorView.activityIndicatorViewStyle = .gray
        indicatorView.hidesWhenStopped = true
        indicatorView.sizeToFit()
        backView.addSubview(indicatorView)
        
        // 要先设置高度  再设置center
        backView.backgroundColor = UIColor.clear
        backView.alpha = 0
        
        addSubview(backView)
        
        lastTitle = currentTitle
    }
    
    // 开始转菊花
    func ib_loadingWithTitle(title: String?) {
        let color = self.titleColor(for: .disabled)
        let shadowColor = self.titleShadowColor(for: .disabled)
        if let v = self.superview {
            if v.isUserInteractionEnabled {
                v.isUserInteractionEnabled = false
            }
        }
        
        lblMessage.text = title
        lblMessage.textColor = color
        lblMessage.shadowColor = shadowColor
        lblMessage.sizeToFit()
        // 计算lblMessage 和 indicatorView 的位置
        indicatorView.centerY = backView.centerY
        lblMessage.centerY = indicatorView.centerY
        lblMessage.left = indicatorView.right + margin
        backView.right = lblMessage.right
        backView.w = indicatorView.w + margin + lblMessage.w
        backView.left = (self.w - backView.w ) * 0.5
        
        indicatorView.startAnimating()
        if title == lastTitle {
            // 如果title和旧title相同  不需要显示动画滚动
        } else {
            backView.transform=CGAffineTransform(translationX: 0, y: transformY)
        }
        UIView.animate(withDuration: 0.5) {
            self.titleLabel!.alpha = 0
            self.backView.alpha = 1
            self.backView.transform = CGAffineTransform.identity
        }
    }
    
    // 重置按钮
    func ib_resetToNormalState() {
        if let v = self.superview {
            if v.isUserInteractionEnabled == false {
                v.isUserInteractionEnabled = true
            }
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.titleLabel!.alpha = 1
            self.backView.alpha = 0
            if self.currentTitle == self.lastDisabledTitle {
                // 如果title和旧title相同  不需要显示动画滚动
            } else {
                self.backView.transform = CGAffineTransform(translationX: 0, y: self.transformY)
            }
        }) { (finished) in
            self.backView.transform = CGAffineTransform.identity
            self.indicatorView.stopAnimating()
        }
    }
}

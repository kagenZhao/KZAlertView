//
//  KZAlertBackgroundView.swift
//  KZAlertView
//
//  Created by zhaoguoqing on 2020/9/13.
//

import UIKit
import SnapKit

internal class KZAlertBackgroundView: UIView {

    private var configuration: KZAlertConfiguration
    
    private var backgroundVisualEffectView: UIVisualEffectView?
    private lazy var darkBackgroundView: UIView = UIView(frame: bounds)
    
    init(with configuration: KZAlertConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        reload(configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("UnsupportXib / Storyboard")
    }
    
    
    internal func reload(_ configuration: KZAlertConfiguration) {
        self.configuration = configuration
        backgroundColor = .clear
        clipsToBounds = true
        
        setupDarkBackground()
        setupBlurBackground()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundVisualEffectView?.frame = self.bounds
        darkBackgroundView.frame = self.bounds
    }
    
    private func setupBlurBackground() {
        backgroundVisualEffectView?.removeFromSuperview()
        backgroundVisualEffectView = nil
        if configuration.isBlurBackground {
            let blurEffect: UIBlurEffect
            if #available(iOS 13, *) {
                switch configuration.themeMode  {
                case .light:
                    blurEffect = UIBlurEffect.init(style: .systemMaterialLight)
                case .dark:
                    blurEffect = UIBlurEffect.init(style: .systemMaterialDark)
                case .followSystem:
                    blurEffect = UIBlurEffect.init(style: .systemMaterial)
                }
            } else {
                blurEffect = UIBlurEffect.init(style: configuration.themeMode.isDark(at: self) ? .dark : .extraLight)
            }
            backgroundVisualEffectView = UIVisualEffectView(effect: blurEffect)
            backgroundVisualEffectView?.isUserInteractionEnabled = false
            backgroundVisualEffectView?.frame = self.bounds
            insertSubview(backgroundVisualEffectView!, belowSubview: darkBackgroundView)
        }
    }
    
    private func setupDarkBackground() {
        if darkBackgroundView.superview == nil { addSubview(darkBackgroundView) }
        darkBackgroundView.isHidden = !configuration.isDarkBackground
        darkBackgroundView.backgroundColor = configuration.darkBackgroundColor
        darkBackgroundView.isUserInteractionEnabled = false
    }
}

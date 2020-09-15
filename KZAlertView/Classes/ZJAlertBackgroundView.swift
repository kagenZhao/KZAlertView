//
//  ZJAlertBackgroundView.swift
//  ZJAlertView
//
//  Created by zhaoguoqing on 2020/9/13.
//

import UIKit
import SnapKit

internal class ZJAlertBackgroundView: UIView {

    private let configuration: ZJAlertConfiguration
    
    private var backgroundVisualEffectView: UIVisualEffectView?
    private var darkBackgroundView: UIView!
    
    init(with configuration: ZJAlertConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        backgroundColor = .clear
        clipsToBounds = true
        setupBlurBackground()
        setupDarkBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("不支持Xib / Storyboard")
    }
    
    private func setupBlurBackground() {
        /// 不能用snap
        if configuration.isBlurBackground {
            let blurEffect = UIBlurEffect(style: .light)
            backgroundVisualEffectView = UIVisualEffectView(effect: blurEffect)
            backgroundVisualEffectView?.isUserInteractionEnabled = false
            addSubview(backgroundVisualEffectView!)
            backgroundVisualEffectView?.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            })
        }
    }
    
    private func setupDarkBackground() {
        if !configuration.darkBackgroundHidden {
            darkBackgroundView = UIView(frame: bounds)
            darkBackgroundView.backgroundColor = configuration.darkBackgroundColor
            darkBackgroundView.isUserInteractionEnabled = false
            addSubview(darkBackgroundView)
            darkBackgroundView?.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            })
        }
    }
}

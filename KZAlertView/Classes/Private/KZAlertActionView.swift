//
//  KZAlertActionView.swift
//  KZAlertView
//
//  Created by zhaoguoqing on 2020/9/13.
//

import UIKit
import SnapKit

internal class KZAlertActionView: UIView {
    
    internal var buttons: [UIButton] = []

    private let configuration: KZAlertConfiguration
        
    init?(with configuration: KZAlertConfiguration) {
        if configuration.allButtonCount == 0 {
            return nil
        }
        self.configuration = configuration
        super.init(frame: .zero)
        clipsToBounds = true
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupport Xib / Storyboard")
    }
    
    private func setupButtons() {
        let needSeparotor: Bool
        let isDetach: Bool
        switch configuration.buttonStyle {
        case .normal(hideSeparator: let value):
            needSeparotor = !value
            isDetach = false
        case .detachAndRound:
            needSeparotor = false
            isDetach = true
        }
        if isDetach {
            backgroundColor = configuration.backgroundColor.getColor(by: configuration.themeMode)
        } else {
            backgroundColor = .clear
            if needSeparotor {
                let blurView = generateBlurView()
                addSubview(blurView)
                blurView.snp.makeConstraints { (make) in
                    make.edges.equalTo(UIEdgeInsets.zero)
                }
            }
        }
        
        let topSeparotor: UIView? = {
            if needSeparotor {
                let separotor = UIView()
                separotor.backgroundColor = .clear
                addSubview(separotor)
                separotor.snp.makeConstraints { (make) in
                    make.left.right.top.equalToSuperview()
                    make.height.equalTo(configuration.buttonSeparotor)
                }
                return separotor
            } else {
                return nil
            }
        }()
        
        let cancelButton: UIButton? = configuration.cancelAction.map { (info) -> UIButton in
            let button = generateButton(info)
            button.backgroundColor = configuration.cancelButtonBackgroundColor
            button.tintColor = configuration.cancelButtonTintColor
            button.titleLabel?.font = configuration.defaultCancelButtonFont
            button.setBackgroundImage(configuration.buttonHighlightImage, for: .highlighted)
            info.configuration?(button)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            return button
        }
         
        var buttons = configuration.actions.map { (info) -> UIButton in
            let button = generateButton(info)
            button.backgroundColor = configuration.nornalButtonBackgroundColor
            button.tintColor = configuration.normalButtonTintColor
            button.titleLabel?.font = configuration.defaultNormalButtonFont
            button.setBackgroundImage(configuration.buttonHighlightImage, for: .highlighted)
            info.configuration?(button)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            return button
        }
        
        self.buttons.append(contentsOf: buttons)
        if let cancelButton = cancelButton {
            self.buttons.append(cancelButton)
        }
          
        if configuration.allButtonCount != 2 {
            /// 1 / 3...
            var tempLastView: UIView? = topSeparotor
            for i in 0..<configuration.allButtonCount {
                if let tempButton = buttons.safeRemoveFirst() ?? cancelButton {
                    addSubview(tempButton)
                    tempButton.snp.makeConstraints { (make) in
                        make.left.equalToSuperview().offset(configuration.buttonEdge.left)
                        make.right.equalToSuperview().offset(-configuration.buttonEdge.right)
                        make.top.equalTo(tempLastView?.snp.bottom ?? self.snp.top).offset(configuration.buttonEdge.top)
                        if i == configuration.allButtonCount - 1 {
                            make.bottom.equalToSuperview().offset(-configuration.buttonEdge.bottom)
                        }
                        make.height.equalTo(configuration.buttonHeight)
                    }
                    if i < configuration.allButtonCount - 1, needSeparotor {
                        let separotor = UIView()
                        separotor.backgroundColor = .clear
                        addSubview(separotor)
                        separotor.snp.makeConstraints { (make) in
                            make.top.equalTo(tempButton.snp.bottom)
                            make.left.right.equalToSuperview()
                            make.height.equalTo(configuration.buttonSeparotor)
                        }
                        tempLastView = separotor
                    } else {
                        tempLastView = tempButton
                    }
                }
            }
        } else{
            // 2
            let leftButton = buttons.safeRemoveFirst()!
            let rightButton = buttons.safeRemoveFirst() ?? cancelButton!
            addSubview(leftButton)
            addSubview(rightButton)
            leftButton.snp.makeConstraints { (make) in
                make.left.equalTo(configuration.buttonEdge.left)
                make.top.equalTo(topSeparotor?.snp.bottom ?? self.snp.top).offset(configuration.buttonEdge.top)
                make.height.equalTo(configuration.buttonHeight)
                make.bottom.equalTo(-configuration.buttonEdge.bottom)
            }
            rightButton.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(leftButton)
                make.right.equalTo(-configuration.buttonEdge.right)
                if isDetach {
                    make.left.equalTo(leftButton.snp.right).offset(max(configuration.buttonEdge.right, configuration.buttonEdge.left))
                } else {
                    make.left.equalTo(leftButton.snp.right).offset(max(configuration.buttonEdge.right, configuration.buttonEdge.left) + configuration.buttonSeparotor)
                }
                make.width.equalTo(leftButton)
            }
            if needSeparotor {
                let separotor = UIView()
                separotor.backgroundColor = .clear
                addSubview(separotor)
                separotor.snp.makeConstraints { (make) in
                    make.top.equalTo(leftButton.snp.top)
                    make.left.equalTo(leftButton.snp.right)
                    make.right.equalTo(rightButton.snp.left)
                    make.bottom.equalTo(leftButton.snp.bottom)
                }
            }
        }
    }
    
    private func generateButton(_ info: KZAlertConfiguration.AlertAction) -> UIButton {
        let isDetach: Bool
        switch configuration.buttonStyle {
        case .normal:
            isDetach = false
        case .detachAndRound:
            isDetach = true
        }
        let button = KZAlertButton(type: .system)
        button.action = info
        button.layer.masksToBounds = true
        if isDetach {
            button.layer.cornerRadius = configuration.buttonHeight / 2
        } else {
            button.layer.cornerRadius = 0
        }
        switch info.title {
        case .string(let string):
            button.setTitle(string, for: .normal)
        case .attributeString(let attributeString):
            button.setAttributedTitle(attributeString, for: .normal)
        }
        return button
    }
    
    private func generateBlurView() -> UIView {
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
        let view = UIVisualEffectView(effect: blurEffect)
//        view.alpha = 0.8
        return view
    }
    
    @objc private func buttonAction(_ sender:  KZAlertButton) {
        sender.action?.handler?()
    }
}

extension Array {
    fileprivate mutating func safeRemoveFirst() -> Element? {
        if self.count > 0 {
            return removeFirst()
        } else {
            return nil
        }
    }
}

private class KZAlertButton: UIButton {
    var action: KZAlertConfiguration.AlertAction?
}

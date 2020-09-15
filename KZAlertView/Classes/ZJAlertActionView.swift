//
//  ZJAlertActionView.swift
//  ZJAlertView
//
//  Created by zhaoguoqing on 2020/9/13.
//

import UIKit
import SnapKit

internal class ZJAlertActionView: UIView {
    
    internal var buttons: [UIButton] = []

    private let configuration: ZJAlertConfiguration
        
    init?(with configuration: ZJAlertConfiguration) {
        if configuration.actions.isEmpty, configuration.cancelAction == nil {
            return nil
        }
        self.configuration = configuration
        super.init(frame: .zero)
        backgroundColor = .clear
        clipsToBounds = true
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("不支持Xib / Storyboard")
    }
    
    private func setupButtons() {
        let allBuutonCount = configuration.allButtonCount
        guard allBuutonCount != 0 else { return }
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
            backgroundColor = configuration.contentBackgroundColor.getColor(by: configuration.themeMode)
        } else {
            backgroundColor = .clear
        }
        
        // 分割线
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
            info.configuration(button)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            // 点击事件
            return button
        }
         
        var buttons = configuration.actions.map { (info) -> UIButton in
            let button = generateButton(info)
            button.backgroundColor = configuration.nornalButtonBackgroundColor
            button.tintColor = configuration.normalButtonTintColor
            button.titleLabel?.font = configuration.defaultNormalButtonFont
            info.configuration(button)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            return button
        }
        
        self.buttons.append(contentsOf: buttons)
        if let cancelButton = cancelButton {
            self.buttons.append(cancelButton)
        }
          
        if allBuutonCount != 2 {
            // 一个按钮 / 多个按钮
            var tempLastView: UIView? = topSeparotor
            for i in 0..<allBuutonCount {
                if let tempButton = buttons.safeRemoveFirst() ?? cancelButton {
                    addSubview(tempButton)
                    tempButton.snp.makeConstraints { (make) in
                        make.left.equalToSuperview().offset(configuration.buttonEdge.left)
                        make.right.equalToSuperview().offset(-configuration.buttonEdge.right)
                        make.top.equalTo(tempLastView?.snp.bottom ?? self.snp.top).offset(configuration.buttonEdge.top)
                        if i == allBuutonCount - 1 {
                            make.bottom.equalToSuperview().offset(-configuration.buttonEdge.bottom)
                        }
                        make.height.equalTo(configuration.buttonHeight)
                    }
                    if i < allBuutonCount - 1, needSeparotor {
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
            // 两个按钮
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
        }
    }
    
    private func generateButton(_ info: ZJAlertConfiguration.AlertAction) -> UIButton {
        let isDetach: Bool
        switch configuration.buttonStyle {
        case .normal:
            isDetach = false
        case .detachAndRound:
            isDetach = true
        }
        let button = ZJAlertButton(type: .system)
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
    
    @objc private func buttonAction(_ sender: ZJAlertButton) {
        sender.action?.handler()
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

private class ZJAlertButton: UIButton {
    var action: ZJAlertConfiguration.AlertAction?
}

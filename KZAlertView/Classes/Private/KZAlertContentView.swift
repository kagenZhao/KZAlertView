//
//  KZAlertContentView.swift
//  KZAlertView
//
//  Created by zhaoguoqing on 2020/9/13.
//

import UIKit
import SnapKit

internal class KZAlertContentView: UIView {
    
    internal var textFields: [UITextField] = []
    
    private let configuration: KZAlertConfiguration
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    private var titleLabel: UILabel?
    private var messageLabel: UILabel!
    
    init(with configuration: KZAlertConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        backgroundColor = configuration.backgroundColor.getColor(by: configuration.themeMode)
        clipsToBounds = true
        setupScrollView()
        setupTitleLabel()
        setupMessageLabel()
        setupTextField()
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupport Xib / Storyboard")
    }
    
    
    internal func alertDidComplete() {
        textFields.forEach { (tf) in
            (tf as? KZAlertContentTextField)?.action.handler?(tf)
        }
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        addSubview(scrollView)
        contentView = UIView()
        scrollView.addSubview(contentView)
    }
    
    private func setupTitleLabel() {
        guard let titleInfo = configuration.title else { return }
        titleLabel = UILabel()
        titleLabel!.textAlignment = configuration.titleTextAligment
        titleLabel!.numberOfLines = configuration.titleNumberOfLines
        titleLabel!.textColor = configuration.titleColor.getColor(by: configuration.themeMode)
        titleLabel!.font = configuration.titleFont
        switch titleInfo {
        case .string(let string):
            titleLabel!.text = string
        case .attributeString(let attributeString):
            titleLabel!.attributedText = attributeString
        }
        contentView.addSubview(titleLabel!)
    }
    
    private func setupMessageLabel() {
        messageLabel = UILabel()
        messageLabel.textAlignment = configuration.messageTextAligment
        messageLabel.numberOfLines = configuration.messageNumberOfLines
        messageLabel.textColor = configuration.messageColor.getColor(by: configuration.themeMode)
        messageLabel.font = configuration.messageFont
        switch configuration.message {
        case .string(let string):
            messageLabel.text = string
        case .attributeString(let attributeString):
            messageLabel.attributedText = attributeString
        }
        contentView.addSubview(messageLabel)
    }
    
    private func setupTextField() {
        guard !configuration.textfields.isEmpty else { return }
        for (idx, info) in configuration.textfields.enumerated() {
            let tf = generateTextField(info, isLast: idx == configuration.textfields.count - 1)
            tf.tag = 1000 + idx
            contentView.addSubview(tf)
            
            textFields.append(tf)
        }
    }
    
    private func setupAutoLayout() {
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(configuration.contentEdge)
            make.width.equalTo(self).offset(-configuration.contentEdge.left - configuration.contentEdge.right)
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(configuration.scrollContentEdge)
            make.height.equalTo(contentView.snp.height).offset(configuration.contentEdge.top + configuration.contentEdge.bottom + 1).priority(.medium)
        }
        
        titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(configuration.titleLabelEdge.left)
            make.right.equalTo(-configuration.titleLabelEdge.right)
            make.top.equalTo(configuration.titleLabelEdge.top)
            make.height.greaterThanOrEqualTo(configuration.titleLabelMinHeight)
        })
        
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(configuration.messageLabelEdge.left)
            make.right.equalTo(-configuration.messageLabelEdge.right)
            make.height.greaterThanOrEqualTo(configuration.messageLabelMinHeight)
            if let titleLabel = self.titleLabel {
                make.top.equalTo(titleLabel.snp.bottom).offset(configuration.titleLabelEdge.bottom + configuration.messageLabelEdge.top)
            } else {
                make.top.equalTo(configuration.messageLabelEdge.top)
            }
            if configuration.textfields.isEmpty {
                make.bottom.equalTo(configuration.messageLabelEdge.bottom)
            }
        }
        
        var lastView: UIView = messageLabel
        for tf in textFields {
            tf.snp.makeConstraints { (make) in
                make.left.equalTo(configuration.textFieldEdge.left)
                make.right.equalTo(-configuration.textFieldEdge.right)
                if tf == textFields.first {
                    make.top.equalTo(lastView.snp.bottom).offset(configuration.textFieldAndLabelSpace + configuration.textFieldEdge.top)
                } else {
                    make.top.equalTo(lastView.snp.bottom).offset(configuration.textFieldEdge.top + configuration.textFieldEdge.bottom)
                }
                make.height.equalTo(configuration.textFieldHeight)
                if tf == textFields.last {
                    make.bottom.equalTo(configuration.textFieldEdge.bottom)
                }
            }
            lastView = tf
        }
    }
    
    
    private func generateTextField(_ info: KZAlertConfiguration.TextField, isLast: Bool) -> KZAlertContentTextField {
        let tf = KZAlertContentTextField(action: info, configuration: configuration)
        tf.textColor = configuration.textFieldDefaultTextColor
        tf.backgroundColor = configuration.textFiledBackgroudColor
        tf.delegate = self
        tf.layer.cornerRadius = configuration.textFieldCornerRadius
        tf.layer.borderColor = configuration.textFieldBorderColor.cgColor
        tf.layer.borderWidth = configuration.textFieldBorderWidth
        if isLast {
            tf.returnKeyType = .done
        } else {
            tf.returnKeyType = .next
        }
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: configuration.textFieldLeftPadding, height: configuration.textFieldHeight))
        tf.leftView = leftPaddingView
        tf.leftViewMode = .always
        info.configuration?(tf)
        return tf
    }
}

extension KZAlertContentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = contentView.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.endEditing(true)
        }
        return true
    }
}


private class KZAlertContentTextField: UITextField {
    let configuration: KZAlertConfiguration
    let action: KZAlertConfiguration.TextField
    
    init(action: KZAlertConfiguration.TextField, configuration: KZAlertConfiguration) {
        self.action = action
        self.configuration = configuration
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupport Xib / Storyboard")
    }
    
    
    override var placeholder: String? {
        set {
            super.placeholder = newValue
            if let stringValue = newValue {
                var newAttributePlaceholder: NSMutableAttributedString
                if let temp = self.attributedPlaceholder {
                    newAttributePlaceholder = NSMutableAttributedString(attributedString: temp)
                } else {
                    newAttributePlaceholder = NSMutableAttributedString(string: stringValue)
                }
                let stringRange = NSRange(location: 0, length: newAttributePlaceholder.string.count)
                newAttributePlaceholder.removeAttribute(NSAttributedString.Key.foregroundColor, range: stringRange)
                newAttributePlaceholder.addAttribute(NSAttributedString.Key.foregroundColor, value: configuration.textFieldPlaceHolderColor, range: stringRange)
                self.attributedPlaceholder = newAttributePlaceholder
            }
        }
        get {
            return super.placeholder
        }
    }
}

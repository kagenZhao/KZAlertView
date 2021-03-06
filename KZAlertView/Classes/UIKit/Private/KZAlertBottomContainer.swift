//
//  KZAlertBottomContainer.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/15.
//

import UIKit

internal class KZAlertBottomContainer: UIView {
    private let configuration: KZAlertConfiguration
        
    init(with configuration: KZAlertConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupport Xib / Storyboard")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let corders: UIRectCorner
        if configuration.vectorImage != nil {
            corders = [.bottomLeft, .bottomRight]
        } else {
            corders = .allCorners
        }
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corders, cornerRadii: CGSize(width: configuration.cornerRadius, height: configuration.cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

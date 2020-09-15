//
//  ZJAlertBottomContainer.swift
//  ZJAlertView
//
//  Created by Kagen Zhao on 2020/9/15.
//

import UIKit

internal class ZJAlertBottomContainer: UIView {
    private let configuration: ZJAlertConfiguration
        
    init(with configuration: ZJAlertConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("不支持Xib / Storyboard")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let corders: UIRectCorner
        if configuration.vectorImage != nil {
            corders = [.bottomLeft, .bottomRight]
        } else {
            corders = .allCorners
        }
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corders, cornerRadii: CGSize(width: configuration.cornerRadius, height: configuration.cornerRadius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

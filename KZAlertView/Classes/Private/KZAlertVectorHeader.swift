//
//  KZAlertVectorHeader.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/10.
//

import UIKit

internal class KZAlertVectorHeader: UIView {
    
    private let configuration: KZAlertConfiguration
    
    init?(with configuration: KZAlertConfiguration) {
        if configuration.vectorImage == nil  {
            return nil
        }
        self.configuration = configuration
        super.init(frame: .zero)
        backgroundColor = .clear
        clipsToBounds = true
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupport Xib / Storyboard")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        
        let vectorImageBgRadius: CGFloat = configuration.vectorImageRadius
        let vectorImageBgSize = CGSize(width: vectorImageBgRadius * 2, height: vectorImageBgRadius * 2)
        let vectorImageBgEdge = configuration.vectorImageEdge
        
        
        configuration.backgroundColor.getColor(by: configuration.themeMode).setFill()
        UIColor.clear.setStroke()
        
        let path = UIBezierPath()

        // 左下
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        // 左上
        path.addLine(to: CGPoint(x: 0, y: vectorImageBgRadius + configuration.cornerRadius))
        path.addArc(withCenter: CGPoint(x: configuration.cornerRadius, y: vectorImageBgRadius + configuration.cornerRadius),
                    radius: configuration.cornerRadius,
                    startAngle: .pi,
                    endAngle: .pi / 2 * 3,
                    clockwise: true)
        
        // 中间图标半圆
        path.addLine(to: CGPoint(x: rect.width - vectorImageBgSize.width - vectorImageBgEdge.left, y: vectorImageBgRadius))
        path.addArc(withCenter: CGPoint(x: rect.width / 2, y: vectorImageBgRadius),
                    radius: vectorImageBgRadius + vectorImageBgEdge.left,
                    startAngle: .pi,
                    endAngle: 0,
                    clockwise: false)
        
        // 右上
        path.addLine(to: CGPoint(x: rect.width, y: vectorImageBgRadius))
        path.addArc(withCenter: CGPoint(x: rect.width - configuration.cornerRadius, y: vectorImageBgRadius + configuration.cornerRadius),
                        radius: configuration.cornerRadius,
                        startAngle: .pi / -2,
                        endAngle: 0,
                        clockwise: true)
        
        // 右下
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.close()
        path.fill()
                
        let cycleRect = CGRect(x: rect.width / 2 - vectorImageBgRadius, y: 0, width: vectorImageBgSize.width, height: vectorImageBgSize.height)
        if configuration.vectorImageFillPercentage < 1 {
            let cyclePath = UIBezierPath(roundedRect: cycleRect, cornerRadius: vectorImageBgRadius)
            cyclePath.fill()
        }
        
        if configuration.vectorImageFillPercentage > 0 {
            let imageSize = CGSize(width: vectorImageBgSize.width * configuration.vectorImageFillPercentage, height: vectorImageBgSize.height * configuration.vectorImageFillPercentage)
            let imageEdge = UIEdgeInsets(top: (cycleRect.height - imageSize.height) / 2, left: (cycleRect.width - imageSize.width) / 2, bottom: (cycleRect.height - imageSize.height) / 2, right: (cycleRect.width - imageSize.width) / 2)
            let imageRect = CGRect(x: cycleRect.origin.x + imageEdge.left, y: cycleRect.origin.y + imageEdge.top, width: imageSize.width, height: imageSize.height)
            var vectorImage: UIImage? = configuration.vectorImage
            
            if let colorScheme = configuration.colorScheme {
                if #available(iOS 13.0, *) {
                    vectorImage = vectorImage?.withTintColor(colorScheme.getColor(by: configuration.themeMode), renderingMode: .alwaysTemplate)
                } else {
                    vectorImage = vectorImage?.withRenderingMode(.alwaysTemplate)
                    colorScheme.getColor(by: configuration.themeMode).setFill()
                }
            } else {
                vectorImage?.draw(in: imageRect)
            }
            vectorImage?.draw(in: imageRect)
        }
    }
}

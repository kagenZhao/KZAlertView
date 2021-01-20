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
        let vectorImageSpace = configuration.vectorImageSpace
        var vectorImageOffset = configuration.vectorImageOffset
        let maxR = vectorImageBgRadius + vectorImageSpace

        if vectorImageOffset.vertical >= 0 {
            vectorImageOffset.vertical = min(maxR, vectorImageOffset.vertical)
        } else {
            vectorImageOffset.vertical = -min(abs(maxR), vectorImageOffset.vertical)
        }
        
        if vectorImageOffset.horizontal >= 0 {
            vectorImageOffset.horizontal = min((rect.width / 2 - maxR), vectorImageOffset.horizontal)
        } else {
            vectorImageOffset.horizontal = -min((rect.width / 2 - abs(maxR)), vectorImageOffset.horizontal)
        }
        

        
        configuration.backgroundColor.getColor(by: configuration.themeMode).setFill()
        UIColor.clear.setStroke()
        
        let path = UIBezierPath()

        // 左下
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        // 左上
        path.addLine(to: CGPoint(x: 0, y: maxR + configuration.cornerRadius - vectorImageOffset.vertical))
        path.addArc(withCenter: CGPoint(x: configuration.cornerRadius, y: maxR + configuration.cornerRadius - vectorImageOffset.vertical),
                    radius: configuration.cornerRadius,
                    startAngle: .pi,
                    endAngle: .pi / 2 * 3,
                    clockwise: true)
        
        // 中间图标半圆
        let d = sqrt(pow(maxR, 2) - pow(vectorImageOffset.vertical, 2))
        path.addLine(to: CGPoint(x: rect.width / 2 - d + vectorImageOffset.horizontal, y: maxR - vectorImageOffset.vertical))
        path.addArc(withCenter: CGPoint(x: rect.width / 2 + vectorImageOffset.horizontal, y: maxR),
                    radius: maxR,
                    startAngle: .pi  + asin(vectorImageOffset.vertical / maxR),
                    endAngle: 0 - asin(vectorImageOffset.vertical / maxR),
                    clockwise: false)
        
        // 右上
        path.addLine(to: CGPoint(x: rect.width, y: maxR - vectorImageOffset.vertical))
        path.addArc(withCenter: CGPoint(x: rect.width - configuration.cornerRadius, y: maxR + configuration.cornerRadius - vectorImageOffset.vertical),
                        radius: configuration.cornerRadius,
                        startAngle: .pi / -2,
                        endAngle: 0,
                        clockwise: true)
        
        // 右下
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.close()
        path.fill()
                
        let cycleRect = CGRect(x: rect.width / 2 - vectorImageBgRadius + vectorImageOffset.horizontal, y: vectorImageSpace, width: vectorImageBgSize.width, height: vectorImageBgSize.height)
        if configuration.vectorImageFillPercentage <= 1 {
            context.saveGState()
            configuration.vectorBackgroundColor.getColor(by: configuration.themeMode).setFill()
            let cyclePath = UIBezierPath(roundedRect: cycleRect, cornerRadius: vectorImageBgRadius)
            cyclePath.fill()
            context.restoreGState()
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

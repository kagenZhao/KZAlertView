//
//  KZAlertWindow.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/18.
//

import UIKit

internal class KZAlertWindow: UIWindow {
    //MARK: Private Properties
    internal static let shareWindow: KZAlertWindow = {
        let window = KZAlertWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue - 1)
        // This is for making the window not to effect the StatusBarStyle
        window.bounds.size.height = UIScreen.main.bounds.height.nextDown
        window.isHidden = true
        /// Set rootViewController to receve device orientation event
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .clear
        window.rootViewController = rootViewController
        return window
    }()
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let alertView = subviews.first(where: { $0 is KZAlertView }) else { return false }
        return alertView.point(inside: point, with: event)
    }
}

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
        let window: KZAlertWindow
        if #available(iOS 13, *), let windowScene = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).compactMap({ $0 as? UIWindowScene }).first {
            window = KZAlertWindow(windowScene: windowScene)
        } else {
            window = KZAlertWindow(frame: UIScreen.main.bounds)
        }
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
    
    internal func showIfNeed() {
        if KZAlertViewStack.shared.alertCount(in: self) > 0 {
            isHidden = false
        }
    }
    
    internal func hiddenIfNeed() {
        guard KZAlertViewStack.shared.alertCount(in: self) <= 0 else { return }
        isHidden = true
    }
}

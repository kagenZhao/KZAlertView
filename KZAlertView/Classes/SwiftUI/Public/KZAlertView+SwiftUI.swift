//
//  KZAlertView+SwiftUI.swift
//  KZAlertView.SwiftUI
//
//  Created by Kagen Zhao on 2020/9/23.
//

import UIKit
#if canImport(SwiftUI)
import SwiftUI

struct HostingWindowKey: EnvironmentKey {
    typealias Value = () -> UIWindow?
    static var defaultValue: Self.Value = { nil }
}

extension EnvironmentValues {
    var hostingWindow: HostingWindowKey.Value {
        get {
            return self[HostingWindowKey.self]
        }
        set {
            self[HostingWindowKey.self] = newValue
        }
    }
}


//MARK: SwiftUI
@available(iOS 13.0, *)
extension View {
    public func alert<Content>(isShowing: Binding<Bool>, content: () -> KZAlertView<Content>) -> some View {
        return KZAlertWapper.init(item: self, isShowing: isShowing, configruation: content())
    }
}

let shareWindow: UIWindow = {
    let window: UIWindow
    if let windowScene = UIApplication.shared.connectedScenes.filter({ $0.activationState == .foregroundActive }).compactMap({ $0 as? UIWindowScene }).first {
        window = UIWindow(windowScene: windowScene)
    } else {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    window.backgroundColor = .clear
    return window
}()

@available(iOS 13.0, *)
fileprivate struct KZAlertWapper<Item: View, Content: View>: View {
    let item: Item
    let configruation: KZAlertView<Content>
    @Binding var isShowing: Bool
    @State var animationShowing: Bool = false
    
    init(item: Item, isShowing: Binding<Bool>, configruation: KZAlertView<Content>) {
        self.item = item
        self._isShowing = isShowing
        self.configruation = configruation
    }
    
    var body: some View {
        ZStack {
            item
            configruation.content
        }
    }
}


#endif



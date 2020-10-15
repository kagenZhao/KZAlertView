//
//  SwiftUIViewController.swift
//  Example
//
//  Created by zhaoguoqing on 2020/9/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import SwiftUI
import KZAlertView

class SwiftUIViewController: UIHostingController<SomeView> {
    
    override init?(coder aDecoder: NSCoder, rootView: SomeView) {
        super.init(coder: aDecoder, rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SomeView())
    }
}

struct SomeView: View {
    
    @State var isShowing: Bool = false
    var body: some View {
        Button("show alert") {
            self.isShowing = true
        }
        .alert(isShowing: $isShowing, content: createConfiguration)
    }
    
    private func createConfiguration() -> KZAlertConfiguration {
        var configuration = KZAlertConfiguration(title: .string("Alert Title"), message: .string("This is my alert's subtitle. Keep it short and concise. 😜"))
        configuration.cancelAction = .init(title: .string("Cancel"), configuration: nil, handler: {
            print("Did Tap Cancel Button")
        })
        return configuration
    }
}

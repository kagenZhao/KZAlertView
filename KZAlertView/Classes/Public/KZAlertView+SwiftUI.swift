//
//  KZAlertView+SwiftUI.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/23.
//

import UIKit
import SwiftUI

//MARK: SwiftUI
@available(iOS 13.0, *)
extension View {
    public func alert(isShowing: Binding<Bool>, content: () -> KZAlertConfiguration) -> some View {
        return KZAlertWapper.init(item: self, isShowing: isShowing, configuration: content())
    }
}

@available(iOS 13.0, *)
fileprivate struct KZAlertWapper<Item: View>: View {
    let item: Item
    @Binding var isShowing: Bool
    let configuration: KZAlertConfiguration
    
    var body: some View {
        item.onReceive([isShowing].publisher) { (isShowing) in
            guard isShowing else { return }
            let alert = KZAlertView.alert(with: self.configuration)
            alert.addDismissCallback { [self] in
                self.isShowing = false
            }
            alert.show()
        }
    }
}

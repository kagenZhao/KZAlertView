//
//  KZAlertView.swift
//  KZAlertView.SwiftUI
//
//  Created by Kagen Zhao on 2020/10/15.
//

import Foundation
import SwiftUI

public struct KZAlertView<Content> where Content: View {
    let content: Content
    
    public init(@ViewBuilder content: (() -> Content)) {
        self.content = content()
    }
    
}

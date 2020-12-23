//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by Kagen Zhao on 2020/10/15.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftUI

import KZAlertView

struct ContentView: View {
    @State var isShowing: Bool = false
    @State var isShowing111: Bool = false
    @State private var animationAmount: CGFloat = 1
    var body: some View {
        Button("show alert") {
            self.isShowing.toggle()
        }
//        .alert(isShowing: $isShowing) {
//            KZAlertView(title: Text("title"), message: Text("message message message message message message messagemessage message message message message message messagemessage message message message message message messagemessage message message message message message messagemessage message message message message message messagemessage message message message message message messagemessage message message message message message messagemessage message message message message message messagemessage message message message message message messagemessage message message message message message message message message message message message messagemessage message message message message message messagemessage message message message message message messagemessage message message message message message message message message message message message messagemessage message message message message message messagemessage message message message message message messagemessage message message message message message message"), actions: {
//                Button("button") {
//
//                }
//            })
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

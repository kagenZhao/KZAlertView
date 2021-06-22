//
//  _KZAlertView.swift
//  KZAlertView.SwiftUI
//
//  Created by Kagen Zhao on 2020/9/9.
//

import UIKit
import SwiftUI
import Introspect

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}


//@available(iOS 13.0, *)

//internal struct _KZAlertView<
//    TitleContent,
//    MessageContent,
//    ActionContent,optOptholdrealPrompt
//    BackgroundContent>: View
//where TitleContent: View,
//      MessageContent: View,
//      ActionContent: View,
//      BackgroundContent: View {
//
//
//    let title: TitleContent
//    let message: MessageContent
//    let actions: ActionContent
//    let background: BackgroundContent
//    @Binding var isShowing: Bool
//
//    private var tapOutSideClosure: (() -> ())?
//
//    init(isShowing: Binding<Bool>,
//         @ViewBuilder titleBuilder: (() -> TitleContent),
//         @ViewBuilder messageBuilder: (() -> MessageContent),
//         @ViewBuilder actionsBuilder: (() -> ActionContent),
//         @ViewBuilder backgroundBuilder: (() -> BackgroundContent)) {
//        self._isShowing = isShowing
//        self.title = titleBuilder()
//        self.message = messageBuilder()
//        self.actions = actionsBuilder()
//        self.background = backgroundBuilder()
//    }
//
//
//
//    @State private var safeHeight: CGFloat = UIScreen.main.bounds.size.height
//
//    var body: some View {
//        ZStack {
//            if isShowing {
//                _KZAlertBackgroundView(background: background).edgesIgnoringSafeArea(.all)
//                    .background(GeometryReader {
//                        Color.clear.preference(key: ViewHeightKey.self, value: $0.frame(in: .local).size.height)
//                    })
//                    .onPreferenceChange(ViewHeightKey.self, perform: { self.safeHeight = $0 })
//                    .onTapGesture {
//                        tapOutSideClosure?()
//                    }
//                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
//                    .zIndex(0)
//                _KZAlertContentWapperView(title: title, message: message, actions: actions, safeHeight: $safeHeight)
//                    .transition(AnyTransition.scale(scale: 0.9).combined(with: .opacity).animation(.easeInOut(duration: 0.3)))
//                    .zIndex(1)
//            }
//        }
//    }
//
//    public func onTapOutSide(_ closure: @escaping (() -> ())) -> Self {
//        var newValue = Self.init(isShowing: $isShowing) {
//            title
//        } messageBuilder: {
//            message
//        } actionsBuilder: {
//            actions
//        } backgroundBuilder: {
//            background
//        }
//        newValue.tapOutSideClosure = closure
//        return newValue
//    }
//}
//
//
//private struct _KZAlertBackgroundView<BackgroundContent>: View where BackgroundContent: View {
//
//    let background: BackgroundContent
//
//    var body: some View {
//        background
//    }
//}
//
//struct _KZAlertContentWapperView<
//    TitleContent,
//    MessageContent,
//    ActionContent>: View
//where TitleContent: View,
//      MessageContent: View,
//      ActionContent: View {
//
//    let title: TitleContent
//    let message: MessageContent
//    let actions: ActionContent
//
//
//    @Binding var safeHeight: CGFloat
//    @State private var contentHeight: CGFloat = 0
//
//    var body: some View {
//        ScrollView([.vertical], showsIndicators: true) {
//            _KZAlertContentView(title: title, message: message, actions: actions)
//                .background(GeometryReader {
//                    Color.blue
//                        .preference(key: ViewHeightKey.self, value: $0.frame(in: .local).size.height)
//                })
//                .onPreferenceChange(ViewHeightKey.self, perform: {
//                    self.contentHeight = $0
//                })
//                .introspectScrollView { scrollView in
//                    scrollView.isScrollEnabled = contentHeight >= safeHeight
//                }
//        }
//        .frame(minWidth: 320, maxWidth: 320, maxHeight: contentHeight, alignment: .center)
//        .background(Color.orange)
//        .cornerRadius(18)
//
//    }
//}
//
//struct _KZAlertContentView<
//    TitleContent,
//    MessageContent,
//    ActionContent>: View
//where TitleContent: View,
//      MessageContent: View,
//      ActionContent: View  {
//
//    let title: TitleContent
//    let message: MessageContent
//    let actions: ActionContent
//
//    var body: some View {
//        VStack(spacing: 0) {
//            title
//                .padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
//            message
//                .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
////            _KZAlertTextField(configuration: configuration, placeHolder: "TextField 1")
////                .padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
//            _KZAlertActionView(actions: actions)
//                .frame(minWidth: 320)
//                .background(Color.green)
//        }
//    }
//}
//
//
//private struct _KZAlertTextField: View {
////    let configuration: KZAlertView
//    let placeHolder: String
//    @State var text: String = ""
//    var body: some View {
//        TextField(placeHolder, text: $text)
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//    }
//}
//
//private struct _KZAlertActionView<ActionContent>: View where ActionContent: View {
//    let actions: ActionContent
//    var body: some View {
//        actions
//    }
//}
//
//
//struct VectorHeader: Shape {
//    func path(in rect: CGRect) -> Path {
//        let mulPath = CGMutablePath.init()
//        let vectorImageBgRadius: CGFloat = 30
//        let vectorImageBgSize = CGSize(width: vectorImageBgRadius * 2, height: vectorImageBgRadius * 2)
//        let vectorImageBgEdge = UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 4)
//        let cornerRadius: CGFloat = 18
//
//        let path = UIBezierPath()
//
//        // 左下
//        path.move(to: CGPoint(x: 0, y: rect.height))
//
//        // 左上
//        path.addLine(to: CGPoint(x: 0, y: vectorImageBgRadius + cornerRadius))
//        path.addArc(withCenter: CGPoint(x: cornerRadius, y: vectorImageBgRadius + cornerRadius),
//                    radius: cornerRadius,
//                    startAngle: .pi,
//                    endAngle: .pi / 2 * 3,
//                    clockwise: true)
//
//        // 中间图标半圆
//        path.addLine(to: CGPoint(x: rect.width - vectorImageBgSize.width - vectorImageBgEdge.left, y: vectorImageBgRadius))
//        path.addArc(withCenter: CGPoint(x: rect.width / 2, y: vectorImageBgRadius),
//                    radius: vectorImageBgRadius + vectorImageBgEdge.left,
//                    startAngle: .pi,
//                    endAngle: 0,
//                    clockwise: false)
//
//        // 右上
//        path.addLine(to: CGPoint(x: rect.width, y: vectorImageBgRadius))
//        path.addArc(withCenter: CGPoint(x: rect.width - cornerRadius, y: vectorImageBgRadius + cornerRadius),
//                        radius: cornerRadius,
//                        startAngle: .pi / -2,
//                        endAngle: 0,
//                        clockwise: true)
//
//        // 右下
//        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
//        path.close()
//        mulPath.addPath(path.cgPath)
//
//        let cycleRect = CGRect(x: rect.width / 2 - vectorImageBgRadius, y: 0, width: vectorImageBgSize.width, height: vectorImageBgSize.height)
//        let cyclePath = UIBezierPath(roundedRect: cycleRect, cornerRadius: vectorImageBgRadius)
//        mulPath.addPath(cyclePath.cgPath)
//
//        return Path.init(mulPath)
//    }
//}

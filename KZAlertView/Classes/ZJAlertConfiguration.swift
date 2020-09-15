//
//  ZJAlertConfiguration.swift
//  ZJAlertView
//
//  Created by Kagen Zhao on 2020/9/9.
//

import UIKit

public struct ZJAlertConfiguration {
    
    // nil is hidden
    public var title: AlertString?
    
    public var message: AlertString
    
    public var cancelAction: AlertAction?
    
    public var actions: [AlertAction] = []
    
    public var textfields: [TextField] = []
    
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .medium)
    
    public var messageFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    public var titleColor: AlertColorStyle = .auto(light: ._darkText, dark: ._lightText)
    
    public var messageColor: AlertColorStyle = .auto(light: ._darkText, dark: ._lightText)
    
    public var titleTextAligment: NSTextAlignment = .center
    
    public var messageTextAligment: NSTextAlignment = .center
    
    public var titleNumberOfLines: Int = 0
    
    public var messageNumberOfLines: Int = 0
    
    public var contentBackgroundColor: AlertColorStyle = .auto(light: .lightBackgroundColor, dark: .darkBackgroundColor)
    
    public var showStackType: AlertShowStackType = .FIFO
    
    /// 自动隐藏
    /// default: none
    /// 无特殊情况, 请不要打开 没必要
    public var autoHide: AutoHide = .none
    
    /// 圆角
    public var cornerRadius: CGFloat = 18
    
    /// 点击周围撤销弹窗
    /// default: false
    public var dismissOnOutsideTouch: Bool = false
    
    /// 模糊背景
    public var isBlurBackground: Bool = false
    
    public var darkBackgroundHidden: Bool = false
    
    public var turnOnBounceAnimation: Bool = false
    
    public var colorScheme: AlertColorScheme = .autoCleanColor
    
    public var themeMode: ThemeMode = .followSystem
    
    public var buttonStyle: ButtonStyle = .normal(hideSeparator: false)
    
    /// 0% -> 100%
    /// default 50%
    public var vectorImageFillPercentage: CGFloat = 0.5
    
    public var maxHeight: CGFloat = automaticDimension
    
    public var width: CGFloat = automaticDimension
    
    public var animationIn: AlertAnimation = .center
    
    public var animationOut: AlertAnimation = .center
    
    
    public var vectorImage: UIImage?
    
    public var vectorImageRadius: CGFloat = 30
    
    public var vectorImageEdge = UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 4)
}

//MARK: Public Functions
extension ZJAlertConfiguration {
    public mutating func styleLike(_ style: AlertStyle) {
        resetDefaultConfigures()
        switch style {
        case .normal:
            vectorImage = nil
            colorScheme = .autoCleanColor
        case .success:
            vectorImage = UIImage(named: "ZJAlertView-success")
            colorScheme = .flatGreen
        case .warning:
            vectorImage = UIImage(named: "ZJAlertView-warning")
            colorScheme = .flatOrange
        case .error:
            vectorImage = UIImage(named: "ZJAlertView-error")
            colorScheme = .flatRed
        }
    }
}

//MARK: Inner Class/Struct
extension ZJAlertConfiguration {
    public static let automaticDimension: CGFloat = -1
    
    public struct AlertAction {
        public typealias ActionHandler = (() -> Void)
        public typealias Configuration = ((UIButton) -> Void)
        var title: AlertString
        var configuration: Configuration = { _ in }
        var handler: ActionHandler = {}
    }
    
    public struct TextField {
        public typealias Configuration = ((UITextField) -> ())
        public typealias ActionHandler = ((UITextField) -> ())
        var configuration: Configuration = { _ in }
        var handler: ActionHandler = { _ in }
    }
    
    public enum AutoHide {
        case none
        case seconds(TimeInterval)
    }
    
    public enum AlertStyle {
        case normal // 不带顶部图标, 类似系统的UIAlertController
        case error
        case warning
        case success
    }
    
    public enum ThemeMode {
        case light
        case dark
        case followSystem
    }
    
    public enum ButtonStyle {
        case normal(hideSeparator: Bool)
        case detachAndRound
    }
    
    public enum AlertString {
        case string(_ string: String)
        case attributeString(_ attributeString: NSAttributedString)
    }
    
    public enum AlertAnimation {
        case center
        case left
        case right
        case top
        case bottom
    }
    
    public enum AlertColorStyle {
        case auto(light: UIColor, dark: UIColor)
        case force(_ color: UIColor)
    }
    
    public enum AlertColorScheme {
        case autoCleanColor // 正常白色, 黑暗模式黑色
        case color(AlertColorStyle)
    }
    
    public enum AlertShowStackType {
        case FIFO // 先进先出, 此弹窗会插入到当前弹窗的后边
        case LIFO // 后进先出, 此弹窗会插入到当前弹窗之后
        case required // 立即移除当前弹窗并展示新的
        case unrequired // 尝试弹窗, 如果当前有弹窗存在则不执行任何操作
    }
}


extension ZJAlertConfiguration.AlertColorScheme {
    public static var flatTurquoise: Self {
        return .color(.force(UIColor.dynamicColorBySystemVersion(red: 26/255, green: 188/255, blue: 156/255)))
    }
    
    public static var flatGreen: Self {
        return .color(.force(UIColor.dynamicColorBySystemVersion(red: 39/255, green: 174/255, blue: 96/255)))
    }
    
    public static var flatBlue: Self {
        return .color(.force(UIColor.dynamicColorBySystemVersion(red: 41/255, green: 128/255, blue: 185/255)))
    }
    
    public static var flatMidnight: Self {
        return .color(.force(UIColor.dynamicColorBySystemVersion(red: 44/255, green: 62/255, blue: 88/255)))
    }
    
    public static var flatPurple: Self {
        return .color(.force(UIColor.dynamicColorBySystemVersion(red: 142/255, green: 68/255, blue: 173/255)))
    }
    
    public static var flatOrange: Self {
        return .color(.force(UIColor.dynamicColorBySystemVersion(red: 243/255, green: 156/255, blue: 18/255)))
    }
    
    public static var flatRed: Self {
        return .color(.force(UIColor.dynamicColorBySystemVersion(red: 192/255, green: 57/255, blue: 43/255)))
    }
    
    public static var flatSilver: Self {
        return .color(.force(UIColor.dynamicColorBySystemVersion(red: 189/255, green: 195/255, blue: 199/255)))
    }
    
    public static var flatGray: Self {
        return .color(.force(UIColor.dynamicColorBySystemVersion(red: 127/255, green: 140/255, blue: 141/255)))
    }
}

extension ZJAlertConfiguration.AlertColorStyle {
    internal func getColor(by themeMode: ZJAlertConfiguration.ThemeMode) -> UIColor {
        switch self {
        case .force(let color): return color
        case .auto(let lightColor, dark: let darkColor):
            return UIColor.dynamicColorByTheme(lightColor: lightColor, darkColor: darkColor, by: themeMode)
        }
    }
}

extension ZJAlertConfiguration.ThemeMode {
    internal func isDark(at view: UIView) -> Bool {
        if self == .dark { return true }
        if #available(iOS 13.0, *) {
            if self == .followSystem, view.traitCollection.userInterfaceStyle == .dark {
                return true
            }
        }
        return false
    }
}

extension ZJAlertConfiguration {
    
    internal var alertCenterOffset: CGPoint {
        return CGPoint(x: 0, y: -30)
    }
    
    //MARK: Shadow
    internal var shadowColor: UIColor {
        return darkBackgroundHidden ? .black : .clear
    }
    
    internal var shadowOffset: CGSize {
        return CGSize(width: 2, height: 2)
    }
    
    internal var shadowRadius: CGFloat {
        return 8
    }
    
    internal var shadowOpacity: Float {
        return 0.3
    }
    
    internal var darkBackgroundColor: UIColor {
        return .init(white: 0, alpha: 0.35)
    }
    
    //MARK:
    internal var scrollContentEdge: UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    internal var contentEdge: UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 5, right: allButtonCount == 0 ? 15 : 5)
    }
    
    //MARK: TitleLabel
    internal var titleLabelEdge: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    internal var titleLabelMinHeight: CGFloat {
        return 30
    }
    
    internal var messageLabelEdge: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    internal var messageLabelMinHeight: CGFloat {
        return 30
    }
    
    //MARK: TextField
    
    internal var textFieldHeight: CGFloat {
        return 40
    }
    
    internal var textFieldBorderColor: UIColor {
        return UIColor(white: 200.0/255, alpha: 1)
    }
    
    internal var textFieldBorderWidth: CGFloat {
        return 1
    }
    
    internal var textFieldLeftPadding: CGFloat {
        return 10
    }
    
    internal var textFieldCornerRadius: CGFloat {
        return 3
    }
    
    internal var textFieldAndLabelSpace: CGFloat {
        return 5
    }
    
    internal var textFieldEdge: UIEdgeInsets {
        return UIEdgeInsets(top: 5.5, left: 12.5, bottom: 0, right: 12.5)
    }
    
    internal var textFiledBackgroudColor: UIColor {
        return contentBackgroundColor.getColor(by: themeMode)
    }
    
    internal var textFieldPlaceHolderColor: UIColor {
        let placeHolderLightColor = UIColor.init(white: 201/255, alpha: 1)
        let placeHolderDarkColor = UIColor.init(white: 102/255, alpha: 1)
        return UIColor.dynamicColorByTheme(lightColor: placeHolderLightColor, darkColor: placeHolderDarkColor, by: themeMode)
    }
    
    internal var textFieldDefaultTextColor: UIColor {
        return UIColor.dynamicColorByTheme(lightColor: UIColor._darkText, darkColor: ._lightText, by: themeMode)
    }
    
    //MARK: Button
    internal var isDetach: Bool {
        let isDetach: Bool
        if case .detachAndRound = buttonStyle {
            isDetach = true
        } else {
            isDetach = false
        }
        return isDetach
    }
    
    internal var cancelButtonBackgroundColor: UIColor {
        switch colorScheme {
        case .autoCleanColor:
            let lightColor: UIColor = isDetach ? .buttonDetachLightColor : .lightBackgroundColor
            return UIColor.dynamicColorByTheme(lightColor: lightColor, darkColor: .buttonDarkColor, by: themeMode)
        case .color(let value):
            return value.getColor(by: themeMode)
        }
    }
    
    internal var cancelButtonTintColor: UIColor {
        switch colorScheme {
        case .autoCleanColor:
            return UIColor.dynamicColorByTheme(lightColor: .buttonDefaultTintColor, darkColor: ._lightText, by: themeMode)
        case .color(let value):
            let tempThemeMode = themeMode
            return UIColor.dynamicColorByClosure { (_) -> UIColor in
                if value.getColor(by: tempThemeMode).isLignt(threshold: 0.8) ?? false {
                    return ._darkText
                } else {
                    return ._lightText
                }
            }
        }
    }
    
    internal var nornalButtonBackgroundColor: UIColor {
        let lightColor: UIColor = isDetach ? .buttonDetachLightColor : .lightBackgroundColor
        return UIColor.dynamicColorByTheme(lightColor: lightColor, darkColor: .buttonDarkColor, by: themeMode)
    }
    
    internal var normalButtonTintColor: UIColor {
        switch colorScheme {
        case .autoCleanColor:
            return UIColor.dynamicColorByTheme(lightColor: .buttonDefaultTintColor, darkColor: ._lightText, by: themeMode)
        case .color(let value):
            return value.getColor(by: themeMode)
        }
    }
    
    internal var allButtonCount: Int {
        return actions.count + (cancelAction != nil ? 1 : 0)
    }
    
    internal var buttonHeight: CGFloat {
        return isDetach ? 40 : 45
    }
    
    internal var defaultCancelButtonFont: UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    internal var defaultNormalButtonFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    internal var buttonSeparotor: CGFloat {
        return 1
    }
    
    internal var buttonEdge: UIEdgeInsets {
        var detachButtonEdge = UIEdgeInsets(top: 5, left: 8, bottom: 10, right: 8)
        if allButtonCount == 2 {
            detachButtonEdge = UIEdgeInsets(top: 0, left: 8, bottom: 10, right: 8)
        }
        return isDetach ? detachButtonEdge : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate mutating func resetDefaultConfigures() {
        titleColor = .auto(light: ._darkText, dark: ._lightText)
        messageColor = .auto(light: ._darkText, dark: ._lightText)
        titleFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        messageFont = UIFont.systemFont(ofSize: 15)
        titleTextAligment = .center
        messageTextAligment = .center
        titleNumberOfLines = 0
        messageNumberOfLines = 0
        contentBackgroundColor = .auto(light: .lightBackgroundColor, dark: .darkBackgroundColor)
        autoHide = .none
        cornerRadius = 18
        dismissOnOutsideTouch = false
        isBlurBackground = false
        darkBackgroundHidden = false
        turnOnBounceAnimation = false
        colorScheme = .autoCleanColor
        themeMode = .followSystem
        buttonStyle = .normal(hideSeparator: false)
        vectorImageFillPercentage = 0.5
        maxHeight = ZJAlertConfiguration.automaticDimension
        width = ZJAlertConfiguration.automaticDimension
        animationIn = .center
        animationOut = .center
        vectorImage = nil
        vectorImageRadius = 30
        vectorImageEdge = UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 4)
    }
}


extension UIColor {
    fileprivate enum ColorTheme {
        case light
        case dark
    }
    
    fileprivate func isLignt(threshold: Float = 0.5) -> Bool? {
        let originalCGColor = cgColor
        let rgbCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: CGColorRenderingIntent.defaultIntent, options: nil)
        guard let components = rgbCGColor?.components else { return nil }
        guard components.count >= 3 else { return nil }
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return brightness >= threshold
    }
    
    fileprivate class var buttonDetachLightColor: UIColor {
        return UIColor(white: 228/255, alpha: 1)
    }
    
    fileprivate class var buttonDarkColor: UIColor {
        return UIColor(white: 78/255, alpha: 1)
    }
    
    fileprivate class var buttonDefaultTintColor: UIColor {
        return .dynamicColorBySystemVersion(red: 0, green: 0.478431, blue: 1)
    }
    
    fileprivate class var lightBackgroundColor: UIColor {
        return .white
    }
    
    fileprivate class var darkBackgroundColor: UIColor {
        return .init(white: 48.0/255.0, alpha: 1)
    }
    
    fileprivate class func dynamicColorBySystemVersion(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        if #available(iOS 10, *), UIScreen.main.traitCollection.displayGamut == .P3 {
            return UIColor.init(displayP3Red: red, green: green, blue: blue, alpha: 1)
        } else {
            return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
        }
    }
    
    fileprivate class func dynamicColorByTheme(lightColor: @autoclosure @escaping (() -> UIColor), darkColor: @autoclosure @escaping (() -> UIColor), by themeMode: ZJAlertConfiguration.ThemeMode) -> UIColor {
        if themeMode == .dark {
            return darkColor()
        }
        if #available(iOS 13.0, *) {
            if themeMode == .followSystem {
                return UIColor.init { (collection) -> UIColor in
                    switch collection.userInterfaceStyle {
                    case .dark:
                        return darkColor()
                    case .light, .unspecified:
                        return lightColor()
                    @unknown default:
                        return lightColor()
                    }
                }
            }
        }
        return lightColor()
    }
    
    fileprivate class func dynamicColorByClosure(_ closure: @escaping ((ColorTheme) -> UIColor)) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (collection) -> UIColor in
                switch collection.userInterfaceStyle {
                case .dark:
                    return closure(.dark)
                case .light, .unspecified:
                    return closure(.light)
                @unknown default:
                    return closure(.light)
                }
            }
        } else {
            return closure(.light)
        }
    }
    
    fileprivate class var _darkText: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 0.2, green: 0.2, blue: 0.2)
    }
    
    fileprivate class var _lightText: UIColor {
        return .white
    }

}

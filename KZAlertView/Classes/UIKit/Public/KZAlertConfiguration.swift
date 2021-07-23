//
//  KZAlertConfiguration.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/9.
//

import UIKit

public struct KZAlertConfiguration {
    /// Alert view delegate, contains some delegate functions
    /// default: `nil`
    public weak var delegate: KZAlertViewDelegate? = nil
    
    /// Alert title
    /// default: `nil`, means hidden
    public var title: AlertString?
    
    /// Alert message
    /// required
    public var message: AlertString
    
    /// Setup alert cancel button
    public var cancelAction: AlertAction?
    
    /// Setup alert other buttons
    public var actions: [AlertAction] = []
    
    /// Setup finallay dismiss action
    public var finallayDismissAction: DismissAction? = nil
    
    /// Setup textfields in alert
    public var textfields: [TextField] = []
    
    /// Alert title font
    /// default: `system, 18, medium`
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .medium)
    
    /// Alert message font
    /// default: `system, 15, regular`
    public var messageFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    
    /// Alert title text color
    public var titleColor: AlertColorStyle = .auto(light: ._darkText, dark: ._lightText)
    
    /// Alert message color
    public var messageColor: AlertColorStyle = .auto(light: ._darkText, dark: ._lightText)
    
    /// Alert title text aligment
    /// default: `.center`
    public var titleTextAligment: NSTextAlignment = .center
    
    /// Alert message text aligment
    /// default: `.center`
    public var messageTextAligment: NSTextAlignment = .center
    
    /// Alert title lines number
    /// default: `0`, means infinity
    public var titleNumberOfLines: Int = 0
    
    /// Alert message lines number
    /// default: `0`, means infinity
    public var messageNumberOfLines: Int = 0
    
    /// Alert backgroun color
    /// default: `.auto`, flow system user interface style
    public var backgroundColor: AlertColorStyle = .auto(light: .lightBackgroundColor, dark: .darkBackgroundColor)
    
    /// Queue settings when multiple alert pop up at the same time
    /// default: `.FIFO`, first in first out
    public var showStackType: AlertShowStackType = .FIFO
    
    /// Alert can dismiss by user swipe gesture
    /// default: `false`
    public var swipeToDismiss: Bool = false
    
    /// Alert auto dismiss
    /// If set to `.noUserTouch(timeInterval)`, the timing will be interrupted when the user touches alert
    /// If `textfields` is not empty, this property is ignored
    /// default: `.disabled`disabled
    public var autoDismiss: AutoDismiss = .disabled
    
    /// Alert show position
    /// default: `.center`
    public var position: AlertPosition = .center
    
    /// The background of the alert will completely cover the container
    /// If set `false`, the user interaction of the container will not be affected when the alert is displayed
    /// if set `false`, `isDarkBackground` and `isBlurBackground` will be ignored
    /// default: `true`
    public var fullCoverageContainer: Bool = true
    
    /// Alert corner radius
    /// default: `18`
    public var cornerRadius: CGFloat = 18
    
    /// Alert dismiss on action button tapped
    /// default: `true`
    public var dismissOnActionHandled: Bool = true
    
    /// Alert dismiss on outside touch
    /// default: `false`
    public var dismissOnOutsideTouch: Bool = false
    
    /// Alert dismiss on content touch
    /// This attribute can be used to toast
    /// default: `false`
    public var dismissOnContentTouch: Bool = false
    
    /// Setup blur background
    /// default: `false`
    public var isBlurBackground: Bool = false
    
    /// Setup dark background
    /// default: `true`
    public var isDarkBackground: Bool = true
    
    /// Turn on bounce animation
    /// default: `true`
    public var bounceAnimation: Bool = true
    
    /// Alert color scheme
    /// default: `.autoCleanColor`, flow system user interface style, white/dark
    public var colorScheme: AlertColorStyle? = nil
    
    /// Actions color scheme
    /// Default: `false`, Cancel action background equal to colorScheme, and other action text color equal to colorScheme
    /// If true, the actions color scheme will be reverted
    public var revertActionsColorSchemeStyle: Bool = false
    
    /// Alert white/dark mode
    /// default: `.followSystem`
    public var themeMode: ThemeMode = .followSystem
    
    /// Alert button style
    /// see `ButtonStyle` infomation
    /// default: `.normal(hideSeparator: false)`
    public var buttonStyle: ButtonStyle = .normal(hideSeparator: false)
    
    /// Alert button highlight color
    /// default: `nil`
    public var buttonHighlight: AlertColorStyle? = nil
    
    /// Alert vector image fill percentage
    /// Allow 0% -> 100%
    /// default: `50%`
    public var vectorImageFillPercentage: CGFloat = 0.5
    
    /// Custom alert max height
    /// default: `automaticDimension`, safe area
    public var maxHeight: CGFloat = automaticDimension
    
    /// Custom alert width
    /// default: `automaticDimension`
    public var width: CGFloat = automaticDimension
    
    /// Custom alert top and bottom space
    /// default: `.underSafe(top: 10, bottom: 10)`
    public var safeEdge: SageEdge = .underSafe(top: 10, bottom: 10)
    
    /// Custom alert pop-up animation
    /// default: `.center`
    public var animationIn: AlertAnimation = .center
    
    /// Custom alert dismiss animation
    /// default: `.center`
    public var animationOut: AlertAnimation = .center

    /// Custom vector image
    /// default: `nil`, means hidden
    public var vectorImage: UIImage?
    
    /// Custom vector image background color
    /// default: `.auto`, flow system user interface style
    public var vectorBackgroundColor: AlertColorStyle = .auto(light: .lightBackgroundColor, dark: .darkBackgroundColor)
    
    /// Custom vector image radius
    /// default: `30`
    public var vectorImageRadius: CGFloat = 30
    
    /// Custom vector image edge
    /// default: `4`
    public var vectorImageSpace: CGFloat = 4
    
    /// Custom vector image edge
    /// default: `.zero` means top border center
    public var vectorImageOffset = UIOffset.zero
    
    /// Custom content view between content view and action buttons.
    /// default : `nil`
    public var customContent: KZAlertViewCustomContent? = nil
    
    /// Play sound with alert
    /// default: `nil`
    public var playSoundFileUrl: URL? = nil
    
    public init(title: KZAlertConfiguration.AlertString? = nil, message: KZAlertConfiguration.AlertString) {
        self.title = title
        self.message = message
    }
}



//MARK: Public Functions
extension KZAlertConfiguration {
    
    /// Default style api
    public mutating func styleLike(_ style: AlertStyle) {
        self = KZAlertConfiguration(title: title, message: message)
        switch style {
        case .normal:
            vectorImage = nil
            colorScheme = nil
        case .success:
            vectorImage = UIImage.loadImageFromResourceBundle("KZAlertView-success")
            colorScheme = .flatGreen
        case .warning:
            vectorImage = UIImage.loadImageFromResourceBundle("KZAlertView-warning")
            colorScheme = .flatOrange
        case .error:
            vectorImage = UIImage.loadImageFromResourceBundle("KZAlertView-error")
            colorScheme = .flatRed
        }
    }
    
    public mutating func styleLikeToast(_ position: AlertPosition = .bottom(space: 10), duration: TimeInterval = 2, touchToDismiss: Bool = true) {
        vectorImage = nil
        colorScheme = nil
        let lightToastBackgrounColor = UIColor.black.withAlphaComponent(0.7)
        let darkToastBackgrounColor = UIColor.darkBackgroundColor
        backgroundColor = .auto(light: lightToastBackgrounColor, dark: darkToastBackgrounColor)
        isDarkBackground = false
        isBlurBackground = false
        fullCoverageContainer = false
        titleColor = .auto(light: ._lightText, dark: ._lightText)
        messageColor = .auto(light: ._lightText, dark: ._lightText)
        autoDismiss = .force(duration)
        actions.removeAll()
        cancelAction = nil
        self.position = position
        messageTextAligment = .natural
        dismissOnOutsideTouch = touchToDismiss
    }
}

//MARK: Inner Class/Struct
extension KZAlertConfiguration {
    public typealias DismissAction = ((KZAlertView) -> Void)
    
    /// Return a value that fits the screen
    public static let automaticDimension: CGFloat = -1
    
    public struct AlertAction {
        public typealias Configuration = ((UIButton) -> Void)
        public typealias ActionHandler = ((KZAlertView, UIButton) -> Void)
        public var title: AlertString
        public var configuration: Configuration?
        public var handler: ActionHandler?
        internal var _handler: ((UIButton) -> Void)?
        public init(title: KZAlertConfiguration.AlertString, configuration: KZAlertConfiguration.AlertAction.Configuration? = nil, handler: KZAlertConfiguration.AlertAction.ActionHandler? = nil) {
            self.title = title
            self.configuration = configuration
            self.handler = handler
        }
    }
    
    public struct TextField {
        public typealias Configuration = ((UITextField) -> ())
        public typealias ActionHandler = ((KZAlertView, UITextField) -> ())
        public var configuration: Configuration?
        public var handler: ActionHandler?
        public init(configuration: KZAlertConfiguration.TextField.Configuration? = nil, handler: KZAlertConfiguration.TextField.ActionHandler? = nil) {
            self.configuration = configuration
            self.handler = handler
        }
    }
    
    /// Alert auto dismiss
    public enum AutoDismiss {
        /// disable auto dismiss
        case disabled
        /// No matter whether the user clicks or not, the alert will disappear after a few seconds
        case force(_ seconds: TimeInterval)
        /// The number of seconds to delay hiding when the user does not touch the alert view
        case noUserTouch(_ seconds: TimeInterval)
    }
    
    
    /// Alert default style
    public enum AlertStyle {
        /// style like UIAlertController
        case normal
        /// flatRed colorScheme and vector image
        case error
        /// flatOrange colorScheme and vector image
        case warning
        /// flatGreen colorScheme and vector image
        case success
    }
    
    /// Alert theme mode
    public enum ThemeMode {
        /// force light mode
        case light
        /// force dark mode
        case dark
        /// follow system user interface style
        case followSystem
    }
    
    /// Alert button style
    public enum ButtonStyle {
        // fill width buttons and separator
        case normal(hideSeparator: Bool)
        // deach and round buttons
        case detachAndRound
    }
    
    /// Alert string Wapper
    /// Support `ExpressibleByStringInterpolation` to `.string(xxx)`
    public enum AlertString {
        /// String wapper
        case string(_ string: String)
        /// NSAttributedString wapper
        case attributeString(_ attributeString: NSAttributedString)
    }
    
    /// Alert animations
    public enum AlertAnimation {
        /// center to center
        case center
        /// left <-> center
        case left
        /// right <-> center
        case right
        /// top <-> center
        case top
        /// bottom <-> center
        case bottom
    }
    
    /// Alert color wapper
    public enum AlertColorStyle {
        /// support white and dark color
        case auto(light: UIColor, dark: UIColor)
        /// use same color in white/dark mode
        case force(_ color: UIColor)
    }
    
    /// Alert potion in Container
    public enum AlertPosition {
        /// in center
        case center
        /// in top, you can set custom space, exclude safe area
        case top(space: CGFloat)
        /// in bottom, you can set custom space, exclude safe area
        case bottom(space: CGFloat)
    }
    
    /// Queue settings when multiple alert pop up at the same time
    public enum AlertShowStackType {
        
        /// Multiple alerts will be superimposed
        case superimposed
        /// first in first out
        case FIFO
        /// last in first out, except the ones currently displayed
        case LIFO
        /// remove current showing alert, and show alert
        case required
        /// If there is already an alert, give up
        case unrequired
        
        /// Same as `.required`
        public static var onlyShowLast: AlertShowStackType { .required }
        
        /// Same as `.unrequired`
        public static var onlyShowFirst: AlertShowStackType { .unrequired }
    }
    
    public enum SageEdge {
        case underSafe(top: CGFloat, bottom: CGFloat)
        case force(top: CGFloat, bottom: CGFloat)
    }
}

public protocol KZAlertViewDelegate: AnyObject {
    func alertViewWillShow(_ alertView: KZAlertView)
    func alertViewDidShow(_ alertView: KZAlertView)
    func alertViewWillDismiss(_ alertView: KZAlertView)
    func alertViewDidDismiss(_ alertView: KZAlertView)
}

public protocol KZAlertViewCustomContent: KZAlertViewDelegate, UIView {
    /// Touch Content will excute this function.
    /// return true when touch the user interaction enabled view
    /// Example: `Button`, `TextField` and so on
    /// If return false, the button action or another user interaction whill not be excute when `dismissOnOutsideTouch` is  true.
    func containsUserInteractionEnabledView(_ point: CGPoint) -> Bool
}
 
extension KZAlertViewDelegate {
    public func alertViewWillShow(_ alertView: KZAlertView){}
    public func alertViewDidShow(_ alertView: KZAlertView){}
    public func alertViewWillDismiss(_ alertView: KZAlertView){}
    public func alertViewDidDismiss(_ alertView: KZAlertView){}
}

extension UIView: KZAlertViewDelegate{
    public func alertViewWillShow(_ alertView: KZAlertView){}
    public func alertViewDidShow(_ alertView: KZAlertView){}
    public func alertViewWillDismiss(_ alertView: KZAlertView){}
    public func alertViewDidDismiss(_ alertView: KZAlertView){}
}

extension UIView: KZAlertViewCustomContent {
    public func containsUserInteractionEnabledView(_ point: CGPoint) -> Bool { return false }
}

extension UIColor {
    public static var flatTurquoise: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 26/255, green: 188/255, blue: 156/255)
    }
    
    public static var flatGreen: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 39/255, green: 174/255, blue: 96/255)
    }
    
    public static var flatBlue: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 41/255, green: 128/255, blue: 185/255)
    }
    
    public static var flatMidnight: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 44/255, green: 62/255, blue: 88/255)
    }
    
    public static var flatPurple: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 142/255, green: 68/255, blue: 173/255)
    }
    
    public static var flatOrange: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 243/255, green: 156/255, blue: 18/255)
    }
    
    public static var flatRed: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 192/255, green: 57/255, blue: 43/255)
    }
    
    public static var flatSilver: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 189/255, green: 195/255, blue: 199/255)
    }
    
    public static var flatGray: UIColor {
        return UIColor.dynamicColorBySystemVersion(red: 127/255, green: 140/255, blue: 141/255)
    }
}

extension KZAlertConfiguration.AlertColorStyle {
    public static var flatTurquoise: Self { return .force(.flatTurquoise) }
    public static var flatGreen: Self { return .force(.flatGreen) }
    public static var flatBlue: Self { return .force(.flatBlue) }
    public static var flatMidnight: Self { return .force(.flatMidnight) }
    public static var flatPurple: Self { return .force(.flatPurple) }
    public static var flatOrange: Self { return .force(.flatOrange) }
    public static var flatRed: Self { return .force(.flatRed) }
    public static var flatSilver: Self { return .force(.flatSilver) }
    public static var flatGray: Self { return .force(.flatGray) }
}

extension KZAlertConfiguration.AlertString: ExpressibleByStringInterpolation {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension KZAlertConfiguration.AlertString {
    public var isEmpty: Bool {
        switch self {
        case .string(let string): return string.isEmpty
        case .attributeString(let attributeString): return attributeString.string.isEmpty
        }
    }
}

extension KZAlertConfiguration.AlertColorStyle {
    internal func getColor(by themeMode: KZAlertConfiguration.ThemeMode) -> UIColor {
        switch self {
        case .force(let color): return color
        case .auto(let lightColor, dark: let darkColor):
            return UIColor.dynamicColorByTheme(lightColor: lightColor, darkColor: darkColor, by: themeMode)
        }
    }
}

extension KZAlertConfiguration.ThemeMode {
    internal func isDark(at view: UIView) -> Bool {
        if self == .dark { return true }
        if #available(iOS 13.0, *) {
            if self == .followSystem, view.traitCollection.userInterfaceStyle == .dark {
                return true
            }
            UITraitCollection.current = UITraitCollection.init()
        }
        return false
    }
}

extension KZAlertConfiguration {
    
    internal var alertCenterOffset: CGPoint {
        return CGPoint(x: 0, y: -30)
    }
    
    //MARK: Shadow
    internal var shadowColor: UIColor {
        if isDarkBackground && fullCoverageContainer{
            return .clear
        } else {
            return .black
        }
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
        return UIEdgeInsets(top: 10, left: 0, bottom: allButtonCount == 0 ? 10 : 5, right: 0)
    }
    
    //MARK: TitleLabel
    internal var titleLabelEdge: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
    }
    internal var titleLabelMinHeight: CGFloat {
        return 0
    }
    
    internal var messageLabelEdge: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    internal var customViewEdge: UIEdgeInsets {
        return UIEdgeInsets(top: 5.5, left: 15, bottom: 0, right: 15)
    }
    
    internal var messageLabelMinHeight: CGFloat {
        if customContent != nil {
            return 0
        }
        if let title = self.title, !title.isEmpty {
            return 0
        }
        if textfields.count > 0 {
            return 0
        }
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
        return UIEdgeInsets(top: 5.5, left: 15, bottom: 0, right: 15)
    }
    
    internal var textFiledBackgroudColor: UIColor {
        return backgroundColor.getColor(by: themeMode)
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
        guard let colorScheme = self.colorScheme else {
            let lightColor: UIColor = isDetach ? .buttonDetachLightColor : .lightBackgroundColor
            return UIColor.dynamicColorByTheme(lightColor: lightColor, darkColor: .buttonDarkColor, by: themeMode)
        }
        return colorScheme.getColor(by: themeMode)
    }
    
    internal var cancelButtonTintColor: UIColor {
        guard let colorScheme = colorScheme else {
            return UIColor.dynamicColorByTheme(lightColor: .buttonDefaultTintColor, darkColor: ._lightText, by: themeMode)
        }
        let tempThemeMode = themeMode
        return UIColor.dynamicColorByClosure { (_) -> UIColor in
            if colorScheme.getColor(by: tempThemeMode).isLignt(threshold: 0.8) ?? false {
                return ._darkText
            } else {
                return ._lightText
            }
        }
    }
    
    internal var nornalButtonBackgroundColor: UIColor {
        let lightColor: UIColor = isDetach ? .buttonDetachLightColor : .lightBackgroundColor
        return UIColor.dynamicColorByTheme(lightColor: lightColor, darkColor: .buttonDarkColor, by: themeMode)
    }
    
    internal var normalButtonTintColor: UIColor {
        guard let colorScheme = colorScheme else {
            return UIColor.dynamicColorByTheme(lightColor: .buttonDefaultTintColor, darkColor: ._lightText, by: themeMode)
        }
        return colorScheme.getColor(by: themeMode)
    }
    
    internal var allButtonCount: Int {
        return actions.count + (cancelAction != nil ? 1 : 0)
    }
    
    internal var buttonHeight: CGFloat {
        return isDetach ? 40 : 45
    }
    
    internal var defaultCancelButtonFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    internal var defaultNormalButtonFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    internal var buttonSeparotorColor: UIColor {
        return UIColor.clear
    }
    
    internal var buttonHighlightImage: UIImage? {
        switch buttonHighlight {
        case nil: return nil
        case .force(let color):
            return UIImage.createImage(by: color)
        case .auto(light: let lightColor, dark: let darkColor):
            switch themeMode {
            case .dark:
                return UIImage.createImage(by: darkColor)
            case .light:
                return UIImage.createImage(by: lightColor)
            case .followSystem:
                if #available(iOS 13, *) {
                    guard let lightImage = UIImage.createImage(by: lightColor) else {
                        return nil
                    }
                    guard let darkImage = UIImage.createImage(by: darkColor) else {
                        return lightImage
                    }
                    let scaleTraitCollection = UITraitCollection.current
                    let darkUnscaledTraitCollection = UITraitCollection(userInterfaceStyle: .dark)
                    let darkScaleedTraitCollection = UITraitCollection.init(traitsFrom: [scaleTraitCollection, darkUnscaledTraitCollection])
                    guard let lightImageConfiguration = lightImage.configuration else {
                        return lightImage
                    }
                    let fixedLightImage = lightImage.withConfiguration(lightImageConfiguration.withTraitCollection(UITraitCollection(userInterfaceStyle: .light)))
                    guard let darkImageConfiguration = darkImage.configuration else {
                        return lightImage
                    }
                    let fixedDarkImage = darkImage.withConfiguration(darkImageConfiguration.withTraitCollection(UITraitCollection(userInterfaceStyle: .dark)))
                    fixedLightImage.imageAsset?.register(fixedDarkImage, with: darkScaleedTraitCollection)
                    return lightImage
                } else {
                    return UIImage.createImage(by: lightColor)
                }
            }
        }
    }
    
    internal var buttonSeparotor: CGFloat {
        return 1
    }
    
    internal var buttonEdge: UIEdgeInsets {
        var detachButtonEdge = UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15)
        if allButtonCount == 2 {
            detachButtonEdge = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 15)
        }
        return isDetach ? detachButtonEdge : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    fileprivate class func dynamicColorByTheme(lightColor: @autoclosure @escaping (() -> UIColor), darkColor: @autoclosure @escaping (() -> UIColor), by themeMode: KZAlertConfiguration.ThemeMode) -> UIColor {
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
        return UIColor(white: 0.2, alpha: 1)
    }
    
    fileprivate class var _lightText: UIColor {
        return .white
    }

}


extension UIImage {
    fileprivate class func loadImageFromResourceBundle(_ name: String) -> UIImage? {
        if let image = UIImage(named: name) {
            return image
        } else {
            let classBundle = Bundle(for: KZAlertView.self)
            if let image = UIImage(named: name, in: classBundle, compatibleWith: nil) {
                return image
            } else {
                guard let resourceUrl = classBundle.url(forResource: String(describing: KZAlertView.self), withExtension: "bundle") else { return nil }
                guard let resourceBundle = Bundle(url: resourceUrl) else { return nil }
                return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
            }
        }
    }
    
    fileprivate class func createImage(by color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

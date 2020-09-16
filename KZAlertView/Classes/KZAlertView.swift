//
//  KZAlertView.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/9.
//

import UIKit
import SnapKit


final public class KZAlertView: UIView {
    
    //MARK: Private Properties
    internal static let shareWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue - 1)
        // Copy from CocoaDebug
        // This is for making the window not to effect the StatusBarStyle
        window.bounds.size.height = UIScreen.main.bounds.height.nextDown
        window.isHidden = true
        return window
    }()
    
    private var configuration: KZAlertConfiguration
    
    private weak var container: UIViewController?
    
    private lazy var backgroundView: KZAlertBackgroundView = KZAlertBackgroundView.init(with: configuration)
    private lazy var contentBackgroundView: KZAlertContentBackgroundView = KZAlertContentBackgroundView.init(with: configuration)
    private lazy var contentView: KZAlertContentView = KZAlertContentView.init(with: configuration)
    private lazy var bottomContainer: KZAlertBottomContainer = KZAlertBottomContainer.init(with: configuration)
    
    private var vectorImageHeader: KZAlertVectorHeader?
    private var actionView: KZAlertActionView?
    
    private var contentBackgroundBottomConstraint: Constraint?
    
    private var dismissCallback: [() -> ()] = []
    
    private var autoHideTimer: Timer?
    
    fileprivate init(configuration: KZAlertConfiguration) {
        self.configuration = configuration
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .clear
        self.processConfiguration()
        if self.configuration.themeMode == .dark {
            if #available(iOS 13.0, *) {
                self.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("不支持Xib / Storyboard")
    }
}
//MARK: Public Setter Getter
extension KZAlertView {
    public var textFields: [UITextField] {
        return self.contentView.textFields
    }
    
    public var buttons: [UIButton] {
        return self.actionView?.buttons ?? []
    }
    
    public var isShowing: Bool {
        return self.superview === getContainerView()
    }
}

//MARK: Public Functions
extension KZAlertView {
    public static func alert(with configuration: KZAlertConfiguration) -> KZAlertView {
        let alertView = KZAlertView(configuration: configuration)
        return alertView
    }
    
    public func show(in container: UIViewController? = nil) {
        self.container = container
        KZAlertViewStack.shared.addAlert(self, stackType: configuration.showStackType, in: getContainerView()) {[weak self] in
            self?.innerShow()
        }
    }
        
    public func dismiss() {
        autoHideTimer?.invalidate()
        autoHideTimer = nil
        startDismissAnimation()
    }
    
    public func addDismissCallback(_ callback: @escaping (() -> ())) {
        dismissCallback.append(callback)
    }
}

//MARK: Override Functions
extension KZAlertView {
    public override var alpha: CGFloat {
        set {
            super.alpha = newValue
            backgroundView.alpha = newValue
        }
        get {
            return super.alpha
        }
    }
    
    public override func removeFromSuperview() {
        self.backgroundView.removeFromSuperview()
        super.removeFromSuperview()
        self.autoHideTimer?.invalidate()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        frame = KZAlertView.shareWindow.convert(UIScreen.main.bounds, to: getContainerView())
        /// background 用 frame 保证一开始就能展示
        backgroundView.frame = self.frame
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endEditing(true)
        guard configuration.dismissOnOutsideTouch || configuration.allButtonCount == 0 else { return }
        guard let anyTouch = touches.first else { return }
        guard !contentBackgroundView.frame.contains(anyTouch.location(in: self)) else { return }
        configuration.cancelAction?.handler?()
        dismiss()
    }
}

//MARK: Private Setter Getter
extension KZAlertView {
    private func getContainerView() -> UIView {
        return container?.view ?? KZAlertView.shareWindow
    }
}

//MARK: Private Functions
extension KZAlertView {
    
    private func startToObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupAutoHidden() {
        guard case .seconds(let time) = configuration.autoHide else { return }
        autoHideTimer?.invalidate()
        autoHideTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(autoHideTimerAction), userInfo: nil, repeats: false)
    }
    
    private func setupAlert() {
        // 基准frame, 不用snap
        frame = KZAlertView.shareWindow.convert(UIScreen.main.bounds, to: getContainerView())
        
        setupBackground()
        setupContentBackgroundView()
        setupVectorImageHeader()
        setupBottomContainer()
        setupContentView()
        setupActionView()
        
        getContainerView().addSubview(self)
        getContainerView().bringSubviewToFront(self)
        
        setupAutoLayout()
    }
    
    private func setupBackground() {
        getContainerView().addSubview(backgroundView)
    }
    
    private func setupContentBackgroundView() {
        addSubview(contentBackgroundView)
    }
    
    private func setupBottomContainer() {
        contentBackgroundView.addSubview(bottomContainer)
    }
    
    private func setupContentView() {
        bottomContainer.addSubview(contentView)
    }
    
    private func setupActionView() {
        guard let actionView = KZAlertActionView(with: configuration) else { return }
        self.actionView = actionView
        bottomContainer.addSubview(actionView)
    }
    
    private func setupVectorImageHeader() {
        guard let vectorImageHeader = KZAlertVectorHeader(with: configuration) else { return }
        self.vectorImageHeader = vectorImageHeader
        contentBackgroundView.addSubview(vectorImageHeader)
    }
    
    private func setupAutoLayout() {
        /// background 用 frame 保证一开始就能展示
        backgroundView.frame = self.frame
        
        contentBackgroundView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(configuration.alertCenterOffset.x)
            make.centerY.equalTo(self).offset(configuration.alertCenterOffset.y).priority(.low)
            make.width.equalTo(configAlertWidth())
            if configuration.maxHeight != KZAlertConfiguration.automaticDimension {
                make.height.lessThanOrEqualTo(configuration.maxHeight)
            }
            if #available(iOS 11.0, *) {
                make.top.greaterThanOrEqualTo(getContainerView().safeAreaLayoutGuide.snp.top).offset(10).priority(.required)
                make.bottom.lessThanOrEqualTo(getContainerView().safeAreaLayoutGuide.snp.bottom).offset(-10).priority(.required)
            } else {
                if let showInController = self.container {
                    make.top.greaterThanOrEqualTo(showInController.topLayoutGuide.snp.bottom).offset(10).priority(.required)
                    make.bottom.lessThanOrEqualTo(showInController.bottomLayoutGuide.snp.top).offset(-10).priority(.required)
                } else { // Show in window
                    make.top.greaterThanOrEqualTo(self.snp.top).offset(30).priority(.required)
                    make.bottom.lessThanOrEqualTo(self.snp.bottom).offset(-30).priority(.required)
                }
            }
            contentBackgroundBottomConstraint = make.bottom.equalToSuperview().priority(.init(1)).constraint
        }
        
        vectorImageHeader?.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(configuration.vectorImageRadius * 2 + configuration.vectorImageEdge.bottom)
        }
        
        bottomContainer.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            if let vectorImageHeader = self.vectorImageHeader {
                make.top.equalTo(vectorImageHeader.snp.bottom)
            } else {
                make.top.equalToSuperview()
            }
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            if actionView == nil {
                make.bottom.equalToSuperview()
            }
        }
        
        actionView?.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(contentView.snp.bottom)
        }
    }
    
    private func innerShow() {
        if container == nil {
            KZAlertView.shareWindow.makeKey()
            KZAlertView.shareWindow.isHidden = false
        }
            
        if configuration.textfields.isEmpty {
            UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        setupAlert()
        startToObserve()
        startShowAnimation()
    }
    
    private func startShowAnimation() {
        self.layoutIfNeeded()
        self.textFields.first?.becomeFirstResponder()
        self.alpha = 0
        deformationLessThanNormal(configuration.animationIn)
        UIView.animateKeyframes(withDuration: getAnimationTimeInterval(configuration.animationIn), delay: 0, options: .calculationModeLinear, animations: {
            if self.configuration.turnOnBounceAnimation {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                    self.alpha = 1
                    self.deformationGreaterThanNormal(self.configuration.animationIn)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                    self.normalDeformation()
                }
            } else {
                self.alpha = 1
                self.normalDeformation()
            }
        }, completion: { _ in
            self.setupAutoHidden()
        })
    }
    
    private func startDismissAnimation() {
        endEditing(true)
        normalDeformation()
        UIView.animateKeyframes(withDuration: getAnimationTimeInterval(configuration.animationOut), delay: 0, options: .calculationModeLinear, animations: {
            if self.configuration.turnOnBounceAnimation {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                    self.deformationGreaterThanNormal(self.configuration.animationOut)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                    self.alpha = 0
                    self.deformationLessThanNormal(self.configuration.animationOut)
                }
            } else {
                self.alpha = 0
                self.deformationLessThanNormal(self.configuration.animationOut)
            }
        }, completion: { (_) in
            self.removeFromSuperview()
            KZAlertView.shareWindow.resignKey()
            KZAlertView.shareWindow.isHidden = true
            self.dismissCallback.forEach({ $0() })
        })
    }
}

//MARK: Objc Event
extension KZAlertView {
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        guard let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        var curve: UIView.AnimationOptions = .curveEaseInOut
        var duration: TimeInterval = 0.25
        if let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            curve = UIView.AnimationOptions(rawValue: curveValue)
        }
        if let infoDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            duration = infoDuration
        }
        UIView.animate(withDuration: duration, delay: 0, options: curve.union(.beginFromCurrentState), animations: {
            self.contentBackgroundBottomConstraint?.update(offset: -kbFrame.height - 5)
            self.contentBackgroundBottomConstraint?.update(priority: .init(999))
            self.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let info = notification.userInfo else { return }
        var curve: UIView.AnimationOptions = .curveEaseInOut
        var duration: TimeInterval = 0.25
        if let curveValue = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            curve = UIView.AnimationOptions(rawValue: curveValue)
        }
        if let infoDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            duration = infoDuration
        }
        UIView.animate(withDuration: duration, delay: 0, options: curve.union(.beginFromCurrentState), animations: {
            self.contentBackgroundBottomConstraint?.update(priority: .init(1))
            self.layoutIfNeeded()
        })
    }
    
    
    @objc private func autoHideTimerAction() {
        dismiss()
    }
}
 

//MARK: Tools
extension KZAlertView {
    private func configAlertWidth() -> CGFloat {
        guard (configuration.width == KZAlertConfiguration.automaticDimension) || (configuration.width >= UIScreen.main.bounds.width) else { return configuration.width }
        let screenW = UIScreen.main.bounds.width
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 320
        case .phone:
            if screenW <= 320 { // SE/5s 以下
                return 260
            } else if screenW <= 375 { // 6/7/8/X
                return 270
            } else if screenW <= 414 { // XPM XR
                return 300
            } else {
                return 320
            }
        default:
            fatalError("不支持的设备类型")
        }
    }
    
    private func themeIsDark() -> Bool {
        if configuration.themeMode == .dark {
            return true
        }
        if #available(iOS 13.0, *) {
            if configuration.themeMode == .followSystem, self.traitCollection.userInterfaceStyle == .dark {
                return true
            }
        }
        return false
    }
    
    private func getAnimationTimeInterval(_ animation: KZAlertConfiguration.AlertAnimation) -> TimeInterval {
        guard configuration.turnOnBounceAnimation else { return 0.25 }
        switch animation {
        case .center: return 0.3
        case .left, .right: return 0.5
        case .top, .bottom:  return 0.6
        }
    }
    
    private func deformationLessThanNormal(_ style: KZAlertConfiguration.AlertAnimation) {
        switch style {
        case .center: contentBackgroundView.transform = .init(scaleX: 0.9, y: 0.9)
        case .left: contentBackgroundView.transform = .init(translationX: -(contentBackgroundView.frame.width + contentBackgroundView.frame.origin.x + 15), y: 0)
        case .right: contentBackgroundView.transform = .init(translationX: bounds.width - contentBackgroundView.frame.origin.x + 15, y: 0)
        case .top: contentBackgroundView.transform = .init(translationX: 0, y: -(contentBackgroundView.frame.origin.y + contentBackgroundView.frame.height + 15))
        case .bottom: contentBackgroundView.transform = .init(translationX: 0, y: (bounds.height - contentView.frame.origin.y))
        }
    }
    
    private func deformationGreaterThanNormal(_ style: KZAlertConfiguration.AlertAnimation) {
        switch style {
        case .center: contentBackgroundView.transform = .init(scaleX: 1.05, y: 1.05)
        case .left: contentBackgroundView.transform = .init(translationX: 7.5, y: 0)
        case .right: contentBackgroundView.transform = .init(translationX: -7.5, y: 0)
        case .top: contentBackgroundView.transform = .init(translationX: 0, y: 7.5)
        case .bottom: contentBackgroundView.transform = .init(translationX: 0, y: -7.5)
        }
    }
    
    private func normalDeformation() {
        contentBackgroundView.transform = .identity
    }
    
    private func processConfiguration() {
        // Actions
        func processAction(_ originalAction: KZAlertConfiguration.AlertAction) -> KZAlertConfiguration.AlertAction {
            var newAction = originalAction
            let originalHandler = originalAction.handler
            newAction.handler = {[weak self] in
                originalHandler?()
                self?.contentView.alertDidComplete()
                self?.dismiss()
            }
            return newAction
        }
        configuration.actions = configuration.actions.map(processAction)
        if let cancelAction = configuration.cancelAction {
            configuration.cancelAction = processAction(cancelAction)
        }
        
        if configuration.width <= 0 {
            configuration.width = KZAlertConfiguration.automaticDimension
        }
        
        if configuration.maxHeight <= 0 {
            configuration.maxHeight = KZAlertConfiguration.automaticDimension
        }
    }
}

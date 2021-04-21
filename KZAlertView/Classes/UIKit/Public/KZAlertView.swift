//
//  KZAlertView.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/9.
//

import UIKit
import SnapKit
import AVFoundation

final public class KZAlertView: UIView {
    
    private var configuration: KZAlertConfiguration
    private weak var container: UIViewController?
    private var contentBackgroundView: KZAlertContentBackgroundView!
    private lazy var contentView: KZAlertContentView = KZAlertContentView.init(with: configuration)
    private lazy var bottomContainer: KZAlertBottomContainer = KZAlertBottomContainer.init(with: configuration)
    private var backgroundView: KZAlertBackgroundView?
    private var vectorImageHeader: KZAlertVectorHeader?
    private var actionView: KZAlertActionView?
    private var contentBackgroundBottomConstraint: Constraint?
    private var dismissCallback: [() -> ()] = []
    private var autoHideTimer: Timer?
    private var soundPlayer: AVAudioPlayer?
    private var _isShowing = false
    private var boundsObservation: NSKeyValueObservation?
    
    fileprivate init(configuration: KZAlertConfiguration) {
        self.configuration = configuration
        super.init(frame: UIScreen.main.bounds)
        super.backgroundColor = .clear
        self.processConfiguration()
        if self.configuration.themeMode == .dark {
            if #available(iOS 13.0, *) {
                self.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("Unsupport Xib / Storyboard")
    }
}
//MARK: Public Setter Getter
extension KZAlertView {
    
    /// Return all textfields
    public var textFields: [UITextField] {
        return self.contentView.textFields
    }
    
    /// Return all buttons, If `KZAlertConfiguration.cancelAction` is not empty, cancel button will always be the last
    public var buttons: [UIButton] {
        return self.actionView?.buttons ?? []
    }
    
    /// Return true when alert is already shown
    public var isShowing: Bool {
        return _isShowing
    }
}

//MARK: Public Functions
extension KZAlertView {
    
    /// Create a alert view with configuration
    /// - Parameter configuration: KZAlertConfiguration
    /// - Returns: alert view instance
    public static func alert(with configuration: KZAlertConfiguration) -> KZAlertView {
        let alertView = KZAlertView(configuration: configuration)
        return alertView
    }
    
    
    /// Show alert in container controller
    /// - Parameter container: container controller, if nil, the alert will show in private custom window
    public func show(in container: UIViewController? = nil) {
        self.container = container
        KZAlertViewStack.shared.addAlert(self, stackType: configuration.showStackType, in: getContainerView()) {[weak self] in
            self?.privateShow()
        }
    }
        
    /// dismiss alert
    public func dismiss() {
        privateDismiss()
    }
}

//MARK: Override Functions
extension KZAlertView {
    
    /// Please set background color use `KZAlertConfiguration.backgroundColor`
    public override var backgroundColor: UIColor? {
        set {
            assert(false, "Please set background color use `KZAlertConfiguration` `backgroundColor`")
            if let color = newValue {
                configuration.backgroundColor = .force(color)
            }
        }
        get {
            return configuration.backgroundColor.getColor(by: configuration.themeMode)
        }
    }
    
    public override var frame: CGRect {
        didSet {
            backgroundView?.frame = frame
        }
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        self.autoHideTimer?.invalidate()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // base frame
        frame = KZAlertWindow.shareWindow.convert(UIScreen.main.bounds, to: getContainerView())
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endEditing(true)
        guard configuration.dismissOnOutsideTouch || configuration.allButtonCount == 0 else { return }
        guard let anyTouch = touches.first else { return }
        guard !contentBackgroundView.frame.contains(anyTouch.location(in: self)) else { return }
        cancel()
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let result: Bool
        let isTouchContent = contentBackgroundView.frame.contains(point)
        if configuration.fullCoverageContainer {
            result = super.point(inside: point, with: event)
        } else {
            result = isUserInteractionEnabled && isTouchContent
        }
        if result && configuration.dismissOnContentTouch && isTouchContent{
            if !(self.buttons.map({ $0.convert($0.bounds, to: self) }).filter({ $0.contains(point) }).isEmpty) {
                return result
            }
            if !(self.textFields.map({ $0.convert($0.bounds, to: self) }).filter({ $0.contains(point) }).isEmpty) {
                return result
            }
            if let customContent = configuration.customContent {
                let coverPoint = self.convert(point, to: customContent)
                if customContent.containsUserInteractionEnabledView(coverPoint) {
                    return result
                }
            }
            cancel()
        }
        return result
    }
}

//MARK: Private Setter Getter
extension KZAlertView {
    
    /// Add dismiss alert callback closure
    internal func addDismissCallback(_ callback: @escaping (() -> ())) {
        dismissCallback.append(callback)
    }
    
    private func getContainerView() -> UIView {
        return container?.view ?? KZAlertWindow.shareWindow
    }
    
    private static var containerViewBackgroundViewAssociatedKey = "containerViewBackgroundViewAssociatedKey"
    private func getBackgroundView() -> KZAlertBackgroundView {
        let containerView = getContainerView()
        if let existBackgroundView = objc_getAssociatedObject(containerView, &Self.containerViewBackgroundViewAssociatedKey) as? KZAlertBackgroundView {
            return existBackgroundView
        } else {
            let backgroundView = KZAlertBackgroundView.init(with: configuration)
            objc_setAssociatedObject(containerView, &Self.containerViewBackgroundViewAssociatedKey, backgroundView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return backgroundView
        }
    }
    
    private func showBackgroundWithAlpha() {
        backgroundView?.alpha = 1
    }
    
    private func hideBackgroundWithAlpha() {
        if KZAlertViewStack.shared.alertCount(in: getContainerView()) == 1 {
            backgroundView?.alpha = 0
        }
    }
}

//MARK: Private Functions
extension KZAlertView {
    
    private func startToObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupAutoHidden() {
        autoHideTimer?.invalidate()
        
        if case .disabled = configuration.autoDismiss {
            return
        }
        
        switch configuration.autoDismiss {
        case .disabled: return
        case .force(let time), .noUserTouch(let time):
            autoHideTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(autoHideTimerAction), userInfo: nil, repeats: false)
        }
    }
    
    private func setupAlert() {
        setupBackground()
        setupContentBackgroundView()
        setupVectorImageHeader()
        setupBottomContainer()
        setupContentView()
        setupActionView()
        
        getContainerView().addSubview(self)
        getContainerView().bringSubviewToFront(self)
        
        setupAutoLayout()
        
        setupSoundPlayer()
        
        setupSwipeGesture()
    }
    
    private func setupBackground() {
        backgroundView = getBackgroundView()
        if backgroundView!.superview != getContainerView() {
            backgroundView!.removeFromSuperview()
            getContainerView().addSubview(backgroundView!)
        }
        backgroundView!.isHidden = !configuration.fullCoverageContainer
        backgroundView!.reload(configuration)
    }
    
    private func setupContentBackgroundView() {
        let userDidTouchAlert = { [unowned self] in
            guard case .noUserTouch = self.configuration.autoDismiss else { return }
            self.autoHideTimer?.invalidate()
            self.autoHideTimer = nil
        }
        contentBackgroundView = KZAlertContentBackgroundView.init(with: configuration, userDidTouchAlert: userDidTouchAlert)
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
        contentBackgroundView.snp.makeConstraints { (make) in
            make.width.equalTo(configAlertWidth())
            make.centerX.equalTo(self).offset(configuration.alertCenterOffset.x)
            if configuration.maxHeight != KZAlertConfiguration.automaticDimension {
                make.height.lessThanOrEqualTo(configuration.maxHeight)
            }
            
            switch configuration.position {
            case .center:
                make.centerY.equalTo(self).offset(configuration.alertCenterOffset.y).priority(.low)
                let (topOffset, bottomOffset) = caculateTopBottomSpace()
                make.top.greaterThanOrEqualTo(self.snp.top).offset(topOffset).priority(.required)
                contentBackgroundBottomConstraint = make.bottom.lessThanOrEqualTo(self.snp.bottom).offset(-bottomOffset).priority(.required).constraint
            case .top(space: let space):
                let (topOffset, bottomOffset) = caculateTopBottomSpace()
                make.top.equalTo(self.snp.top).offset(topOffset + space - 10).priority(.required)
                contentBackgroundBottomConstraint = make.bottom.lessThanOrEqualTo(self.snp.bottom).offset(-bottomOffset).priority(.required).constraint
            case .bottom(space: let space):
                let (topOffset, bottomOffset) = caculateTopBottomSpace()
                make.top.greaterThanOrEqualTo(self.snp.top).offset(topOffset).priority(.required)
                contentBackgroundBottomConstraint = make.bottom.equalTo(self.snp.bottom).offset(-bottomOffset - space + 10).priority(.required).constraint
            }
        }
        
        vectorImageHeader?.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            let r = configuration.vectorImageRadius + configuration.vectorImageSpace
            let vertical = configuration.vectorImageOffset.vertical
            if vertical < 0 {
                make.height.equalTo(max(r + vertical, configuration.cornerRadius) + abs(vertical) + r)
            } else { // >= 0
                make.height.equalTo(r + max(vertical, r))
            }
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
        
    private func setupSoundPlayer() {
        guard let url = configuration.playSoundFileUrl else { return }
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.numberOfLoops = 0
        } catch {
            assert(false, error.localizedDescription)
        }
    }
    
    private func setupSwipeGesture() {
        guard configuration.swipeToDismiss else { return }
        let allDirection: [UISwipeGestureRecognizer.Direction] = [.left, .right, .up, .down]
        allDirection.forEach { (direction) in
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
            swipe.direction = direction
            contentBackgroundView.addGestureRecognizer(swipe)
        }
    }
    
    private func privateShow() {
        KZAlertWindow.shareWindow.showIfNeed(!configuration.textfields.isEmpty)
        if configuration.textfields.isEmpty {
            UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        }
         
        boundsObservation = getContainerView().layer.observe(\.bounds, options: .new) {[weak self] (view, value) in
            self?.setNeedsLayout()
        }
        
        setupAlert()
        startToObserve()
        startShowAnimation()
        soundPlayer?.play()
    }
    
    private func cancel() {
        configuration.cancelAction?.handler?(self, actionView!.cancelButton!)
        privateDismiss()
    }
    
    private func privateDismiss() {
        autoHideTimer?.invalidate()
        autoHideTimer = nil
        contentView.alertDidComplete(self)
        startDismissAnimation()
    }
    
    private func startShowAnimation() {
        guard !_isShowing else { return }
        configuration.delegate?.alertViewWillShow(self)
        configuration.customContent?.alertViewWillShow(self)
        _isShowing = true
        setNeedsLayout()
        layoutIfNeeded()
        textFields.first?.becomeFirstResponder()
        alpha = 0
        deformationLessThanNormal(configuration.animationIn)
        UIView.animateKeyframes(withDuration: getAnimationTimeInterval(configuration.animationIn), delay: 0, options: .calculationModeLinear, animations: {
            if self.configuration.bounceAnimation {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                    self.alpha = 1
                    self.showBackgroundWithAlpha()
                    self.deformationGreaterThanNormal(self.configuration.animationIn)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                    self.normalDeformation()
                }
            } else {
                self.alpha = 1
                self.showBackgroundWithAlpha()
                self.normalDeformation()
            }
        }, completion: { _ in
            self.setupAutoHidden()
            self.configuration.delegate?.alertViewDidShow(self)
            self.configuration.customContent?.alertViewWillShow(self)
        })
    }
    
    private func startDismissAnimation() {
        dismissAnimation(with: configuration.animationOut, bounceAnimation: configuration.bounceAnimation)
    }
    
    private func dismissAnimation(with animation: KZAlertConfiguration.AlertAnimation, bounceAnimation: Bool) {
        guard _isShowing else { return }
        configuration.delegate?.alertViewWillDismiss(self)
        configuration.customContent?.alertViewWillDismiss(self)
        _isShowing = false
        endEditing(true)
        normalDeformation()
        UIView.animateKeyframes(withDuration: getAnimationTimeInterval(animation), delay: 0, options: .calculationModeLinear, animations: {
            if bounceAnimation {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                    self.deformationGreaterThanNormal(animation)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                    self.alpha = 0
                    self.hideBackgroundWithAlpha()
                    self.deformationLessThanNormal(animation)
                }
            } else {
                self.alpha = 0
                self.hideBackgroundWithAlpha()
                self.deformationLessThanNormal(animation)
            }
        }, completion: { (_) in
            self.removeFromSuperview()
            self.dismissCallback.forEach({ $0() })
            self.configuration.finallayDismissAction?(self)
            KZAlertWindow.shareWindow.hiddenIfNeed()
            self.configuration.delegate?.alertViewDidDismiss(self)
            self.configuration.customContent?.alertViewDidDismiss(self)
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
            self.contentBackgroundBottomConstraint?.update(offset: -kbFrame.height - 10)
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
            self.contentBackgroundBottomConstraint?.update(offset: -self.caculateTopBottomSpace().bottom)
            self.layoutIfNeeded()
        })
    }
    
    
    @objc private func autoHideTimerAction() {
        cancel()
    }
    
    
    @objc private func swipeAction(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            configuration.cancelAction?.handler?(self, actionView!.cancelButton!)
            dismissAnimation(with: .left, bounceAnimation: false)
        case .right:
            configuration.cancelAction?.handler?(self, actionView!.cancelButton!)
            dismissAnimation(with: .right, bounceAnimation: false)
        case .up:
            configuration.cancelAction?.handler?(self, actionView!.cancelButton!)
            dismissAnimation(with: .top, bounceAnimation: false)
        case .down:
            configuration.cancelAction?.handler?(self, actionView!.cancelButton!)
            dismissAnimation(with: .bottom, bounceAnimation: false)
        default:
            break
        }
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
            if screenW <= 320 { // SE/5s 4
                return 260
            } else if screenW <= 375 { // 6/7/8/X
                return 270
            } else if screenW <= 414 { // XPM XR
                return 300
            } else {
                return 320
            }
        default:
            fatalError("Unsupport")
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
        guard configuration.bounceAnimation else { return 0.25 }
        switch animation {
        case .center:
            return 0.3
        case .left, .right:
            return 0.5
        case .top, .bottom:
            return 0.6
        }
    }
    
    private func deformationLessThanNormal(_ style: KZAlertConfiguration.AlertAnimation) {
        switch style {
        case .center: contentBackgroundView.transform = .init(scaleX: 0.9, y: 0.9)
        case .left: contentBackgroundView.transform = .init(translationX: -(contentBackgroundView.frame.width + contentBackgroundView.frame.origin.x + 15), y: 0)
        case .right: contentBackgroundView.transform = .init(translationX: bounds.width - contentBackgroundView.frame.origin.x + 15, y: 0)
        case .top: contentBackgroundView.transform = .init(translationX: 0, y: -(contentBackgroundView.frame.origin.y + contentBackgroundView.frame.height + 15))
        case .bottom: contentBackgroundView.transform = .init(translationX: 0, y: (bounds.height - contentBackgroundView.frame.origin.y))
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
            newAction._handler = {[weak self] btn in
                guard let self = self else { return }
                originalHandler?(self, btn)
                if self.configuration.dismissOnActionHandled == true {
                    self.privateDismiss()
                }
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
        
        if !configuration.textfields.isEmpty {
            configuration.autoDismiss = .disabled
        }
    }
    
    private func caculateTopBottomSpace() -> (top: CGFloat, bottom: CGFloat) {
        var topOffset: CGFloat = 10
        var bottomOffset: CGFloat = 10
        if #available(iOS 11.0, *) {
            topOffset += getContainerView().safeAreaInsets.top
            bottomOffset += getContainerView().safeAreaInsets.bottom
        } else {
            if let showInController = self.container {
                topOffset += showInController.topLayoutGuide.length
                bottomOffset += showInController.bottomLayoutGuide.length
            }
        }
        return (top: topOffset, bottom: bottomOffset)
    }
}

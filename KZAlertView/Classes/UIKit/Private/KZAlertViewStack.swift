//
//  KZAlertViewStack.swift
//  KZAlertView
//
//  Created by Kagen Zhao on 2020/9/14.
//

import UIKit

internal class KZAlertViewStack {
    
    static let shared: KZAlertViewStack = .init()
            
    private var weakStacks: NSMapTable<UIView, AlertWapper> = .init(keyOptions: .weakMemory, valueOptions: .strongMemory)
        
    func alertCount(in container: UIView) -> Int {
        let wapper = getWapper(in: container)
        return wapper.count
    }
    
    func addAlert(_ alert: KZAlertView, stackType: KZAlertConfiguration.AlertShowStackType, in container: UIView, showAction: @escaping (() -> ())) {

        guard container !== KZAlertWindow.shareWindow else {
            addAlertInWindow(alert, stackType: stackType, showAction: showAction)
            return
        }
        
        let wapper = getWapper(in: container)
        switch stackType {
        case .superimposed:
            wapper.overlay(OverlayAlertItem.init(alert: alert, showAction: showAction))
        case .FIFO:
            wapper.add(AlertItem(alert: alert, showAction: showAction))
        case .LIFO:
            wapper.insertNextFirst(AlertItem(alert: alert, showAction: showAction))
        case .required:
            wapper.forceInFirst(AlertItem(alert: alert, showAction: showAction))
        case .unrequired:
            wapper.tryShow(AlertItem(alert: alert, showAction: showAction))
        }
        
        let currentWindowWapper = getWindowWapper()
        if currentWindowWapper.currentItem == nil {
            wapper.showFirst()
        }
    }
    
    private func addAlertInWindow(_ alert: KZAlertView, stackType: KZAlertConfiguration.AlertShowStackType, showAction: @escaping (() -> ())) {
        let wapper = getWindowWapper()
        switch stackType {
        case .superimposed:
            wapper.overlay(OverlayAlertItem.init(alert: alert, showAction: showAction))
        case .FIFO:
            wapper.add(AlertItem(alert: alert, showAction: showAction))
        case .LIFO:
            wapper.insertNextFirst(AlertItem(alert: alert, showAction: showAction))
        case .required:
            wapper.forceInFirst(AlertItem(alert: alert, showAction: showAction))
        case .unrequired:
            wapper.tryShow(AlertItem(alert: alert, showAction: showAction))
        }
        wapper.showFirst()
    }
    
    private func getWapper(in view: UIView) -> AlertWapper {
        var wapper = weakStacks.object(forKey: view)
        if view === KZAlertWindow.shareWindow {
            if wapper == nil {
                wapper = WindowAlertWapper()
                weakStacks.setObject(wapper, forKey: view)
            }
        } else {
            if wapper == nil {
                wapper = AlertWapper()
                weakStacks.setObject(wapper, forKey: view)
            }
        }
        return wapper!
    }
    
    private func getWindowWapper() -> WindowAlertWapper {
        return getWapper(in: KZAlertWindow.shareWindow) as! WindowAlertWapper
    }
    
    fileprivate func windowDidDismissAllAlert() {
        weakStacks.objectEnumerator()?.compactMap({ $0 as? AlertWapper }).forEach({ (wapper) in
            wapper.showFirst()
        })
    }
}


private class AlertItem {
    let alert: KZAlertView
    let showAction: (() -> ())
    var nextAlert: AlertItem?
    var alertDidDismissClosure: (() -> ())?
    
    init(alert: KZAlertView, showAction: @escaping (() -> ())) {
        self.alert = alert
        self.showAction = showAction
        self.alert.addDismissCallback { [weak self] in
            self?.alertDidDismiss()
        }
    }
    
    func alertDidDismiss() {
        if let next = nextAlert {
            DispatchQueue.safeAsyncInMainThread {
                next.showAction()
            }
        }
        alertDidDismissClosure?()
    }
}

private class AlertWapper {
    private let lock = NSLock()
    var currentItem: AlertItem?
    
    var count: Int {
        lock.lock()
        var lastItem = currentItem
        var count = 0
        while lastItem != nil {
            count += 1
            lastItem = lastItem?.nextAlert
        }
        lock.unlock()
        return count
    }

    func overlay(_ item: OverlayAlertItem) {
        setupItem(item)
        lock.lock()
        if let currentItem = currentItem {
            item.nextAlert = currentItem
            self.currentItem = item
        } else {
            currentItem = item
        }
        lock.unlock()
        item.showAction()
    }
    
    
    // FIFO
    func add(_ item: AlertItem) {
        setupItem(item)
        lock.lock()
        func last() -> AlertItem? {
            var lastItem = currentItem
            while lastItem?.nextAlert != nil {
                lastItem = lastItem?.nextAlert!
            }
            return lastItem
        }
        if let lastItem = last() {
            lastItem.nextAlert = item
        } else {
            currentItem = item
        }
        lock.unlock()
    }
    
    // LIFO
    func insertNextFirst(_ item: AlertItem) {
        setupItem(item)
        lock.lock()
        defer { lock.unlock() }
        if let currentItem = currentItem {
            if currentItem.alert.isShowing {
                item.nextAlert = currentItem.nextAlert
                currentItem.nextAlert = item
            } else {
                item.nextAlert = currentItem
                self.currentItem = item
            }
        } else {
            currentItem = item
        }
    }
    
    func forceInFirst(_ item: AlertItem) {
        setupItem(item)
        lock.lock()
        if let currentItem = currentItem {
            self.currentItem = item
            item.nextAlert = currentItem.nextAlert
            currentItem.nextAlert = nil
            lock.unlock()
            currentItem.alertDidDismissClosure = nil
            currentItem.alert.isHidden = true
            currentItem.alert.dismiss()
        } else {
            currentItem = item
            lock.unlock()
        }
        
    }
    
    func tryShow(_ item: AlertItem) {
        lock.lock()
        defer { lock.unlock() }
        if currentItem == nil {
            setupItem(item)
            currentItem = item
        }
    }
    
    func setupItem(_ item: AlertItem) {
        item.alertDidDismissClosure = { [weak item, weak self] in
            guard let item = item else { return }
            guard let self = self else { return }
            self.alertDidDismiss(item)
        }
    }
    
    func alertDidDismiss(_ item: AlertItem) {
        lock.lock()
        defer { lock.unlock() }
        currentItem = item.nextAlert
    }
    
    func showFirst() {
        if let currentItem = self.currentItem, !currentItem.alert.isShowing {
            DispatchQueue.safeAsyncInMainThread {
                currentItem.showAction()
            }
        }
    }
}

private class OverlayAlertItem: AlertItem {
    override func alertDidDismiss() {
        alertDidDismissClosure?()
    }
}

private class WindowAlertWapper: AlertWapper {
    override func alertDidDismiss(_ item: AlertItem) {
        super.alertDidDismiss(item)
        if item.nextAlert == nil {
            KZAlertViewStack.shared.windowDidDismissAllAlert()
        }
    }
}

extension DispatchQueue {
    fileprivate static func safeAsyncInMainThread(_ closure: @escaping (() -> ())) {
        if Thread.current.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}

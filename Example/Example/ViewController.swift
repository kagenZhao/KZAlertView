//
//  ViewController.swift
//  Example
//
//  Created by Kagen Zhao on 2020/9/15.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import KZAlertView
import DropDown
class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var dataSource: [CellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [
            CellModel.init(title: "Alert Style", index: 0, value: .alertStyle(.normal, all: [.normal, .success, .warning, .error])),
            CellModel.init(title: "Color Scheme", index: 0, value: .colorScheme(.autoCleanColor, all: [.autoCleanColor, .flatTurquoise, .flatGreen, .flatBlue, .flatMidnight, .flatPurple, .flatOrange, .flatRed, .flatSilver, .flatGray])),
            CellModel.init(title: "Show Cancel Button", index: 0, value: .showCancelButton(true, all: [true, false])),
            CellModel.init(title: "Number Of Buttons", index: 0, value: .numberOfButtons(0, all: [0, 1, 2, 3])),
            CellModel.init(title: "Number Of TextFields", index: 0, value: .numberOfTextField(0, all: [0, 1, 2, 3])),
            CellModel.init(title: "Custom Title Font", index: 8, value: .customTitleFont(18, all: [10, 11,12,13,14,15,16,17,18,19,20,21,22])),
            CellModel.init(title: "Custom Message Font", index: 6, value: .customMessageFont(16, all: [10, 11,12,13,14,15,16,17,18,19,20,21,22])),
            CellModel.init(title: "Custom Title Color", index: 0, value: .customTitleColor(nil, all: [nil, .red, .blue])),
            CellModel.init(title: "Custom Message Color", index: 0, value: .customMessageColor(nil, all: [nil, .red, .blue])),
            CellModel.init(title: "Custom Title Text Aligment", index: 2, value: .customTitleTextAligment(.center, all: [.left, .right, .center, .justified, .natural])),
            CellModel.init(title: "Custom Message Text Aligment", index: 2, value: .customMessageTextAligment(.center, all: [.left, .right, .center, .justified, .natural])),
            CellModel.init(title: "Auto Hide", index: 1, value: .audoHide(false, all: [true, false])),
            CellModel.init(title: "Show Stack Type", index: 0, value: .showStackType(.FIFO, all: [.FIFO, .LIFO, .required, .unrequired])),
            CellModel.init(title: "Corner Radius", index: 2, value: .cornerRadius(18, all: [5, 12, 18, 25, 32])),
            CellModel.init(title: "Show Blur Background", index: 1, value: .blurBackground(false, all: [true, false])),
            CellModel.init(title: "Show Dark Background", index: 0, value: .darkBackground(true, all: [true, false])),
            CellModel.init(title: "Bounce Animation", index: 1, value: .bounceAnimation(false, all: [true, false])),
            CellModel.init(title: "Theme Mode", index: 0, value: .themeMode(.followSystem, all: [.followSystem, .light, .dark])),
            CellModel.init(title: "Button Style", index: 0, value: .buttonStyle(.normal(hideSeparator: false), all: [.normal(hideSeparator: false), .detachAndRound])),
            CellModel.init(title: "Vector Image Fill Percentage", index: 2, value: .vectorImageFillPercentage(0.5, all: [0, 0.3, 0.5, 0.8, 1.0])),
            CellModel.init(title: "Animation In", index: 2, value: .animationIn(.center, all: [.left, .right, .center, .top, .bottom])),
            CellModel.init(title: "Animation Out", index: 2, value: .animationOut(.center, all: [.left, .right, .center, .top, .bottom])),
            CellModel.init(title: "Custom Vector Image", index: 1, value: .customVectorImage(false, all: [true, false])),
            CellModel.init(title: "Vector Image Radius", index: 1, value: .vectorImageRadius(30, all: [10, 30, 50])),
            CellModel.init(title: "Vector Image Space", index: 2, value: .vectorImageEdge(4, all: [0, 2, 4, 6, 8])),
            CellModel.init(title: "Show In View", index: 1, value: .inView(false, all: [true, false])),
        ]
    }
    
    @IBAction func showAlert(_ sender: Any) {
        var config = KZAlertConfiguration(title: .string("Alert Title"), message: .string("This is my alert's subtitle. Keep it short and concise. 😜"))
        var container: UIViewController? = nil
        dataSource.forEach { (model) in
            switch model.value {
            case .alertStyle(let value, all: _):
                config.styleLike(value)
            case .showCancelButton(let value, all: _):
                if value {
                    config.cancelAction = .init(title: .string("Cancel"), configuration: nil, handler: {
                        print("Did Tap Cancel Button")
                    })
                } else {
                    config.cancelAction = nil
                }
            case .numberOfButtons(let value, all: _):
                if value > 0 {
                    config.actions = (0..<value).map({ (i) in
                        return .init(title: .string("Custom \(i)"), configuration: nil) {
                            print("Did Tap Custom Button \(i)")
                        }
                    })
                }
            case .numberOfTextField(let value, all: _):
                if value > 0 {
                    config.textfields = (0..<value).map({ (i) in
                        return .init(configuration: { tf in
                            tf.placeholder = "TextField \(i)"
                        }) { (tf) in
                            print("Number \(i) TextField Text is \(tf.text ?? "")")
                        }
                    })
                }
            case .customTitleFont(let value, all: _):
                config.titleFont = UIFont.systemFont(ofSize: value, weight: .medium)
            case .customMessageFont(let value, all: _):
                config.messageFont = UIFont.systemFont(ofSize: value, weight: .regular)
            case .customTitleColor(let value, all: _):
                if value != nil {
                    config.titleColor = .force(value!)
                }
            case .customMessageColor(let value, all: _):
                if value != nil {
                    config.messageColor = .force(value!)
                }
            case .customTitleTextAligment(let value, all: _):
                config.titleTextAligment = value
            case .customMessageTextAligment(let value, all: _):
                config.messageTextAligment = value
            case .audoHide(let value, all: _):
                if value {
                    config.autoHide = .seconds(5)
                } else {
                    config.autoHide = .none
                }
            case .showStackType(let value, all: _):
                config.showStackType = value
            case .cornerRadius(let value, all: _):
                config.cornerRadius = value
            case .blurBackground(let value, all: _):
                config.isBlurBackground = value
            case .darkBackground(let value, all: _):
                config.darkBackgroundHidden = !value
            case .bounceAnimation(let value, all: _):
                config.turnOnBounceAnimation = value
            case .colorScheme(let value, all: _):
                config.colorScheme = value
            case .themeMode(let value, all: _):
                config.themeMode = value
            case .buttonStyle(let value, all: _):
                config.buttonStyle = value
            case .vectorImageFillPercentage(let value, all: _):
                config.vectorImageFillPercentage = value
            case .animationIn(let value, all: _):
                config.animationIn = value
            case .animationOut(let value, all: _):
                config.animationOut = value
            case .customVectorImage(let value, all: _):
                if value {
                    config.vectorImage = UIImage(named: "github-icon")
                }
            case .vectorImageRadius(let value, all: _):
                config.vectorImageRadius = value
            case .vectorImageEdge(let value, all: _):
                config.vectorImageEdge = UIEdgeInsets(top: 0, left: value, bottom: value, right: value)
            case .inView(let value, all: _):
                if value {
                    container = self
                } else {
                    container = nil
                }
            }
        }
        let alert = KZAlertView.alert(with: config)
        alert.show(in: container)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let model = dataSource[indexPath.row]
        cell.textLabel?.text = model.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        switch model.value {
        case .alertStyle(let value, all: _):
            cell.detailTextLabel?.text = "\(value)"
        case .showCancelButton(let value, all: _):
            cell.detailTextLabel?.text = "\(value)"
        case .numberOfButtons(let value, all: _):
            cell.detailTextLabel?.text = "\(value)"
        case .numberOfTextField(let value, all: _):
            cell.detailTextLabel?.text = "\(value)"
        case .customTitleFont(let value, all: _):
            cell.detailTextLabel?.text = "\(value)"
        case .customMessageFont(let value, all: _):
            cell.detailTextLabel?.text = "\(value)"
        case .customTitleColor:
            let list = ["default", "red", "blue"]
            cell.detailTextLabel?.text = "\(list[model.index])"
        case .customMessageColor:
            let list = ["default", "red", "blue"]
            cell.detailTextLabel?.text = "\(list[model.index])"
        case .customTitleTextAligment:
            let list = ["left", "right", "center", "justified", "natural"]
            cell.detailTextLabel?.text = "\(list[model.index])"
        case .customMessageTextAligment:
            let list = ["left", "right", "center", "justified", "natural"]
            cell.detailTextLabel?.text = "\(list[model.index])"
        case .audoHide(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .showStackType(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .cornerRadius(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .blurBackground(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .darkBackground(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .bounceAnimation(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .colorScheme:
            let list = ["autoCleanColor", "flatTurquoise", "flatGreen", "flatBlue", "flatMidnight", "flatPurple", "flatOrange", "flatRed", "flatSilver", "flatGray"]
            cell.detailTextLabel?.text = "\(list[model.index])"
        case .themeMode(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .buttonStyle:
            let list = ["normal", "detachAndRound"]
            cell.detailTextLabel?.text = "\(list[model.index])"
        case .vectorImageFillPercentage(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .animationIn(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .animationOut(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .customVectorImage(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .vectorImageRadius(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .vectorImageEdge(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        case .inView(_, all: let all):
            cell.detailTextLabel?.text = "\(all[model.index])"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let dropDown = DropDown.init(anchorView: cell.detailTextLabel ?? cell)
        dropDown.width = 200
        let model = dataSource[indexPath.row]
        switch model.value {
        case .alertStyle(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                let colorSchemesIndex: [Int] = [0, 2, 6, 7]
                let colorSchemes: [KZAlertConfiguration.AlertColorScheme] = [.autoCleanColor, .flatGreen, .flatOrange, .flatRed]
                self.dataSource[1].index = colorSchemesIndex[idx]
                self.dataSource[1].value.setValue(colorSchemes[idx])
                tableView.reloadData()
            }
        case .showCancelButton(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .numberOfButtons(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .numberOfTextField(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .customTitleFont(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .customMessageFont(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .customTitleColor(_, all: let all):
            let list = ["default", "red", "blue"]
            dropDown.dataSource = list
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .customMessageColor(_, all: let all):
            let list = ["default", "red", "blue"]
            dropDown.dataSource = list
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .customTitleTextAligment(_, all: let all):
            let list = ["left", "right", "center", "justified", "natural"]
            dropDown.dataSource = list
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .customMessageTextAligment(_, all: let all):
            let list = ["left", "right", "center", "justified", "natural"]
            dropDown.dataSource = list
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .audoHide(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .showStackType(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .cornerRadius(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .blurBackground(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .darkBackground(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .bounceAnimation(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .colorScheme(_, all: let all):
            let list = ["autoCleanColor", "flatTurquoise", "flatGreen", "flatBlue", "flatMidnight", "flatPurple", "flatOrange", "flatRed", "flatSilver", "flatGray"]
            dropDown.dataSource = list
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .themeMode(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .buttonStyle(_, all: let all):
            let list = ["normal", "detachAndRound"]
            dropDown.dataSource = list
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .vectorImageFillPercentage(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .animationIn(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .animationOut(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .customVectorImage(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .vectorImageRadius(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .vectorImageEdge(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        case .inView(_, all: let all):
            dropDown.dataSource = all.map({ "\($0)" })
            dropDown.selectionAction = { idx, _ in
                model.index = idx
                model.value.setValue(all[idx])
                tableView.reloadData()
            }
        }
        dropDown.selectRow(model.index)
        dropDown.show()
    }
}

private class CellModel {
    init(title: String, index: Int, value: CellEnum) {
        self.title = title
        self.index = index
        self.value = value
    }
    var title: String
    var index: Int
    var value: CellEnum
}

private enum CellEnum {
    case alertStyle(_ value: KZAlertConfiguration.AlertStyle, all: [KZAlertConfiguration.AlertStyle])
    case showCancelButton(_ value: Bool, all: [Bool])
    case numberOfButtons(_ number: Int, all: [Int])
    case numberOfTextField(_ number: Int, all: [Int])
    case customTitleFont(_ fontSize: CGFloat, all: [CGFloat])
    case customMessageFont(_ fontSize: CGFloat, all: [CGFloat])
    case customTitleColor(_ color: UIColor?, all: [UIColor?])
    case customMessageColor(_ color: UIColor?, all: [UIColor?])
    case customTitleTextAligment(_ alignment: NSTextAlignment, all: [NSTextAlignment])
    case customMessageTextAligment(_ alignment: NSTextAlignment, all: [NSTextAlignment])
    case audoHide(_ value: Bool, all: [Bool])
    case showStackType(_ type: KZAlertConfiguration.AlertShowStackType, all: [KZAlertConfiguration.AlertShowStackType])
    case cornerRadius(_ value: CGFloat, all: [CGFloat])
    case blurBackground(_ value: Bool, all: [Bool])
    case darkBackground(_ value: Bool, all: [Bool])
    case bounceAnimation(_ value: Bool, all: [Bool])
    case colorScheme(_ value: KZAlertConfiguration.AlertColorScheme, all: [KZAlertConfiguration.AlertColorScheme])
    case themeMode(_ value: KZAlertConfiguration.ThemeMode, all: [KZAlertConfiguration.ThemeMode])
    case buttonStyle(_ value: KZAlertConfiguration.ButtonStyle, all: [KZAlertConfiguration.ButtonStyle])
    case vectorImageFillPercentage(_ value: CGFloat, all: [CGFloat])
    case animationIn(_ value: KZAlertConfiguration.AlertAnimation, all: [KZAlertConfiguration.AlertAnimation])
    case animationOut(_ value: KZAlertConfiguration.AlertAnimation, all: [KZAlertConfiguration.AlertAnimation])
    case customVectorImage(_ value: Bool, all: [Bool])
    case vectorImageRadius(_ value: CGFloat, all: [CGFloat])
    case vectorImageEdge(_ value: CGFloat, all: [CGFloat])
    case inView(_ value: Bool, all: [Bool])
    
    mutating func setValue(_ value: Any?) {
        switch self {
        case .alertStyle(_, all: let all):
            self = .alertStyle(value as! KZAlertConfiguration.AlertStyle, all: all)
        case .showCancelButton(_, all: let all):
            self = .showCancelButton(value as! Bool, all: all)
        case .numberOfButtons(_, all: let all):
            self = .numberOfButtons(value as! Int, all: all)
        case .numberOfTextField(_, all: let all):
            self = .numberOfTextField(value as! Int, all: all)
        case .customTitleFont(_, all: let all):
            self = .customTitleFont(value as! CGFloat, all: all)
        case .customMessageFont(_, all: let all):
            self = .customMessageFont(value as! CGFloat, all: all)
        case .customTitleColor(_, all: let all):
            self = .customTitleColor(value as? UIColor, all: all)
        case .customMessageColor(_, all: let all):
            self = .customMessageColor(value as? UIColor, all: all)
        case .customTitleTextAligment(_, all: let all):
            self = .customTitleTextAligment(value as! NSTextAlignment, all: all)
        case .customMessageTextAligment(_, all: let all):
            self = .customMessageTextAligment(value as! NSTextAlignment, all: all)
        case .audoHide(_, all: let all):
            self = .audoHide(value as! Bool, all: all)
        case .showStackType(_, all: let all):
            self = .showStackType(value as! KZAlertConfiguration.AlertShowStackType, all: all)
        case .cornerRadius(_, all: let all):
            self = .cornerRadius(value as! CGFloat, all: all)
        case .blurBackground(_, all: let all):
            self = .blurBackground(value as! Bool, all: all)
        case .darkBackground(_, all: let all):
            self = .darkBackground(value as! Bool, all: all)
        case .bounceAnimation(_, all: let all):
            self = .bounceAnimation(value as! Bool, all: all)
        case .colorScheme(_, all: let all):
            self = .colorScheme(value as! KZAlertConfiguration.AlertColorScheme, all: all)
        case .themeMode(_, all: let all):
            self = .themeMode(value as! KZAlertConfiguration.ThemeMode, all: all)
        case .buttonStyle(_, all: let all):
            self = .buttonStyle(value as! KZAlertConfiguration.ButtonStyle, all: all)
        case .vectorImageFillPercentage(_, all: let all):
            self = .vectorImageFillPercentage(value as! CGFloat, all: all)
        case .animationIn(_, all: let all):
            self = .animationIn(value as! KZAlertConfiguration.AlertAnimation, all: all)
        case .animationOut(_, all: let all):
            self = .animationOut(value as! KZAlertConfiguration.AlertAnimation, all: all)
        case .customVectorImage(_, all: let all):
            self = .customVectorImage(value as! Bool, all: all)
        case .vectorImageRadius(_, all: let all):
            self = .vectorImageRadius(value as! CGFloat, all: all)
        case .vectorImageEdge(_, all: let all):
            self = .vectorImageEdge(value as! CGFloat, all: all)
        case .inView(_, all: let all):
            self = .inView(value as! Bool, all: all)
        }
    }
}

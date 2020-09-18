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
    @IBOutlet var showAlertButton: UIButton!
    
    private var dataSource: [CellModel] = []
    private var configuration: KZAlertConfiguration!
    private let colorSchemes = [KZAlertConfiguration.AlertColorStyle.flatTurquoise, .flatGreen, .flatBlue, .flatMidnight, .flatPurple, .flatOrange, .flatRed, .flatSilver, .flatGray]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlertButton.backgroundColor = UIColor.flatBlue
        showAlertButton.setTitleColor(.white, for: .normal)
        if #available(iOS 11, *) {
            showAlertButton.titleEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0)            
        }
        dataSource = createDataSource()
        
        configuration = KZAlertConfiguration(message: .string("This is my alert's subtitle. Keep it short and concise. 😜"))
        reloadConfigs()
    }
    
    private func createDataSource() -> [CellModel] {
        return [
            CellModel.init(title: "Alert Style", description: "Choose from Pre-Set Success, Warning, Heart Rating and more.", index: 0, allValues: [KZAlertConfiguration.AlertStyle.normal, .success, .warning, .error], config: { ( configuration, value) in
                configuration.styleLike(value!)
            }),
            
            CellModel.init(title: "Color Scheme", description: "Choose your own color scheme or from one of included.", index: 0, allValues: [nil] + colorSchemes, config: { ( configuration, value) in
                configuration.colorScheme = value
            }),
            
            CellModel.init(title: "Show Cancel Button", description: "Hide the Cancel Button that closes the alert.", index: 0, allValues: [true, false], config: { ( configuration, value) in
                if value! {
                    configuration.cancelAction = .init(title: .string("Cancel"), configuration: nil, handler: {
                        print("Did Tap Cancel Button")
                    })
                }
            }),
            
            CellModel.init(title: "Number Of Buttons", description: "You can have unlimit buttons in your alert.", index: 0, allValues: [0, 1, 2, 3], config: { ( configuration, value) in
                if value! > 0 {
                    configuration.actions = (0..<value!).map({ (i) in
                        return .init(title: .string("Custom \(i)"), configuration: nil) {
                            print("Did Tap Custom Button \(i)")
                        }
                    })
                }
            }),
            
            CellModel.init(title: "Number Of TextFields", description: "You can have unlimit textfield in your alert.", index: 0, allValues: [0, 1, 2, 3], config: { ( configuration, value) in
                if value! > 0 {
                    configuration.textfields = (0..<value!).map({ (i) in
                        return .init(configuration: { tf in
                            tf.placeholder = "TextField \(i)"
                        }) { (tf) in
                            print("Number \(i) TextField Text is \(tf.text ?? "")")
                        }
                    })
                }
            }),
            
            CellModel.init(title: "Custom Title Font", description: "Specify a different font for the title - such as Avenir!", index: 0, allValues: [nil, UIFont(name: "Avenir", size: 18)], config: { ( configuration, value) in
                if value != nil {
                    configuration.titleFont = value!
                }
            }),
            
            CellModel.init(title: "Custom Message Font", description: "Specify a different font for the message - such as Avenir!", index: 0, allValues: [nil, UIFont(name: "Avenir", size: 15)], config: { ( configuration, value) in
                if value != nil {
                    configuration.messageFont = value!
                }
            }),
            
            CellModel.init(title: "Custom Title Color", description: "Choose your own title color or from one of included.", index: 0, allValues: [nil] + colorSchemes, config: { ( configuration, value) in
                if value != nil {
                    configuration.titleColor = value!
                }
            }),
            
            CellModel.init(title: "Custom Message Color", description: "Choose your own message color or from one of included.", index: 0, allValues: [nil] + colorSchemes, config: { ( configuration, value) in
                if value != nil {
                    configuration.messageColor = value!
                }
            }),
            
            CellModel.init(title: "Custom Title Text Aligment", description: "Specify text alignment in the title.", index: 2, allValues: [NSTextAlignment.left, .right, .center, .justified, .natural], config: { ( configuration, value) in
                configuration.titleTextAligment = value!
            }),
            
            CellModel.init(title: "Custom Message Text Aligment", description: "Specify text alignment in the message.", index: 2, allValues: [NSTextAlignment.left, .right, .center, .justified, .natural], config: { ( configuration, value) in
                configuration.messageTextAligment = value!
            }),
            
            CellModel.init(title: "Auto Dismiss", description: "Alert will hide after a certain number of seconds.", index: 1, allValues: [true, false], config: { ( configuration, value) in
                if value! {
                    configuration.autoDismiss = .noUserTouch(5)
                }
            }),
            
            CellModel.init(title: "Outside Touch", description: "Alert will hide after outside the alert is touched.", index: 1, allValues: [true, false], config: { ( configuration, value) in
                configuration.dismissOnOutsideTouch = value!
            }),
            
            CellModel.init(title: "Show Stack Type", description: "Show Stack Type", index: 0, allValues: [KZAlertConfiguration.AlertShowStackType.FIFO, .LIFO, .required, .unrequired], config: { ( configuration, value) in
                configuration.showStackType = value!
            }),
            
            CellModel.init(title: "Rounded Corners", description: "Choose the rounding of the alert.", index: 2, allValues: [5, 12, 18, 25, 32], config: { ( configuration, value) in
                configuration.cornerRadius = CGFloat(value!)
            }),
            
            CellModel.init(title: "Show Blur Background", description: "Turn on to add a blur effect to your view's background.", index: 1, allValues: [true, false], config: { ( configuration, value) in
                configuration.isBlurBackground = value!
            }),
            
            CellModel.init(title: "Show Dark Background", description: "Show Dark Background", index: 0, allValues: [true, false], config: { ( configuration, value) in
                configuration.isDarkBackground = value!
            }),
            
            CellModel.init(title: "Bounce Animation", description: "Turn on to add more natural animations to the alert.", index: 1, allValues: [true, false], config: { ( configuration, value) in
                configuration.bounceAnimation = value!
            }),
            
            CellModel.init(title: "Theme Mode", description: "You can change alert color scheme to match the app.", index: 0, allValues: [KZAlertConfiguration.ThemeMode.followSystem, .light, .dark], config: { ( configuration, value) in
                configuration.themeMode = value!
            }),
            
            CellModel.init(title: "Button Style", description: "You can change alert Button Style.", index: 0, allValues: [KZAlertConfiguration.ButtonStyle.normal(hideSeparator: false), .normal(hideSeparator: true), .detachAndRound], config: { ( configuration, value) in
                configuration.buttonStyle = value!
            }),
            
            CellModel.init(title: "Button Highlight", description: "Change the button's background color on highlight.", index: 1, allValues: [true, false], config: { ( configuration, value) in
                if value! {
                    configuration.buttonHighlight = .auto(light: .red, dark: .blue)
                }
            }),
            
            CellModel.init(title: "Vector Image Fill Percentage", description: "Makes the custom image of the alert full circle percentage", index: 2, allValues: [0.0, 0.3, 0.5, 0.8, 1.0], config: { ( configuration, value) in
                configuration.vectorImageFillPercentage = value!
            }),
            
            CellModel.init(title: "Animation In", description: "Animate the Alert In from Top, Right, Bottom, or Left.", index: 2, allValues: [KZAlertConfiguration.AlertAnimation.left, .right, .center, .top, .bottom], config: { ( configuration, value) in
                configuration.animationIn = value!
            }),
            
            CellModel.init(title: "Animation Out", description: "Animate the Alert Out to Top, Right, Bottom, or Left.", index: 2, allValues: [KZAlertConfiguration.AlertAnimation.left, .right, .center, .top, .bottom], config: { ( configuration, value) in
                configuration.animationOut = value!
            }),
            
            CellModel.init(title: "Custom Vector Image", description: "Add a custom image to your alert.", index: 1, allValues: [true, false], config: { ( configuration, value) in
                if value! {
                    configuration.vectorImage = UIImage(named: "github-icon")
                }
            }),
            
            CellModel.init(title: "Vector Image Radius", description: "Vector Image Radius", index: 1, allValues: [10, 30, 50], config: { ( configuration, value) in
                configuration.vectorImageRadius = CGFloat(value!)
            }),
            
            CellModel.init(title: "Vector Image Space", description: "Vector Image Space", index: 2, allValues: [0, 2, 4, 6, 8], config: { ( configuration, value) in
                configuration.vectorImageEdge = UIEdgeInsets(top: value!, left: value!, bottom: value!, right: value!)
            }),
            
            CellModel.init(title: "Play Sound", description: "Turn on to play a custom sound when the alert opens.", index: 1, allValues: [true, false], config: { ( configuration, value) in
                if value! {
                    if let path = Bundle.main.path(forResource: "Elevator Ding", ofType: "mp3") {
                        let url = URL(fileURLWithPath: path)
                        configuration.playSoundFileUrl = url
                    }
                }
            }),
            
            
            CellModel.init(title: "Show Alert Count", description: "Show Alert Count", index: 0, allValues: [1, 2, 3], config: { _, _ in}),
            CellModel.init(title: "Show In View", description: "Show In View", index: 1, allValues: [true, false], config: { _, _ in}),
        ]
    }
    
    @IBAction func showAlert(_ sender: Any) {
        for i in 1...(dataSource[dataSource.count - 2].currentValue! as! Int) {
            createAlert("Alert: \(i)")
        }
    }
    
    private func reloadConfigs() {
        dataSource.forEach({ $0.setConfiguration(&configuration, $0.currentValue) })
    }
    
    private func createAlert(_ title: String) {
        reloadConfigs()
        var container: UIViewController? = nil
        var configuration = self.configuration!
        configuration.title = .string(title)
        let alert = KZAlertView.alert(with: configuration)
        if (dataSource.last!.currentValue! as! Bool) == true {
            container = self
        }
        alert.show(in: container)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let model = dataSource[indexPath.row]
        cell.titleLabel.text = model.title
        cell.descriptionLabel.text = model.description
        cell.statusLabel.text = model.currentValue?.cellDescriptionString ?? "default"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? CustomCell else { return }
        let dropDown = DropDown.init(anchorView: cell.statusLabel)
        dropDown.width = 200
        let model = dataSource[indexPath.row]
        dropDown.dataSource = model.allValues.map({ $0?.cellDescriptionString ?? "default" })
        dropDown.selectionAction = {[unowned self] idx, _ in
            model.setValue(at: idx)
            model.setConfiguration(&configuration, model.currentValue)
            if indexPath.row == 0 { // Alert Style
                if let index = colorSchemes.firstIndex(where: { $0 == configuration.colorScheme }) {
                    dataSource[1].setValue(at: index + 1)
                } else {
                    dataSource[1].setValue(at: 0)
                }
            }
            tableView.reloadData()
        }
        dropDown.selectRow(model.index)
        dropDown.show()
    }
}

extension ViewController {
    @IBAction private func cellLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let indePath = tableView.indexPathForRow(at: gesture.location(in: tableView)) else { return }
        dataSource[indePath.row] = createDataSource()[indePath.row]
        tableView.reloadData()
    }
}

class CustomCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("CustomCell Did Load")
    }
}

//MARK: Test Model
class CellModel {
    private(set) var title: String
    private(set) var description: String
    private(set) var index: Int
    private(set) var currentValue: CellValueCoverable?
    private(set) var allValues: [CellValueCoverable?] = []
    private(set) var setConfiguration: ((inout KZAlertConfiguration, CellValueCoverable?) -> ())
    
    init<T: CellValueCoverable>(title: String, description: String, index: Int, allValues: [T?], config: @escaping ((inout KZAlertConfiguration, T?) -> ())) {
        self.title = title
        self.description = description
        self.index = index
        self.allValues = allValues
        setConfiguration = { configuration, value in
            config(&configuration, value as? T)
        }
        setValue(at: index)
    }
    
    func setValue(at index: Int) {
        if index < allValues.count {
            self.index = index
            currentValue = allValues[index]
        }
    }
}

protocol CellValueCoverable {
    var cellDescriptionString: String { get }
}

extension CellValueCoverable {
    var cellDescriptionString: String {
        return String(describing: self)
    }
}

extension Bool: CellValueCoverable {}
extension Int: CellValueCoverable {}
extension Double: CellValueCoverable {}
extension CGFloat: CellValueCoverable {}
extension KZAlertConfiguration.AlertStyle: CellValueCoverable {}
extension KZAlertConfiguration.AlertShowStackType: CellValueCoverable {}
extension KZAlertConfiguration.ThemeMode: CellValueCoverable {}
extension KZAlertConfiguration.AlertAnimation: CellValueCoverable {}

extension UIFont: CellValueCoverable {
    var cellDescriptionString: String {
        return "\(self.fontName):\(self.pointSize)"
    }
}

extension UIColor: CellValueCoverable {
    var cellDescriptionString: String {
        if self == KZAlertConfiguration.AlertColorStyle.flatBlue.getRawColor() { return "flatBlue" }
        else if self == KZAlertConfiguration.AlertColorStyle.flatTurquoise.getRawColor() { return "flatTurquoise" }
        else if self == KZAlertConfiguration.AlertColorStyle.flatGreen.getRawColor() { return "flatGreen" }
        else if self == KZAlertConfiguration.AlertColorStyle.flatMidnight.getRawColor() { return "flatMidnight" }
        else if self == KZAlertConfiguration.AlertColorStyle.flatPurple.getRawColor() { return "flatPurple" }
        else if self == KZAlertConfiguration.AlertColorStyle.flatOrange.getRawColor() { return "flatOrange" }
        else if self == KZAlertConfiguration.AlertColorStyle.flatRed.getRawColor() { return "flatRed" }
        else if self == KZAlertConfiguration.AlertColorStyle.flatSilver.getRawColor() { return "flatSilver" }
        else if self == KZAlertConfiguration.AlertColorStyle.flatGray.getRawColor() { return "flatGray" }
        else { return "Custom Color"}
    }
}

extension NSTextAlignment: CellValueCoverable {
    var cellDescriptionString: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .center: return "center"
        case .justified: return "justified"
        case .natural: return "natural"
        @unknown default:
            return "unknown"
        }
    }
}

extension KZAlertConfiguration.ButtonStyle: CellValueCoverable {
    var cellDescriptionString: String {
        switch self {
        case .detachAndRound: return "detachAndRound"
        case .normal(hideSeparator: let hideSeparator):
            if hideSeparator {
                return "normalWithoutSeparator"
            } else {
                return "normalWithSeparator"
            }
        }
    }
}

extension KZAlertConfiguration.AlertColorStyle: CellValueCoverable, Equatable {
    var cellDescriptionString: String {
        switch self {
        case .auto:
            return "autoColor"
        case .force(let color):
            return color.cellDescriptionString
        }
    }
    fileprivate func getRawColor() -> UIColor? {
        if case .force(let color) = self {
            return color
        } else {
            return nil
        }
    }
    
    public static func ==(lhs: KZAlertConfiguration.AlertColorStyle, rhs: KZAlertConfiguration.AlertColorStyle) -> Bool {
        switch (lhs, rhs) {
        case (.auto(light: let l1, dark: let d1),.auto(light: let l2, dark: let d2)):
            return l1 == l2 && d1 == d2
        case (.force(let c1), .force(let c2)):
            return c1 == c2
        default:
            return false
        }
    }
}

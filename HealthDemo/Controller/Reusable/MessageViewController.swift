//
//  MessageViewController.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit

class MessageViewController: BaseVC {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: BaseButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        self.messageType?.vcData.pressed()
    }
    var messageType:MessageType? {
        didSet {
            if canUpateUI {
                self.updateUI()

            }
        }
    }
    
    override func updateUI() {
        super.updateUI()
        imageView.setImage(messageType?.vcData.imageName)
        nextButton.setTitle(messageType?.vcData.nextTitle, for: .normal)
        titleLabel.text = messageType?.vcData.title
        descriptionLabel.text = messageType?.vcData.description
    }
    

}

extension MessageViewController {
    static func configure() -> MessageViewController {
        return UIStoryboard(name: "Reusable", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
    }
}


extension MessageViewController {
    enum MessageType {
        case health
        case healphError
        case custom(_ message:LoadingData)
        var vcData:LoadingData {
            switch self {
            case .health:
                return HealthViewModel().displayData
            case .healphError:
                return HealthViewModel().healthNotGranded
            case .custom(let data):
                return data
            }
        }
        
        var isHealth:Bool {
            switch self {
            case .health, .healphError: return true
            default:return false
            }
        }
    }
}

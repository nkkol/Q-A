//
//  ModelViewController.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/18/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class ModelController {
    
    var haveAnAnsw = true
    var isFav = false
    var questions = [Question]()
    var experts = [Expert]()
    let gettingData = UrlSession()
    
    enum AlertType {
        case sendAnAnswer
        case sendAQuestion
        case error
    }
    

    func transitionToNew(_ menuType: MenuType, _ vc: UIViewController, _ modelController: ModelController) {
        switch menuType {
        case .answQ, .nAnswQ, .fav:
            isFav = menuType == .fav ? true : false
            haveAnAnsw = menuType == .answQ || menuType == .fav ? true : false
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            newViewController?.modelController = modelController
            vc.navigationController?.pushViewController(newViewController ?? vc, animated: false)
        default:
            let storyboard: UIStoryboard = UIStoryboard(name: "ToAskStoryboard", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "ToAskViewController") as? ToAskViewController
            newViewController?.modelController = modelController
            vc.navigationController?.pushViewController(newViewController ?? vc, animated: false)
        }
    }
    
    func baseAlert(_ title: String, _ message: String, _ vc: UIViewController, _ parameters: String, _ type: AlertType) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        switch type {
        case .sendAQuestion:
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                    self.gettingData.sendAQuestion(parameters)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        case .sendAnAnswer:
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                self.gettingData.sendAnAnswer(parameters)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        default:
            alert.addAction(UIAlertAction(title: "Okay :(", style: .default, handler: nil))
        }
        vc.present(alert, animated: true)
    }
    
}

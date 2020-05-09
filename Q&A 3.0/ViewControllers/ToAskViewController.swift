//
//  ToAskViewController.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/21/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class ToAskViewController: UIViewController {

    let transition = SlideInTransition()
    var modelController = ModelController()
    let expertPicker = UIPickerView()
    
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var expertField: UITextField!
    
    var question: String = ""
    var expertNames = [String]()
    var expertIDs = [UInt]()
    var expertID: UInt = 0
    var expertName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuButton ()
        setPicker()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        modelController.experts.forEach { expert in
            expertNames.append(expert.name)
        }
        modelController.experts.forEach { expert in
            expertIDs.append(expert.id)
        }
        expertPicker.delegate = self
        expertPicker.dataSource = self
        title = "Ask a question below"
    }
    
    func setMenuButton () {
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "menu"), for:  [])
        menuButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: menuButton)
        self.navigationItem.leftBarButtonItem  = barButton
    }
    
    @objc func buttonTapped() {
    let storyBoard: UIStoryboard = UIStoryboard(name: "MenuStoryboard", bundle: nil)
    let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
    menuViewController?.didTapMenuType = { menuType in
        self.modelController.transitionToNew(menuType, self, self.modelController)
    }
    menuViewController?.modalPresentationStyle = .overCurrentContext
    menuViewController?.transitioningDelegate = self
    present(menuViewController ?? self, animated: true)
    }
    
    func setPicker() {
        let toolBar = UIToolbar()
         toolBar.barStyle = UIBarStyle.default
         toolBar.isTranslucent = true
         toolBar.sizeToFit()
         let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        expertField.inputView = expertPicker
        expertField.inputAccessoryView = toolBar
        expertField.addTarget(self, action: #selector(pickerBecameVisible), for: .touchDown)
    }
    
    @objc func donePicker() {
           view.endEditing(true)
    }
    
    @objc func pickerBecameVisible() {
        expertField.text = expertNames[0]
        expertID = expertIDs[0]
    }

    @IBAction func getAQuestion(_ sender: UITextField) {
        question = questionField.text ?? ""
    }
        
    @IBAction func sendAQuestion(_ sender: UIButton) {
        if question == "" {
             modelController.baseAlert("Ooops!", "No question has been founded.", self, "", .error)
        }
        else  {
            if expertID == 0 {
                modelController.baseAlert("Ooops!", "Expert field can not be empty.", self, "", .error)
            }
            else {
                print (question)
                let parameters = "question=\(self.question)&expert=\(self.expertID)"
                modelController.baseAlert("Are you sure you want to send your question?", question, self, parameters, .sendAQuestion)
                questionField.text = ""
                question = ""
            }
        }
    }
}

extension ToAskViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
}

extension ToAskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expertNames.count
       }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        expertField.text = expertNames[row]
        expertID = expertIDs[row]
        print (expertNames[row], expertIDs[row], expertID)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return expertNames[row]
    }
    
}

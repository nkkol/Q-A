//
//  NoAnsInfoViewController.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/18/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class NoAnsInfoViewController: UIViewController {
    
    var modelController = ModelController()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var expertLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    
    var currentQuestion = String()
    var currentExpert = String()
    var answer = ""
    var currentQuestionId = UInt()

    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = currentQuestion
        expertLabel.text = "Asked by: \(currentExpert)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        questionLabel.sizeToFit()
        expertLabel.sizeToFit()
        answerField.text = ""
        answer = ""
    }
    
  
    @IBAction func answerEdited(_ sender: UITextField) {
        answer = answerField.text ?? ""
    }
    
    @IBAction func sendAnAnswer(_ sender: UIButton) {
        if answer == "" {
            modelController.baseAlert("Ooops!", "No answer has been founded :(", self, "", .error)
        }
        else {
        modelController.baseAlert(currentQuestion, answer, self, "answer=\(answer)&id=\(String(currentQuestionId))", .sendAnAnswer)
        }
    }
    
}

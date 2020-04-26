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
    var answer = String()
    var currentQuestionId = UInt()
    
    var answerSent = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print (currentQuestion, currentExpert)
        questionLabel.text = currentQuestion
        expertLabel.text = "Asked by: \(currentExpert)"
    }
    override func viewWillAppear(_ animated: Bool) {
        answerSent = false
        questionLabel.sizeToFit()
        expertLabel.sizeToFit()
    }
    
  
    @IBAction func answerEdited(_ sender: UITextField) {
        answer = answerField.text ?? ""
    }
    
    @IBAction func sendAnAnswer(_ sender: UIButton) {
        answerField.text = ""
        if !answerSent {
            print("currentQuestionId ", currentQuestionId)
        modelController.baseAlert(currentQuestion, answer, self, "answer=\(answer)&id=\(String(currentQuestionId))", .sendAnAnswer)
        answer = ""
        answerSent = true
        }
        else {
            modelController.baseAlert("Sorry:(", "You can send only one answer per one question", self, "", .error)
        }
    }
}

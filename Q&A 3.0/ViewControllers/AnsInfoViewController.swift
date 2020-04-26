//
//  AnsInfoViewController.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/18/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class AnsInfoViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var expertLabel: UILabel!
    @IBOutlet weak var askingLabel: UILabel!

    var currentQuestion = ""
    var currentAnswer = ""
    var currentExpert = ""
    var currentAsking = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (currentQuestion, currentAnswer, currentExpert, currentAsking)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        questionLabel.text = currentQuestion
        answerLabel.text = currentAnswer
        expertLabel.text = "Asked by: \(currentExpert)"
        askingLabel.text = "Answered by: \(currentAsking)"
        questionLabel.sizeToFit()
        answerLabel.sizeToFit()
        expertLabel.sizeToFit()
        askingLabel.sizeToFit()
    }

}

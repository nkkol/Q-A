//
//  TableViewCell.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/18/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var questionData = Question(answer: "", asked_by_id: 0, asking_Name: "", expert_Name: "", expert_id: 0, id: 0, question: "")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonTapped(_ sender: Any) {
        print("Okaaaay")
        DBManager.share.saveQuestion(answer: questionData.answer ?? "", asked_by_id: Int(questionData.asked_by_id), asking_Name: questionData.asking_Name, expert_Name: questionData.expert_Name, expert_id: Int(questionData.expert_id), id: Int(questionData.id), question0: questionData.question)
    }
}

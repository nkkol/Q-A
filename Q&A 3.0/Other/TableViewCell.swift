//
//  TableViewCell.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/18/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit
import CoreData

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var isFav = false
    
    var questionData = Question(answer: "", asked_by_id: 0, asking_Name: "", expert_Name: "", expert_id: 0, id: 0, question: "")

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func buttonTapped(_ sender: Any) {
        isFav = !isFav
        if isFav {
        DBManager.share.saveQuestion(answer: questionData.answer ?? "", asked_by_id: Int(questionData.asked_by_id), asking_Name: questionData.asking_Name, expert_Name: questionData.expert_Name, expert_id: Int(questionData.expert_id), id: Int(questionData.id), question0: questionData.question)
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            DBManager.share.favQs?.forEach({ q in
                if q.id == questionData.id {
                    DBManager.share.delete(question: q)
                }
            })
     
        }
    }
}

//
//  FetchingData.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/22/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

class FetchingData {
    
    func fetchQuestions(_ json: Any, _ questions: [Question]) -> [Question] {
    var questions = [Question]()
    print (json)
    let object = json
        for anItem in object as! [Question] {
            let asked_by_id = anItem.asked_by_id
            let asking_Name = anItem.asking_Name
            let expert_Name = anItem.expert_Name
            let expert_id = anItem.expert_id
            let id = anItem.id
            let question = anItem.question
            let answer = anItem.answer ?? ""
            let answeredQuestion = Question(answer: answer, asked_by_id: asked_by_id, asking_Name: asking_Name, expert_Name: expert_Name, expert_id: expert_id, id: id, question: question)
             questions.append(answeredQuestion)
            }
    return questions
    }
    
    func fetchExperts(_ json: Any, _ experts: [Expert]) -> [Expert]{
    var experts = [Expert]()
    print (json)
    let object = json
        for anItem in object as! [Expert] {
            let id = anItem.id
            let name = anItem.name
            let expert = Expert(id: id, name: name)
            experts.append(expert)
            }
    return experts
    }
    
}

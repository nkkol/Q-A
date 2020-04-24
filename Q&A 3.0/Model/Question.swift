//
//  Question.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/18/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation

struct Question: Decodable {
    var answer: Optional<String>
    var asked_by_id: UInt
    var asking_Name: String
    var expert_Name: String
    var expert_id: UInt
    var id: UInt
    var question: String
}

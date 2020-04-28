//
//  DBManager.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/24/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import Foundation
import CoreData

class DBManager {
    
    var favQs: [FavouriteQuestion]? {
        get {
            return getData()
        }
    }
    
    func getData() -> [FavouriteQuestion]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteQuestion")
        
        do {
            return try manageContext?.fetch(request) as? [FavouriteQuestion]
        } catch {
            print("Error when getting data")
            return nil
        }
        
    }
    
    static var share = DBManager()
    let manageContext = appDelegate?.persistentContainer.viewContext
    
    func saveQuestion (answer: String, asked_by_id: Int, asking_Name: String, expert_Name: String, expert_id: Int, id: Int, question0: String) {
        
        guard let manageContext = manageContext else { return }
        let question = FavouriteQuestion(context: manageContext)
        question.answer = answer
        question.asked_by_id = Int64(asked_by_id)
        question.asking_Name = asking_Name
        question.expert_id = Int64(expert_id)
        question.id = Int64(id)
        question.question = question0
        question.expert_Name = expert_Name
        saveContext()
    }
    
    private func saveContext() {
        do {
            try manageContext?.save()
        } catch {
            print("Error when saving manageContext")
        }
    }
    
    func delete(question: FavouriteQuestion) {
        manageContext?.delete(question)
        saveContext()
    }
    
}

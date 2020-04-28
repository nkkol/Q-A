//
//  URLSession.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/22/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class UrlSession {
    
    let urlString = "https://sinspython.herokuapp.com"
    let decode = FetchingData()
    
    func getQuestions(_ modelController: ModelController, _ tableView: UITableView, _ haveAnAnsw: Bool) {
        let session = URLSession.shared
        let addString = haveAnAnsw ? "" : "NoAnswer"
        print (haveAnAnsw)
        if let url = URL(string: urlString + "/allQuestion" + addString)  {
        _ = session.dataTask(with: url, completionHandler: { data, response, error in
        do {
            let json = try JSONDecoder().decode([Question].self, from: data!)
            print(json)
            modelController.questions = self.decode.fetchQuestions(json, modelController.questions)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        catch {
            print("Error during JSON serialization: \(error.localizedDescription)")
        }
        }).resume()
        }
    }
    
    func getExperts(_ modelController: ModelController) {
        let session = URLSession.shared
        if let url = URL(string: urlString + "/allExpert")  {
            _ = session.dataTask(with: url, completionHandler: { data, response, error in
               do {
                   let json = try JSONDecoder().decode([Expert].self, from: data!)
                   modelController.experts = self.decode.fetchExperts(json, modelController.experts)
               }
               catch {
                   print("Error during JSON serialization: \(error.localizedDescription)")
               }
               }).resume()
               }
    }

    func deleteAQuestion (_ parameters: String) {
        guard let url = URL(string: urlString + "/question") else {return}
        baseRequest(url, "DELETE", parameters)
    }
    

    func sendAQuestion (_ parameters: String) {
        guard let url = URL(string: urlString + "/newQuestion") else {return}
        baseRequest(url, "POST", parameters)
    }

    func sendAnAnswer (_ parameters: String) {
        
        guard let url = URL(string: urlString + "/sendAnswer") else {return}
        baseRequest(url, "POST", parameters)
    }
    
    func baseRequest(_ url: URL, _ method: String, _ parameters: String) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters.data(using: String.Encoding.utf8);
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            guard let data = data else {return}
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: [])
            }
            catch {
                print (error)
            }
        }.resume()
    }
}


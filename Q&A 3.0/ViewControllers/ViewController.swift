//
//  ViewController.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/16/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let transition = SlideInTransition()
    var modelController = ModelController()
    
    @IBOutlet weak var menuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = modelController.haveAnAnsw ? "Answered questions" : "Non-answered questions"
        modelController.gettingData.getQuestions(modelController, self.tableView, modelController.haveAnAnsw)
        modelController.gettingData.getExperts(modelController)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.questions.count
       }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let question = modelController.questions[indexPath.row].question 
        cell.label.text = question
        return cell
           
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (indexPath.row)
        switch modelController.haveAnAnsw {
        case true:
            let storyBoard: UIStoryboard = UIStoryboard(name: "AnsInfoStoryboard", bundle: nil)
            //force unwrapping
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AnsInfoViewController") as! AnsInfoViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
            newViewController.currentQuestion = modelController.questions[indexPath.row].question
            newViewController.currentAnswer = modelController.questions[indexPath.row].answer ?? ""
            newViewController.currentExpert = modelController.questions[indexPath.row].expert_Name
            newViewController.currentAsking = modelController.questions[indexPath.row].asking_Name
        default:
            let storyBoard: UIStoryboard = UIStoryboard(name: "NoAnsInfoStoryboard", bundle: nil)
            //force unwrapping
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "NoAnsInfoViewController") as! NoAnsInfoViewController
            self.navigationController?.pushViewController(newViewController, animated: true)
            newViewController.currentQuestion = modelController.questions[indexPath.row].question
            newViewController.currentExpert = modelController.questions[indexPath.row].expert_Name
            newViewController.currentQuestionId = modelController.questions[indexPath.row].id

            newViewController.modelController = modelController
        }
    }

    @IBAction func menuButtonClicked(_ sender: UIButton) {
        print("Menu button was clicked")
        let storyBoard: UIStoryboard = UIStoryboard(name: "MenuStoryboard", bundle: nil)
        let menuViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
        menuViewController?.didTapMenuType = { menuType in
            self.modelController.transitionToNew(menuType, self, self.modelController)
            print (menuType)
            
        }
        menuViewController?.modalPresentationStyle = .overCurrentContext
        menuViewController?.transitioningDelegate = self
        present(menuViewController ?? self, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let delete = deleteAction(at: indexPath)
         return UISwipeActionsConfiguration(actions: [delete])
     }
    
     func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
         
         let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completion) in
     
             let alert = UIAlertController(title: "Are you sure you want to delete this question?", message: "\(self.modelController.questions[indexPath.row].question)", preferredStyle: .alert)

             alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.modelController.gettingData.deleteAQuestion("id=\(String(self.modelController.questions[indexPath.row].id))")
                 print("Question \(self.modelController.questions[indexPath.row].question) has just been deleted.")
                 self.modelController.questions.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                 
             }))
             
             alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
             
             self.present(alert, animated: true)

             completion(true)
         }
      return action
     }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
}

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
        if !modelController.isFav {
            self.title = modelController.haveAnAnsw ? "With answer" : "Without answer"
            modelController.gettingData.getQuestions(modelController, self.tableView, modelController.haveAnAnsw)
            modelController.gettingData.getExperts(modelController)
        }
        else {
            self.title = "Favourite"
            modelController.questions = []
            DBManager.share.favQs?.forEach({ q in
                
                let answer = q.answer
                let asked_by_id = q.asked_by_id
                let asking_Name = q.asking_Name
                let expert_Name = q.expert_Name
                let expert_id = q.expert_id
                let id = q.id
                let question = q.question
                
                modelController.questions.append(Question(answer: answer, asked_by_id: UInt(asked_by_id), asking_Name: asking_Name ?? "", expert_Name: expert_Name ?? "", expert_id: UInt(expert_id), id: UInt(id), question: question ?? ""))
            })

        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelController.questions.count
       }
       
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        DispatchQueue.main.async {
            cell.isFav = false
            DBManager.share.favQs?.forEach({ q in
                if q.id == cell.questionData.id {
                    cell.isFav = true
                }
            })
        cell.button.setImage(UIImage(systemName: cell.isFav ? "heart.fill" : "heart"), for: .normal)
        }
        cell.button.isHidden = modelController.isFav || !modelController.haveAnAnsw ? true : false
        cell.label.text = modelController.questions[indexPath.row].question
        cell.questionData = modelController.questions[indexPath.row]
        return cell
       }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print (indexPath.row)
        if modelController.haveAnAnsw {
                let storyBoard: UIStoryboard = UIStoryboard(name: "AnsInfoStoryboard", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "AnsInfoViewController") as? AnsInfoViewController
            self.navigationController?.pushViewController(newViewController ?? self, animated: true)
            newViewController?.currentQuestion = modelController.questions[indexPath.row].question
            newViewController?.currentAnswer = modelController.questions[indexPath.row].answer ?? ""
            newViewController?.currentExpert = modelController.questions[indexPath.row].expert_Name
            newViewController?.currentAsking = modelController.questions[indexPath.row].asking_Name
        }
        else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "NoAnsInfoStoryboard", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "NoAnsInfoViewController") as? NoAnsInfoViewController
            self.navigationController?.pushViewController(newViewController ?? self, animated: true)
            newViewController?.currentQuestion = modelController.questions[indexPath.row].question
            newViewController?.currentExpert = modelController.questions[indexPath.row].expert_Name
            newViewController?.currentQuestionId = modelController.questions[indexPath.row].id
            newViewController?.modelController = modelController
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         let delete = deleteAction(at: indexPath)
         return UISwipeActionsConfiguration(actions: [delete])
     }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
           let action = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completion) in
                let alert = UIAlertController(title: "Are you sure you want to delete this question?", message: "\(self.modelController.questions[indexPath.row].question)", preferredStyle: .alert)
               if self.modelController.isFav {
                   alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    if DBManager.share.favQs?[indexPath.row] != nil {
                        DBManager.share.delete(question: ((DBManager.share.favQs?[indexPath.row])!))
                    }
                   self.modelController.questions.remove(at: indexPath.row)
                   self.tableView.deleteRows(at: [indexPath], with: .automatic)
                       
                    }))
               }
               else {
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.modelController.gettingData.deleteAQuestion("id=\(String(self.modelController.questions[indexPath.row].id))")
                    self.modelController.questions.remove(at: indexPath.row)
                   self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }))
               }
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                self.present(alert, animated: true)
                completion(true)
            }
         return action
        }


    @IBAction func menuButtonClicked(_ sender: UIButton) {
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
    
    @IBAction func refreshControlAction(_ sender: Any) {
        self.modelController.gettingData.getQuestions(self.modelController, self.tableView, self.modelController.haveAnAnsw)
        self.refreshControl?.endRefreshing()
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

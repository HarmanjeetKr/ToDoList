//
//  AddTodoViewController.swift
//  ToDoList3Oct
//
//  Created by Harjinder on 2018-10-08.
//  Copyright © 2018 Harmanjeet. All rights reserved.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {
    
    // MARK: - Properties
    var manageContext: NSManagedObjectContext!
    var todo: Todo?
    
    // MARK: Outlets
    
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var donePress: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: .UIKeyboardWillShow,
            object: nil)
        myTextView.becomeFirstResponder()
        
        if let todo = todo{
            myTextView.text = todo.title
            myTextView.text = todo.title
            segment.selectedSegmentIndex = Int(todo.priority)
        }
    }
    
    //    MARK: Actions
    
    @IBAction func DonePressed(_ sender: UIButton) {
        guard let title = myTextView.text, !title.isEmpty else {
            return
        }
        
        if let todo = self.todo{
            todo.title = title
            todo.priority = Int16(segment.selectedSegmentIndex)
        } else {
            let todo = Todo(context: manageContext)
            todo.title = title
            todo.priority = Int16(segment.selectedSegmentIndex)
            todo.date = Date()
        }
        
        do{
            try manageContext.save()
            dismiss(animated: true)
            myTextView.resignFirstResponder()
        } catch{
            print("Error saving Todo \(error)")
        }
    }
    
    
    @IBAction func cancelPresses(_ sender: UIButton) {
        dismiss(animated: true)
        myTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(with notification: Notification){
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        bottomContraint.constant = keyboardHeight + 16
        
        UIView.animate(withDuration: 0.3){
            self.view.layoutIfNeeded()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddTodoViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if donePress.isHidden{
            myTextView.text.removeAll();
            myTextView.textColor = .blue;
            donePress.isHidden = false;
            
            UIView.animate(withDuration: 0.3, animations:{
                self.view.layoutIfNeeded()
            })
        }
   
    }
}

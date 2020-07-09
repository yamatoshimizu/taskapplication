//
//  InputViewController.swift
//  taskApp
//
//  Created by 清水大和 on 2020/07/08.
//  Copyright © 2020 Yamato Shimizu. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var ContentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    let realm = try! Realm()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        ContentsTextView.text = task.content
        datePicker.date = task.date
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.content = self.ContentsTextView.text
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: .modified)
        }
        super.viewWillDisappear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

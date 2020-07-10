//
//  InputViewController.swift
//  taskApp
//
//  Created by 清水大和 on 2020/07/08.
//  Copyright © 2020 Yamato Shimizu. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var ContentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categotyTextField: UITextField!
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
        categotyTextField.text = task.category
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.content = self.ContentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.categotyTextField.text!
            self.realm.add(self.task, update: .modified)
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
        
        
    }
        // タスクのローカル通知を登録する --- ここから ---
        func setNotification(task : Task){
            let content = UNMutableNotificationContent()
            // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示する)
            if task.title == ""{
                content.title = "(タイトルなし)"
            }
            else{
                content.title = task.title
            }
            if task.content == ""{
                content.body = "(内容なし)"
            }
            else{
                content.body = task.title
            }
            content.sound = UNNotificationSound.default
            // ローカル通知が発動するtrigger（日付マッチ）を作成
            let calendar = Calendar.current
            let timeComponent = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: task.date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponent, repeats: false)


            // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
            let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
            

            // ローカル通知を登録
          // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
            let center = UNUserNotificationCenter.current()
            center.add(request){(error)in
                print(error ?? "ローカル通知登録　OK")
            }
            

            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests{(requests: [UNNotificationRequest]) in
                for request in requests{
                    print("------------------------------------")
                    print(request)
                    print("------------------------------------")
                }
            }
         // --- ここまで追加 ---
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

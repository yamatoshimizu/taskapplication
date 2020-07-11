//
//  ViewController.swift
//  taskApp
//
//  Created by 清水大和 on 2020/07/08.
//  Copyright © 2020 Yamato Shimizu. All rights reserved.
//
import RealmSwift
import UIKit
import UserNotifications

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
//    Realmのインスタンスを取得、Taskのオブジェクトが日付順に入った配列taskArrayを作成
    var realm = try! Realm()
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        searchBar.placeholder = "カテゴリーを入力してください"
        print(type(of: taskArray))
    }
//    InputViewControllerにtaskのデータをタップしたセグエ毎に渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue"{
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task =  taskArray[indexPath!.row]
        }
        else{
            let task = Task()
            if taskArray.count != 0{
                task.id = taskArray.max(ofProperty: "id")! + 1
            }
            inputViewController.task = task
        }
    }
//    列の数をtaskの数に
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return taskArray.count
    }
//    セルの内容を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        再利用可能なセルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        選択された行のTaskをtaskとして取得
        let task = taskArray[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: task.date)

        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = dateString

        return cell
    }
//    セルが選択されたときに作動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
//    セルを削除可能に
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
//    セルが削除されるとき作動
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let task = taskArray[indexPath.row]
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)] )
            
            
            try! realm.write{
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            center.getPendingNotificationRequests{(requests: [UNNotificationRequest]) in
                for request in requests{
                    print("-------------------------")
                    print(request)
                    print("-------------------------")
                }
            }
        }
    }

//    searchBarのテキストが変更されたときに呼び出される
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        let predicate = NSPredicate(format: "category == %@",searchBar.text!)
        if searchBar.text != ""{
            taskArray = try! Realm().objects(Task.self).filter(predicate).sorted(byKeyPath: "date", ascending: true)
        }
        else{
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        }
        tableView.reloadData()
    }
//    viewが読み込まれる直前にデータをリロード
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
//
    
}


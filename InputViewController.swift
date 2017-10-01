//
//  InputViewController.swift
//  taskapp
//
//  Created by 張翔 on 2017/09/26.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var tableView: UITableView!
    
    var task: Task!
    let realm = try! Realm()
    
    var categoryArray = try! Realm().objects(Category.self).sorted(byKeyPath: "id", ascending: false)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        self.view.addGestureRecognizer(tapGesture)
        
        //初期設定
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date as Date
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func save(){
        if (titleTextField.text?.isEmpty)! || contentsTextView.text.isEmpty == true{
            let alert = UIAlertController(title: "入力してください", message: "タイトルまたは内容が入力されていません", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }else{
            //Realmに保存
            try! realm.write {
                self.task.title = self.titleTextField.text!
                self.task.contents = self.contentsTextView.text
                self.task.date = self.datePicker.date as NSDate
                for i in 1..<tableView.numberOfRows(inSection: 0){
                    if tableView.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType == .checkmark{
                        self.task.category = categoryArray[i - 1]
                    }
                }
                
                self.realm.add(self.task, update: true)
            }
        }
        setNotfication(task: task)
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func setNotfication(task: Task){
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.contents
        content.sound = UNNotificationSound.default()
        
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date as Date)
        let triger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: triger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録　OK")
            
        }
        
        //ログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests{
                print("/-------------------")
                print(request)
                print("-------------------/")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if indexPath.row == 0{
            cell.textLabel?.text = "新しいカテゴリーを作成"
            cell.accessoryType = .disclosureIndicator
        }else{
            cell.textLabel?.text = categoryArray[indexPath.row - 1].name
            if task.category == categoryArray[indexPath.row - 1]{
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "toNewCategory", sender: nil   )
        }else{
            for i in 1..<tableView.numberOfRows(inSection: 0){
                tableView.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType = .none
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            try! realm.write {
                self.realm.delete(categoryArray[indexPath.row - 1])
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newCategoryViewController: NewCategoryViewController = segue.destination as! NewCategoryViewController
        let category = Category()
        if categoryArray.count != 0{
            category.id = categoryArray.max(ofProperty: "id")! + 1
        }
        
        newCategoryViewController.category = category
        newCategoryViewController.task = task
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

//
//  NewCategoryViewController.swift
//  taskapp
//
//  Created by 張翔 on 2017/10/01.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit
import RealmSwift

class NewCategoryViewController: UIViewController {
    
    @IBOutlet var textFeild: UITextField!
    
    let realm = try! Realm()
    
    
    var category: Category!
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(){
        if textFeild.text?.isEmpty == true{
            let alert = UIAlertController(title: "入力してください", message: "カテゴリー名が入力されていません", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }else{
            try! realm.write {
                category.name = textFeild.text!
                realm.add(category, update: true)
                task.category = category
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismisKeyboard(){
        self.view.endEditing(true)
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

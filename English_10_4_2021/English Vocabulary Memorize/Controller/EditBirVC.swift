//
//  EditBirVC.swift
//  English Vocabulary Memorize
//
//  Created by Hasan BAL on 8.04.2021.
//

import UIKit
import CoreData

class EditBirVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var titleSecondLbl: UILabel!
    @IBOutlet weak var barMemoBtn: UIBarButtonItem!
    @IBOutlet weak var barTestBtn: UIBarButtonItem!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var list = [AnyObject]()
    var memorizedList = [AnyObject]()
    var degistirilecekVeri: NSManagedObject!
    var numberOfRow = 0
    var data: NSManagedObject?
    var indexOfRow : Int?
    var state = "Test"
    var testName: String?
    var testNameDB: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testName = "Bireysel Kelimeler"
        testNameDB = testNameCovert(_testName: testName!)
     
        self.tableView.delegate = self
        self.tableView.dataSource = self
        list = CoreDataUtility.sharedInstance.fetch(testNameDB: testNameDB!)
        numberOfRow = list.count
        state = "Test"
        
        barMemoBtn.isEnabled = true
        barTestBtn.isEnabled = false
        
        barTestBtn.title = testName
        titleLbl.text = testName!
        titleLabelUpdate()

        getTableData()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        getTableData()
        titleLabelUpdate()
    }
    func titleLabelUpdate(){
        titleSecondLbl.text = "Soru-Cevap (\(list.count))"
    }
    
    func getTableData(){
        list = CoreDataUtility.sharedInstance.fetch(testNameDB: testNameDB!)
        memorizedList = CoreDataUtility.sharedInstance.fetchMemo(testNameDB: testNameDB!)
        if state == "Test" {
            numberOfRow = list.count
        }else{
            numberOfRow = memorizedList.count
        }
       
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "editBirCell", for: indexPath) as! EditBirCell
        
        indexOfRow = indexPath.row
       
        if state == "Test" {
            data = (list[indexOfRow!] as! NSManagedObject)
        }else{
            data = memorizedList[indexOfRow!] as? NSManagedObject
        }
       
        cell.editQuestionLbl.text = (data!.value(forKey: "question") as? String)
        cell.editAnswerLbl.text = data!.value(forKey: "answer") as? String
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let  testNameDBMemo = self.testNameDB! + "Memorized"

        let deleteAction = UIContextualAction(style: .normal, title: ""){(action, sourceView, completionhandler) in
               
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
                if self.state == "Test" {

                    let entity = NSEntityDescription.entity(forEntityName: self.testNameDB!, in: managedContext)
                    managedContext.delete(self.list[indexPath.row] as! NSManagedObject)
                    self.list.remove(at: indexPath.row)
                }else{
                    let entity = NSEntityDescription.entity(forEntityName:testNameDBMemo , in: managedContext)
                    managedContext.delete(self.memorizedList[indexPath.row] as! NSManagedObject)
                    self.memorizedList.remove(at: indexPath.row)
                    
                }
          
            do {
                try managedContext.save()
              
            } catch  {
                print("something is going wrong!")
            }
       
            
            
                self.getTableData()
            
            }
    
             deleteAction.title = "Sil"
             deleteAction.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
       
    
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if state == "Test"  {

        let  updateData = list[tableView.indexPathForSelectedRow!.row] as! NSManagedObject
        
        let alert = UIAlertController(title: "Düzenle", message: "", preferredStyle: .alert)
            alert.addTextField{textfield in
            textfield.text = updateData.value(forKey: "question") as? String
            }
            alert.addTextField{textfield in
            textfield.text = updateData.value(forKey: "answer") as? String
            }
          
            let cancelBtn = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
       
            let saveBtn = UIAlertAction(title: "Kayıt", style: .default){ [self]_ in
               
                let correctedQuestion = alert.textFields![0].text
                let correctedAnswer = alert.textFields![1].text
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.persistentContainer.viewContext

                let instance = NSEntityDescription.insertNewObject(forEntityName: testNameDB!, into: managedContext)
                instance.setValue(correctedQuestion, forKey: "question")
                instance.setValue(correctedAnswer, forKey: "answer")

                
                managedContext.delete(self.list[indexPath.row] as! NSManagedObject)
                self.list.remove(at: indexPath.row)
                
                
                do {

                    try managedContext.save()
                   
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                self.list = CoreDataUtility.sharedInstance.fetch(testNameDB: self.testNameDB!)
                self.numberOfRow = self.list.count
                self.getTableData()
            }

        alert.addAction(saveBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true, completion: nil)
        
        }
        if state == "Memorized"   {
            
            
            let  sendData = memorizedList[tableView.indexPathForSelectedRow!.row] as! NSManagedObject
            
            let alert = UIAlertController(title: "Test Listesine Ekle", message: "", preferredStyle: .alert)

                let cancelBtn = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
           
                let saveBtn = UIAlertAction(title: "Ekle", style: .default){_ in
                   

                    let sendQuestion = sendData.value(forKey: "question")
                    let sendAnswer = sendData.value(forKey: "answer")
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let instance = NSEntityDescription.insertNewObject(forEntityName: self.testNameDB!, into: managedContext)
                    instance.setValue(sendQuestion, forKey: "question")
                    instance.setValue(sendAnswer, forKey: "answer")
                    

                    
                    managedContext.delete(self.memorizedList[indexPath.row] as! NSManagedObject)
                    self.memorizedList.remove(at: indexPath.row)
                    
                    
                    do {
//                        print("saved.")
                        try managedContext.save()
                       
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    self.memorizedList = CoreDataUtility.sharedInstance.fetchMemo(testNameDB: self.testNameDB!)
                    self.numberOfRow = self.memorizedList.count
                    self.titleSecondLbl.text = "Soru-Cevap (\(self.memorizedList.count))"
                    self.getTableData()
                }

            alert.addAction(saveBtn)
            alert.addAction(cancelBtn)
            present(alert, animated: true, completion: nil)
           
            }

    }
    
 
    
    @IBAction func barMemoBtnPressed(_ sender: Any) {
     
        barMemoBtn.isEnabled = false
        barTestBtn.isEnabled = true
   
        titleLbl.text = "Ezberlenmiş Kelimeler"
        titleSecondLbl.text = "Soru-Cevap (\(memorizedList.count))"
        
        numberOfRow = memorizedList.count

        state = "Memorized"

        getTableData()
    }
    
    @IBAction func barTestBtnPressed(_ sender: Any) {
        
        barMemoBtn.isEnabled = true
        barTestBtn.isEnabled = false
        
        titleLbl.text = testName
        titleLabelUpdate()
        numberOfRow = list.count

        state = "Test"
        getTableData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toAddVC" {
              
               let destination = segue.destination as! AddVC
               destination.testNameDB = testNameDB
               destination.testName = testName
           }
       }

}

 






//
//  MainVC.swift
//  English Vocabulary Memorize
//
//  Created by Hasan BAL on 31.03.2021.
//

import UIKit
import CoreData

class MainVC: UIViewController {

    @IBOutlet weak var testBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var engTrkBtn: UIButton!
    @IBOutlet weak var memorizedBtn: UIButton!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var cardBtn: UIButton!
    @IBOutlet weak var testLbl: UILabel!
    @IBOutlet weak var memorizedLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    var isQuestionOpen = true
    var question: String?
    var answer: String?
    var count = 0
    var qaList = [AnyObject]()
    var qaListMemo = [AnyObject]()
    var countNew = 0
    var questionModified: NSAttributedString?
    var answerModified: NSAttributedString?
    var menuList = [String]()
    var testNameDB: String?
    var testName: String?
    var segueID : String?
   
    
    static let  sharedinstance = MainVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.memorizedBtn.layer.cornerRadius = 10
        self.previousBtn.layer.cornerRadius = 10
        self.nextBtn.layer.cornerRadius = 10
        self.testBtn.layer.cornerRadius = 10
        self.cardBtn.imageView!.layer.cornerRadius = 40
        memorizedBtn.isHidden = true
        tableView.isHidden = true
        
        menuList = ["YDS Kelimeler 1","YDS Kelimeler 2","YDS Kelimeler 3","Bireysel Kelimeler"]
        tableView.delegate = self
        tableView.dataSource = self
        testName = "YDS Kelimeler 1"
        Singleton.sharedinstance.testName = testName!
        navigationItem.title = testName
       
    }
    
    override func viewDidAppear(_ animated: Bool) {

        initilazed()
    }
    
    
    func  getData(count: Int) {

      
        if qaList.count != 0{
            
          countNew = count % qaList.count
          countLbl.text = "\(countNew + 1)/\(qaList.count)"
            
            if engTrkBtn.currentTitle == " İngilizce -> Türkçe"{
                question = qaList[countNew].value(forKey: "question") as? String
                answer = qaList[countNew].value(forKey: "answer") as? String
                questionModified = convertToRed(sentence: question!)
            }else {
                question = qaList[countNew].value(forKey: "answer") as? String
                answer = qaList[countNew].value(forKey: "question") as? String
                answerModified = convertToRed(sentence: answer!)
            }
        } else{
           
            stop()
        }
 
    }
    
    func stop(){
        allBtnFalse()
        countLbl.text = "0/0"
        labelsUpdate()
       
        question = " "
        answer = " "
        questionLbl.text = ""
        answerLbl.text = ""
        cardBtn.setTitle("Listede soru yok!", for: .normal)
        let image = UIImage(named: "emptyBlue.png")
        self.cardBtn.setBackgroundImage(image, for: .normal)
        
       
    }
    func allBtnFalse(){
        cardBtn.isEnabled = false
        nextBtn.isEnabled = false
        previousBtn.isEnabled = false
        memorizedBtn.isEnabled = false
        testBtn.isEnabled = false
        engTrkBtn.isEnabled = false
    }
    func allBtnTrue(){
        cardBtn.isEnabled = true
        nextBtn.isEnabled = true
        previousBtn.isEnabled = true
        memorizedBtn.isEnabled = true
        testBtn.isEnabled = true
        engTrkBtn.isEnabled = true
    }
    
    func initilazed (){
        testNameDB = testNameCovert(_testName: testName!)
        qaList = CoreDataUtility.sharedInstance.fetch(testNameDB: testNameDB! )
//        print(qaList.count)
        if qaList.count == 0{
            stop()
        } else {
        allBtnTrue()
        labelsUpdate()
        getData(count: count)
        memorizedBtn.isHidden = true
        cardBtn.isEnabled = true
        cardBtn.setTitle("", for: .normal)
        
        if isQuestionOpen == false {
            UIView.transition(with: cardBtn, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: {(succes) in
               
                self.carBtnLabelsUpdate()
                
                self.answerLbl.text = ""
                let image = UIImage(named: "question.png")
                self.cardBtn.setBackgroundImage(image, for: .normal)
            })
            isQuestionOpen = true
        }

        let image = UIImage(named: "question.png")
        self.cardBtn.setBackgroundImage(image, for: .normal)
        
        self.carBtnLabelsUpdate()
        
        self.answerLbl.text = ""
        }
    }

    
    @IBAction func cardBtnPressed(_ sender: Any) {
    
        if isQuestionOpen{
         
            isQuestionOpen = false
            UIView.transition(with: cardBtn, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: {(succes) in
                
                self.carBtnLabelsUpdate()
                self.questionLbl.text = ""
              
            } )
        
            let image = UIImage(named: "answer.png")
             self.cardBtn.setBackgroundImage(image, for: .normal)
            
            UIView.transition(with: memorizedBtn, duration: 0.9,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.memorizedBtn.isHidden = false
                          })
         
            
        }else{
            count += 1
         
         
            getData(count: count)
            
                
            isQuestionOpen = true
            UIView.transition(with: cardBtn, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion:  { [self](succes) in
                
                self.carBtnLabelsUpdate()
                self.answerLbl.text = ""
               
              
            })
              
            let image = UIImage(named: "question.png")
            self.cardBtn.setBackgroundImage(image, for: .normal)
            memorizedBtn.isHidden = true
            
           
        }
        
      
    }


    
    func labelsUpdate(){
        qaList = CoreDataUtility.sharedInstance.fetch(testNameDB: testNameDB!)
        qaListMemo = CoreDataUtility.sharedInstance.fetchMemo(testNameDB: testNameDB!)
//        let numberOfTest = qaList.count
//        let numberOfMemorized = qaListMemo.count
//        let numberOfTotal = numberOfTest + numberOfMemorized
        
    }
    
    
    @IBAction func memorizedBtnPressed(_ sender: Any) {
       
            if engTrkBtn.currentTitle == " İngilizce -> Türkçe"{
                CoreDataUtility.sharedInstance.saveMemorized(input1: question!, input2: answer!, testnameDB: testNameDB!)
            }else{
                CoreDataUtility.sharedInstance.saveMemorized(input1: answer!, input2: question!, testnameDB: testNameDB!)
            }
            
            let testnameDBMemo = testNameDB! + "Memorized"
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: testnameDBMemo, in: managedContext)
            managedContext.delete(qaList[countNew] as! NSManagedObject)
            qaList.remove(at: countNew)
           
            do {
                try managedContext.save()
                labelsUpdate()
                initilazed()
                memorizedBtn.isHidden = true
            
            } catch  {
                print("something is going wrong!")
            }

    }
        
    
    @IBAction func previousBtnPressed(_ sender: Any) {
        count -= 1
        if count < 0{
            count = qaList.count + count
        }
        
        getData(count: count)
        isQuestionOpen = true
        
            UIView.transition(with: cardBtn, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: {(succes) in
               
                self.questionLbl.attributedText = self.questionModified
                self.answerLbl.text = ""
                
                let image = UIImage(named: "question.png")
                self.cardBtn.setBackgroundImage(image, for: .normal)
            })
        memorizedBtn.isHidden = true
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        count += 1
        
        getData(count: count)
        isQuestionOpen = true
        
            UIView.transition(with: cardBtn, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: {(succes) in
               
                self.questionLbl.attributedText = self.questionModified
                self.answerLbl.text = ""
                
                let image = UIImage(named: "question.png")
                self.cardBtn.setBackgroundImage(image, for: .normal)
            })
        memorizedBtn.isHidden = true
        }
    

       
    @IBAction func engTurkBtnPressed(_ sender: Any) {
        
        if engTrkBtn.currentTitle == " İngilizce -> Türkçe"{
            engTrkBtn.setTitle("Türkçe -> İngilizce", for: .normal)
         
        }else{
            engTrkBtn.setTitle(" İngilizce -> Türkçe", for: .normal)
           
        }
        count = 0
        initilazed()
    }
    
    func carBtnLabelsUpdate(){
        if  engTrkBtn.currentTitle == " İngilizce -> Türkçe"{
            questionLbl.attributedText = questionModified
            answerLbl.text = answer
        }else{
            questionLbl.text = question
            questionLbl.tintColor = UIColor.yellow
            answerLbl.attributedText = answerModified
            
        }
        
    }
    
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        
        if tableView.isHidden == false {
           tableView.isHidden = true
            tableView.reloadData()
           // navigationItem.title = "aaa"
           
        }else{
            tableView.isHidden = false
        }
    }
    
    
    @IBAction func editBtnPressed(_ sender: Any) {
        
                if testName == "Bireysel Kelimeler"{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let EditBirVC = storyboard.instantiateViewController(identifier: "EditBirVC")
                    show(EditBirVC, sender: self)
                  
                }else{
                    Singleton.sharedinstance.testName = testName!
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let EditYdsVC = storyboard.instantiateViewController(identifier: "EditYdsVC")
                    show(EditYdsVC, sender: self)
                    Singleton.sharedinstance.testName = testName!

                }
    }

}

extension MainVC : UITableViewDelegate, UITableViewDataSource {
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = menuList[indexPath.row]
        
        return cell
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   

    let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell

    testName = currentCell.textLabel!.text
    Singleton.sharedinstance.testName = testName!
    navigationItem.title = testName
    initilazed()
    tableView.isHidden = true
    }
    
 
    
}


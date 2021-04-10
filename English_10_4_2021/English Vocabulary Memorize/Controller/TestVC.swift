//
//  TestVC.swift
//  English Vocabulary Memorize
//
//  Created by Hasan BAL on 9.04.2021.
//

import UIKit
import CoreData

class TestVC: UIViewController {

    
    @IBOutlet weak var nextImageViev: UIImageView!
    @IBOutlet weak var scoreDenominatorLbl: UILabel!
    @IBOutlet weak var dBtnLbl: UILabel!
    @IBOutlet weak var cBtnLbl: UILabel!
    @IBOutlet weak var bBtnLbl: UILabel!
    @IBOutlet weak var aBtnLbl: UILabel!
    @IBOutlet weak var questionBtn: UIButton!
    @IBOutlet weak var aBtn: UIButton!
    @IBOutlet weak var bBtn: UIButton!
    @IBOutlet weak var cBtn: UIButton!
    @IBOutlet weak var dBtn: UIButton!
    @IBOutlet weak var englishTurkishBtn: UIButton!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var correctLbl: UILabel!
    @IBOutlet weak var wrongLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var scoreLblCount: UILabel!
    @IBOutlet weak var wrongLblCount: UILabel!
    @IBOutlet weak var correctLblCount: UILabel!
    @IBOutlet weak var aCheckImageView: UIImageView!
    @IBOutlet weak var bCheckImageView: UIImageView!
    @IBOutlet weak var cCheckImageView: UIImageView!
    @IBOutlet weak var dCheckImageView: UIImageView!
    @IBOutlet weak var engTrkBtn: UIButton!
    
    
    
    
    var state: String?
    var total = 1
    var correct = 0
    var wrong = 0
    var skip = 1
    var index: Int?
    var randomA : Int?
    var randomB : Int?
    var randomC : Int?
    var randomD : Int?
    var questionList = [String]()
    var answerList = [String]()
    var chooseList = [String]()
    var answerDumyList = [String]()
    var questionAskedList = [String]()
    var answerAskedList = [String]()
    var count = 0
    var list = [AnyObject]()
    var testNameDB: String?
    var testName: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionBtn.layer.cornerRadius = 10
        self.aBtn.layer.cornerRadius = 20
        self.bBtn.layer.cornerRadius = 20
        self.cBtn.layer.cornerRadius = 20
        self.dBtn.layer.cornerRadius = 20
        
        self.aCheckImageView.layer.cornerRadius = 10
        self.bCheckImageView.layer.cornerRadius = 10
        self.cCheckImageView.layer.cornerRadius = 10
        self.dCheckImageView.layer.cornerRadius = 10
        
        aCheckImageView.isHidden = true
        bCheckImageView.isHidden = true
        cCheckImageView.isHidden = true
        dCheckImageView.isHidden = true
      
        
        navigationItem.title = testName
        
        
        testName = Singleton.sharedinstance.testName
        testNameDB = testNameCovert(_testName: testName!)

        list = CoreDataUtility.sharedInstance.fetch(testNameDB: testNameDB!)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        initilazed()
    }
    func stop(){
          allBtnFalse()

          questionLbl.text = ""
          aBtnLbl.text = "A)"
          bBtnLbl.text = "B)"
          cBtnLbl.text = "C)"
          dBtnLbl.text = "D)"
          questionBtn.setTitle("Tebrikler! Test Bitti", for: .normal)
          scoreLblCount.text = "\(Int(correct * 100/total))"
          state = "End"
       
    }
    func allBtnFalse(){
        
        questionBtn.isEnabled = false
        aBtn.isEnabled = false
        bBtn.isEnabled = false
        cBtn.isEnabled = false
        dBtn.isEnabled = false
        
        scoreLbl.isHidden = false
        scoreLblCount.isHidden = false
        scoreDenominatorLbl.isHidden = false
        nextImageViev.isHidden = true
        
        aCheckImageView.isHidden = true
        bCheckImageView.isHidden = true
        cCheckImageView.isHidden = true
        dCheckImageView.isHidden = true
    }
    func allBtnTrue(){
        questionBtn.isEnabled = true
        aBtn.isEnabled = true
        bBtn.isEnabled = true
        cBtn.isEnabled = true
        dBtn.isEnabled = true
        
        scoreLbl.isHidden = true
        scoreLblCount.isHidden = true
        scoreDenominatorLbl.isHidden = true
        nextImageViev.isHidden = false

    }
    func initilazed (){

       state = "Continue"
        countLbl.text = "\(skip + wrong + correct)/\(total)"
        
        if testNameDB == "Bireysel" && list.count < 6{
            stop()
            questionBtn.setTitle("Kelime listesi en az 5\n soru-cevap içermelidir!!! ", for: .normal)
            scoreLblCount.text = ""
            scoreDenominatorLbl.text = ""
            scoreLbl.text = ""
        }else{
        
            if list.count == 0{
                stop()
            } else {
            allBtnTrue()
            labelsUpdate()
            getData(count: count)
            questionAnswerLabelsUpdate()
        
            }
        }
    }
    
    func  getData(count: Int) {

        if list.count != 0{
            
            if englishTurkishBtn.currentTitle == " İngilizce -> Türkçe"{
                for i in 0...list.count-1{
                    question = (list[i].value(forKey: "question") as! String)
                    answer = (list[i].value(forKey: "answer") as! String)
                    questionList.append(question!)
                    answerList.append(answer!)
                    answerDumyList.append(answer!)
                 
            }
               
            }else {

//                for i in 0...list.count-1{
//                    question = (list[i].value(forKey: "answer") as! String)
//                    answer = (list[i].value(forKey: "question") as! String)
//                    questionList.append(question!)
//                    answerList.append(answer!)
//                    answerDumyList.append(answer!)
//
//            }
               
            }
        } else{
           
            stop()
        }
        total = questionList.count
    }
    
    
    func labelsUpdate(){
        list = CoreDataUtility.sharedInstance.fetch(testNameDB: testNameDB!)

    }
    @IBAction func engTurkBtnPressed(_ sender: Any) {
        
//        if engTrkBtn.currentTitle == " İngilizce -> Türkçe"{
//            engTrkBtn.setTitle("Türkçe -> İngilizce", for: .normal)
//         
//        }else{
//            engTrkBtn.setTitle(" İngilizce -> Türkçe", for: .normal)
//           
//        }
//        count = 0
//        initilazed()
    }
    
    func questionAnswerLabelsUpdate(){
     
        if questionList.count != 0 {
          //  print(questionList.count)
            countLbl.text = "\(skip + wrong + correct)/\(total)"
            
            let randomQ = Int.random(in: 0..<questionList.count)
        
            question = convertToOneWord(sentence: questionList[randomQ])
            answer = answerList[randomQ]
        
            questionList.remove(at: randomQ)
            answerList.remove(at: randomQ)
        
        
            index = answerDumyList.firstIndex(of: answer!)
            answerDumyList.remove(at: index!)
       //     print(answerDumyList.count)

            randomA = Int.random(in: 0..<answerDumyList.count)
            let answerA = answerDumyList[randomA!]
        
            repeat{
                randomB = Int.random(in: 0..<answerDumyList.count)
            }while randomA == randomB
            let answerB = answerDumyList[randomB!]
        
            repeat{
                randomC = Int.random(in: 0..<answerDumyList.count)
            }while randomC == randomA || randomC == randomB
            let answerC = answerDumyList[randomC!]
        
            repeat{
                randomD = Int.random(in: 0..<answerDumyList.count)
            }while randomD == randomA || randomD == randomB || randomD == randomC
            let answerD = answerDumyList[randomD!]
       

            answerDumyList.insert(answer!, at:index! )
        
            chooseList = []
            chooseList.append(answerA)
            chooseList.append(answerB)
            chooseList.append(answerC)
            chooseList.append(answerD)

            let randomChoose = Int.random(in: 0..<4)

            chooseList.remove(at: randomChoose)
            chooseList.insert(answer!, at: randomChoose)
            
           
            aBtnLbl.text = ("A) \(chooseList[0])")
            bBtnLbl.text = ("B) \(chooseList[1])")
            cBtnLbl.text = ("C) \(chooseList[2])")
            dBtnLbl.text = ("D) \(chooseList[3])")
            questionLbl.text = question
        
    
      
        }else{
            stop()
        }
    }

    @IBAction func questionBtnPressed(_ sender: Any) {
    
        skip += 1
        questionAnswerLabelsUpdate()

    }
    
    @IBAction func aBtnPressed(_ sender: Any) {
        if state != "End"{
        if chooseList[0] == answer{
            correct += 1
            correctLblCount.text = String(correct)
            
            aCheckImageView.image = UIImage(named: "check")
            aCheckImageView.isHidden = false
            aBtn.isEnabled = false
        }else{
            wrong += 1
            wrongLblCount.text = String(wrong)
            
            aCheckImageView.image = UIImage(named: "cross")
            aCheckImageView.isHidden = false
            aBtn.isEnabled = false
        }
        
       
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.questionAnswerLabelsUpdate()
                self.aCheckImageView.isHidden = true
                self.aBtn.isEnabled = true
            }
        }
     
    }
    
    @IBAction func bBtnPressed(_ sender: Any) {
        if state != "End"{
        if chooseList[1] == answer{
            correct += 1
            correctLblCount.text = String(correct)
            bCheckImageView.isHidden = false
            
            bCheckImageView.image = UIImage(named: "check")
            bCheckImageView.isHidden = false
            bBtn.isEnabled = false
        }else{
            wrong += 1
            wrongLblCount.text = String(wrong)
            
            bCheckImageView.image = UIImage(named: "cross")
            bCheckImageView.isHidden = false
            bBtn.isEnabled = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.questionAnswerLabelsUpdate()
            self.bCheckImageView.isHidden = true
            self.bBtn.isEnabled = true
        }
        }
    }
    
    @IBAction func cBtnPressed(_ sender: Any) {
        if state != "End"{
        if chooseList[2] == answer{
            correct += 1
            correctLblCount.text = String(correct)
            cCheckImageView.isHidden = false
            
            cCheckImageView.image = UIImage(named: "check")
            cCheckImageView.isHidden = false
            cBtn.isEnabled = false
        }else{
            wrong += 1
            wrongLblCount.text = String(wrong)
            
            cCheckImageView.image = UIImage(named: "cross")
            cCheckImageView.isHidden = false
            cBtn.isEnabled = false
        }
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.questionAnswerLabelsUpdate()
            self.cCheckImageView.isHidden = true
            self.cBtn.isEnabled = true
        }
        }
    }
    
    @IBAction func dBtnPressed(_ sender: Any) {
        if state != "End"{
        if chooseList[3] == answer{
            correct += 1
            correctLblCount.text = String(correct)
            dCheckImageView.isHidden = false
            
            dCheckImageView.image = UIImage(named: "check")
            dCheckImageView.isHidden = false
            dBtn.isEnabled = false
        }else{
            wrong += 1
            wrongLblCount.text = String(wrong)
            
            dCheckImageView.image = UIImage(named: "cross")
            dCheckImageView.isHidden = false
            dBtn.isEnabled = false
        }
 
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.questionAnswerLabelsUpdate()
            self.dCheckImageView.isHidden = true
            self.dBtn.isEnabled = true
        }
        }
    }

    
}




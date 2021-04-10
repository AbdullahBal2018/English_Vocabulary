//
//  AddVC.swift
//  English Vocabulary Memorize
//
//  Created by Hasan BAL on 31.03.2021.
//

import UIKit
import CoreData

class AddVC: UIViewController {

    @IBOutlet weak var testNameLbl: UILabel!
    @IBOutlet weak var questionTxt: UITextField!
    @IBOutlet weak var answerTxt: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    

    var testNameDB : String?
    var testName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn.layer.cornerRadius = 5
        testNameLbl.text = testName
        
    }
    


    @IBAction func addBtnPressed(_ sender: Any) {
        if questionTxt.text != "" && answerTxt.text != ""{
        guard let question = questionTxt.text else {return}
        guard let answer = answerTxt.text else {return}
            CoreDataUtility.sharedInstance.save(input1: question, input2: answer, testnameDB: testNameDB!)
            questionTxt.text = ""
            answerTxt.text = ""
      
        }
    }
    

}

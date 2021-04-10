//
//  Utilities.swift
//  English Vocabulary Memorize
//
//  Created by Hasan BAL on 4.04.2021.
//

import UIKit

func convertToRed(sentence: String) -> NSMutableAttributedString{
    
    var partRed: NSAttributedString?
    var partBlack: NSAttributedString?
    let combination = NSMutableAttributedString()
    let word = sentence.components(separatedBy: " ")
    let uppercaseLetters = CharacterSet.uppercaseLetters
    let redColorMade = [NSAttributedString.Key.foregroundColor: UIColor(red: 242/255, green: 194/255, blue: 4/255, alpha: 1)]
    let blackColorMade = [NSAttributedString.Key.foregroundColor: UIColor.black]
    
    for i in 0...word.count-1{
        if (word[i].rangeOfCharacter(from: uppercaseLetters) != nil) && (word[i].count > 1){
            var countChar = 0
            for char in word[i]{
                if char.isUppercase{
                    countChar+=1
                }
            }
            if countChar > 1{
            partRed = NSMutableAttributedString(string: word[i].lowercased() + " ", attributes: redColorMade)
            combination.append(partRed!)
            }else {
                partBlack = NSMutableAttributedString(string: word[i] + " ", attributes: blackColorMade)
                    combination.append(partBlack!)
            }
        }else{
        partBlack = NSMutableAttributedString(string: word[i] + " ", attributes: blackColorMade)
            
            combination.append(partBlack!)
        }
    }
    return combination
}


func testNameCovert (_testName: String) -> (String) {
    var testNameDB: String?
    switch _testName {
    case "YDS Kelimeler 1":
        testNameDB = "YDS1"
    case "YDS Kelimeler 2":
       testNameDB = "YDS2"
    case "YDS Kelimeler 3":
        testNameDB = "YDS3"
    case "Bireysel Kelimeler":
       testNameDB = "Bireysel"
    default:
         testNameDB = ""
    }
    return testNameDB!
}

func convertToOneWord(sentence: String) -> String{
    var questionConverted: String?
    let word = sentence.components(separatedBy: " ")
    let uppercaseLetters = CharacterSet.uppercaseLetters

    
    for i in 0...word.count-1{
        if (word[i].rangeOfCharacter(from: uppercaseLetters) != nil) && (word[i].count > 1){
            var countChar = 0
            for char in word[i]{
                if char.isUppercase{
                    countChar+=1
                }
            }
            if countChar > 1{
            questionConverted = word[i].lowercased()
            }
        }
    }
    
    if questionConverted == nil {
        questionConverted = sentence
    }
    return questionConverted!
}


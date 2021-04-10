//
//  FromExcel.swift
//  English Vocabulary Memorize
//
//  Created by Hasan BAL on 9.04.2021.
//

import Foundation

    var list = [String]()
    var question: String?
    var answer: String?
    var counter = 0

func dataFromExcelToCoredata(testName: String){

        let path = Bundle.main.path(forResource: "EnglishWords30", ofType: "plist")
        var arr : NSArray?
        arr = NSArray(contentsOfFile: path!)
        let arr2 = arr as? Array<[String]>
        for column in arr2!{

            for row in column{
                list.append(row)

            }
        }


    for i in 40...list.count-1{

        if i%2 == 0{
            question = list[i]
        }else{
            answer = list[i]
            if question != nil && answer != nil{

               counter += 1
                question = ""
                answer = ""

             }
        }
    }
    
}


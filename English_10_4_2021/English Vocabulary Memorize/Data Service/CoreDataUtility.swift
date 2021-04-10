//
//  CoreDataUtility.swift
//  English Vocabulary Memorize
//
//  Created by Hasan BAL on 2.04.2021.
//


import UIKit
import CoreData

class CoreDataUtility {
    static let  sharedInstance = CoreDataUtility()
    
   
    func save(input1:String, input2: String, testnameDB: String){
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: testnameDB, in: managedContext)!
            let instance = NSManagedObject(entity: entity, insertInto: managedContext)
            
            instance.setValue(input1, forKey: "question")
            instance.setValue(input2, forKey: "answer")
        
            
            do {
//                print("saved.")
                try managedContext.save()
               
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    func saveMemorized(input1:String, input2: String, testnameDB: String){
        
        let testnameDBMemo = testnameDB + "Memorized"
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let instance = NSEntityDescription.insertNewObject(forEntityName: testnameDBMemo, into: managedContext)
        instance.setValue(input1, forKey: "question")
        instance.setValue(input2, forKey: "answer")
        
        
        
        do {
//            print("saved.")
            try managedContext.save()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func fetch(testNameDB: String) -> [NSManagedObject] {
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: testNameDB)
        
      //  var fetchedData = [YDS3]()
        var fetchData: [NSManagedObject] = []
        do {
        
            fetchData = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print(error)
        }
        
        return fetchData
    }
    
    func fetchMemo(testNameDB: String) -> [NSManagedObject] {
      
        let testnameDBMemo = testNameDB + "Memorized"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: testnameDBMemo)
        
        var fetchData: [NSManagedObject] = []
        
        do {
         
            fetchData = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
            print(error)
        }
        
        return fetchData
    }

     
    
    
    func deleteAll(list: [AnyObject]){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
    
        
        for i in 0...(list.count-1){
            
            managedContext.delete(list[i] as! NSManagedObject)
     
            
        }
            do {
                try managedContext.save()
            } catch  {
                print("something is going wrong!")
            }
        }
    
        
}
    
    



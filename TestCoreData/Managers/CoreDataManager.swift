//
//  CoreDataManager.swift
//  TestCoreData
//
//  Created by Maksym Vitovych on 06.09.2021.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveTask(title: String) {
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error save context: \(error.localizedDescription)")
        }
    }
    
    func getTasks() -> [Task]? {
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Error fetch context: \(error.localizedDescription)")
            return nil
        }
    }
}

//
//  LocalDataModel.swift
//  Walmart_assignment
//
//  Created by Vivek Tusiyad on 08/08/24.
//

import Foundation
import CoreData
import UIKit

class LocalDataModel: NSObject {
    
    // Reference to the managed object context
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    class var shared: LocalDataModel {
        struct singleton {
            static let instance = LocalDataModel()
        }
        return singleton.instance
    }
    
    //MARK: - Insert Image Data
    func insertUpdateImageDetailsToDB(imageDict : NSDictionary,base64imageData: String) {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ImageDataEntity")
        do
        {
            let imageData = try managedContext.fetch(fetchRequest)
            if imageData.count > 0 {
                let objectUpdate = imageData[0] as! NSManagedObject
                
                objectUpdate.setValue(true, forKey: "isVisited")
                
                do {
                    try managedContext.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }else {
                //Now let’s create an entity and new image records.
                let imageEntity = NSEntityDescription.entity(forEntityName: "ImageDataEntity", in: managedContext)!
                //final, we need to add some data to our newly created record for each keys using
                let imageData = NSManagedObject(entity: imageEntity, insertInto: managedContext)
                imageData.setValue(false, forKey: "isVisited")
                imageData.setValue(((imageDict["date"] as? String) ?? ""), forKey: "date")
                imageData.setValue(((imageDict["title"] as? String) ?? ""), forKey: "title")
                imageData.setValue(((imageDict["explanation"] as? String) ?? ""), forKey: "explanation")
                imageData.setValue(base64imageData, forKey: "imageData")
                
                do {
                    try managedContext.save()
                    
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }

    
    func fetchImageDetailsFromDB() -> ImageDataEntity? {

        let fetchRequest: NSFetchRequest<ImageDataEntity> = ImageDataEntity.fetchRequest()

        do {
            let result = try managedContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("Failed")
            return nil
        }
    }
    
}

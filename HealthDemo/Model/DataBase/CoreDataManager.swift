//
//  CoreDataManager.swift
//  HealthDemo
//
//  Created by Misha Dovhiy on 08.12.2023.
//

import UIKit
import CoreData

struct GeneralEntityStruct {
    let db:Data
    static func create(db:GeneralEntity) -> GeneralEntityStruct {
        return .init(db: db.data ?? .init())
    }
}


struct CoreDataDBManager {
    enum Entities:String {
        case general = "GeneralEntity"
    }
    
    private let persistentContainer:NSPersistentContainer
    private let context:NSManagedObjectContext
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as? AppDelegate ?? .init()
    }
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.context = persistentContainer.viewContext
    }
    
    static var dataHolder:GeneralEntityStruct?
    
    func fetch(_ entitie:Entities) -> GeneralEntity? {
        let results = self.fetchRecordsForEntity(entitie, inManagedObjectContext: context)
        if let transactions = (results.filter({
            return $0 is GeneralEntity
        }) as? [GeneralEntity])?.first {
            return transactions
        } else {
            return nil
        }
        
    }
    

    func update(_ new:GeneralEntityStruct) {
        if let old = fetch(.general) {
            old.data = new.db
            DispatchQueue.main.async {
                self.appDelegate.saveContext()
            }
        } else {
            let _: GeneralEntity = .create(entity: context, transaction: new)
            DispatchQueue.main.async {
                self.appDelegate.saveContext()
            }
        }
    }
    
    private func fetchRecordsForEntity(_ entity:Entities, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)

        var result = [NSManagedObject]()

        do {
            let records = try managedObjectContext.fetch(fetchRequest)

            if let records = records as? [NSManagedObject] {
                result = records
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity.rawValue).")
        }

        return result
    }
    
    
}

extension GeneralEntity {
    static func create(entity:NSManagedObjectContext, transaction:GeneralEntityStruct) -> GeneralEntity {
        let new = GeneralEntity(context: entity)
        new.data = transaction.db
        return new
    }
        
}


extension Data {
    @available(iOS 11.0, *)
    static func create(from dict:[String:Any]) -> Data? {
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: false) {
            return data

        } else {
            return nil
        }
    }
    var toDict:[String:Any]? {
        if let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self) as? [String: Any] {
                return dictionary
            } else {
                return nil
            }
    }
}

//
//  MarvelListDataStorage.swift
//  MarvelList
//
//  Created by MacDev on 10/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import CoreData
import UIKit

class MarvelListDataStorage {
    
   //MARK: - Properties
    var context: NSManagedObjectContext? = {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    let userDefaults: UserDefaults = {
        return UserDefaults.standard
    }()

    //MARK: - Functions
    func save(heroes: [HomeModels.HomeViewModel.Hero], hasMore: Bool) {
        guard let managedContext = context else {
            return
        }
        let savedHeroes = self.retreiveHeroes() ?? []
        let newHeroes = heroes.filter {
            let dict = $0
            return !savedHeroes.contains { dict.id == $0.id }
        }
        for hero in newHeroes {
            let newHero = NSEntityDescription.insertNewObject(forEntityName: "Hero", into: managedContext)
            newHero.setValue(hero.id, forKey: "id")
            newHero.setValue(hero.name, forKey: "name")
            newHero.setValue(hero.thumbUrl, forKey: "thumb")
            newHero.setValue(hero.image?.pngData(), forKey: "image")
            newHero.setValue(hero.description, forKey: "desc")
        }
        
        do {
            try context?.save()
            self.userDefaults.set(hasMore, forKey: "hasMore")
        } catch {
            print("Error saving: \(error)")
        }
    }
    
   
    func retreiveHeroes() -> [HomeModels.HomeViewModel.Hero]? {
        guard let managedContext = context else {
            return nil
        }
         let fetchRequest =
           NSFetchRequest<NSManagedObject>(entityName: "Hero")
        
        do {
           let databaseList = try managedContext.fetch(fetchRequest)
            let heroesList = databaseList.map {
                return HomeModels.HomeViewModel.Hero(id: $0.value(forKeyPath: "id") as? String ?? "",
                                                     name: $0.value(forKeyPath: "name") as? String ?? "",
                description: $0.value(forKeyPath: "desc") as? String ?? "",
                thumbUrl: $0.value(forKeyPath: "thumb") as? String ?? "",
                image: UIImage(data: $0.value(forKeyPath: "image") as? Data ?? Data()) ?? nil)
            }
            return heroesList.sorted { $0.name.lowercased() < $1.name.lowercased()}
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
         }
        return nil
    }
    
    func hasMore() -> Bool {
        userDefaults.bool(forKey: "hasMore")
    }

}

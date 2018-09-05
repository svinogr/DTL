//
//  QDao.swift
//  14
//
//  Created by sergey on 09.07.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import Foundation
import SQLite

class QDao {
    var database: Connection?
    let id = Expression<Int>("_id")
    let body = Expression<String>("body")
    let table = Table("Question")
    let img = Expression<String>("img")
    let fav = Expression<Int>("fav")
    
    let tableAnswer = Table("Answer")
    let right = Expression<Int>("right")
    
    var baseName : String?
    
 
    func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        //let finalDatabaseURL = documentsUrl.appendingPathComponent("questionnaire.db")
        let finalDatabaseURL = documentsUrl.appendingPathComponent(baseName! + ".db")
        do {
            if !fileManager.fileExists(atPath: finalDatabaseURL.path) {
                // print("DB does not exist in documents folder")
                
               // if let dbFilePath = Bundle.main.path(forResource: "questionnaire", ofType: "db") {
                
                if let dbFilePath = Bundle.main.path(forResource: baseName!, ofType: "db") {

                try fileManager.copyItem(atPath: dbFilePath, toPath: finalDatabaseURL.path)
                } else {
                    //  print("Uh oh - foo.db is not in the app bundle")
                }
            } else {
                //  print("Database file found at path: \(finalDatabaseURL.path)")
            }
        } catch {
            //print("Unable to copy foo.db: \(error)")
        }
    }
    
    
    
    
    init(baseName: String) {
        
            self.baseName = baseName
     
        do {
            copyDatabaseIfNeeded()
            
            
            //  let url = Bundle.main.path(forResource: "questionnaire", ofType: "db")
            //   let fileManager = FileManager.default
            
            //      guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            //  let url = documentsUrl.appendingPathComponent("questionnaire.db")
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
           // self.database = try Connection("\(path)/questionnaire.db")
            self.database = try Connection("\(path)/\(String(describing: baseName)).db")

            
        } catch {
            print("pipec")
        }
    }
    
    func getFav() -> [Quest]{
        var questList: [Quest] = []
        do {
            let listFav = table.filter(fav == 1)
            let list = try database?.prepare(listFav)
            for l in list! {
                let quest = Quest()
                quest.body = l[body]
                if (l[img].elementsEqual("имя картинки") || l[img].isEmpty){
                    quest.img = l[img]
                    
                }else {
                    quest.img = baseName! + "_" + l[img]
                }
                questList.append(quest)
                quest.id = l[self.id]
            }
            
            //посмотреть гдк будет быстрее
            let aDao = ADao(baseName: baseName!)
            for questTDO in questList {
                let listAnswer = aDao.getAnswerById(id_question: questTDO.id!)
                questTDO.answers = listAnswer
                //  print("q: \(questTDO.id) size: \(questTDO.listAnswers.count)  a : \(String(describing: listAnswer[0].body))")
            }
            
            
        } catch {
            print(error)
        }
        return questList
    }
    
    func setFav(idSet: Int) -> Bool {
        let favSet = table.filter(self.id == idSet)
        
        do{
            let updated = try  database?.run(favSet.update(self.fav <- 1))
            if updated! > 0 {
                try database?.prepare(favSet)
                
                
                return true
                
            }
        } catch {
            print(error)
            
            return false
        }
        return false
    }
    
    func deletFav(idSet: Int) -> Bool {
        let favSet = table.filter(id == idSet)
        
        do{
            let updated = try  database?.run(favSet.update(self.fav <- 0))
            if updated! > 0 {
                return true
                
            }
        } catch {
            print(error)
            return false
        }
        return false
    }
    
    func getAllQuest() -> [Quest] {
        var questList: [Quest] = []
        do {
            let list = try database?.prepare(self.table)
            for l in list! {
                
                let quest = Quest()
                quest.body = l[body]
                if (l[img].elementsEqual("имя картинки") || l[img].isEmpty){
                    quest.img = l[img]
                    
                }else {
                      quest.img = baseName! + "_" + l[img]
                }
                
                questList.append(quest)
                quest.id = l[self.id]
            }
            
            //посмотреть гдк будет быстрее
            let aDao = ADao(baseName: baseName!)
            for questTDO in questList {
                let listAnswer = aDao.getAnswerById(id_question: questTDO.id!)
                questTDO.answers = listAnswer
                //  print("q: \(questTDO.id) size: \(questTDO.listAnswers.count)  a : \(String(describing: listAnswer[0].body))")
            }
            
            
        } catch {
            print(error)
        }
        return questList
        
    }
}

//
//  ADao.swift
//  14
//
//  Created by sergey on 10.07.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import Foundation
import SQLite

class ADao {
    var database: Connection?
    
    let id = Expression<Int>("_id")
    let body = Expression<String>("body")
    let id_question = Expression<Int>("id_question")
    let tableAnswer = Table("Answer")
    let right = Expression<Int>("right")
    var baseName : String
    
    init(baseName: String) {
        self.baseName = baseName
        do {
            let url = Bundle.main.path(forResource: baseName, ofType: "db")
            self.database = try Connection(url!)
        } catch {
        }
    }
    
    func getAnswerById(id_question: Int) -> [Answer] {
        
        var answerList = [Answer]()
        do {
            let answers = try database?.prepare(self.tableAnswer.where(self.id_question == id_question))
            
            for answerTDO in answers! {
                
                let answer = Answer()
                answer.body = answerTDO[self.body]
                answer.right = answerTDO[self.right] == 1 ? true : false
                answer.id_quest = answerTDO[self.id_question]
                answer.id = answerTDO[self.id]
                
                answerList.append((answer))
            }
            
        } catch {
        }
        return answerList
        
    }
}

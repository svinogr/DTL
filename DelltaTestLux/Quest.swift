//
//  Quest.swift
//  14
//
//  Created by sergey on 09.07.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import Foundation
class Quest: Equatable {
    static func == (lhs: Quest, rhs: Quest) -> Bool {
        return lhs.id != rhs.id
    }
    
    var id: Int?
    var category: String?
    var body : String?
    var img : String?
    var answers : [Answer]?
    var number : String?
}


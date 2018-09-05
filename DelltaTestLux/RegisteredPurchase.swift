//
//  RegisteredPurchase.swift
//  DelltaTestLux
//
//  Created by sergey on 20.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import Foundation
class RegisteredPurchase {
    
    var id : Int?
    var name : String?
    var endNameApp : String?
    var description : String?
    var cost : String?
    var isPurchased : Bool = false
    
    init(endNameApp: String) {
        self.endNameApp = endNameApp
    }
    
}

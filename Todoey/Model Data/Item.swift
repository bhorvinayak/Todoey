//
//  Item.swift
//  Todoey
//
//  Created by Vinayak Bhor on 23/06/19.
//  Copyright © 2019 Vinayak Bhor. All rights reserved.
//

import Foundation

class Item : Encodable,Decodable{
    
    var title : String = ""
    var done : Bool = false
}

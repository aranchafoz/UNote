//
//  Appdata.swift
//  UNote
//
//  Created by Paul Yeung on 21/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit



class Appdata {
    
    var awsEditor:UserTableEditor? = nil
    
    var myUserID = ""
    var mySubsList:NSMutableArray = []
    
    class var sharedInstance : Appdata {
        struct Static {
            static let instance : Appdata = Appdata()
        }
        return Static.instance
    }
    
}

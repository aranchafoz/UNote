//
//  TakenPhoto+CoreDataProperties.swift
//  
//
//  Created by SUNGKAHO on 22/10/2016.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension TakenPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TakenPhoto> {
        return NSFetchRequest<TakenPhoto>(entityName: "TakenPhoto");
    }

    @NSManaged public var courseName: String?
    @NSManaged public var noteImage: NSData?
    @NSManaged public var noteTitle: String?

}

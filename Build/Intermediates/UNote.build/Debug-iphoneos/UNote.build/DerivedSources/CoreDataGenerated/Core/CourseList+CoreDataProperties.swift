//
//  CourseList+CoreDataProperties.swift
//  
//
//  Created by SUNGKAHO on 24/10/2016.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CourseList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CourseList> {
        return NSFetchRequest<CourseList>(entityName: "CourseList");
    }

    @NSManaged public var courseTitle: String?

}

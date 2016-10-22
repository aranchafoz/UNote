//
//  myPaulPaulsLovelyConstants.swift
//  UNote
//
//  Created by Paul Yeung on 22/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class c {
    static public let SAVED_USER_ID = "SAVED_USER_ID"
    
    /* DELEGATE RETURN ITEMS TYPES */
    static public let TYPE_ACCOUNT = "TYPE_ACCOUNT"
    static public let TYPE_USER_INFO = "TYPE_USER_INFO"
    static public let TYPE_USER_FILE = "TYPE_USER_FILE"
    static public let TYPE_USER_SUBS = "TYPE_USER_SUBS"
    static public let TYPE_FILE = "TYPE_FILE"
    
    /* DELEGATE RETURN DICTIONARYS TAGS */
    static public let TAG_USER_ID = "TAG_USER_ID"
    static public let TAG_CUSTOM_ID = "TAG_CUSTOM_ID"
    static public let TAG_USER_NAME = "TAG_USER_NAME"
    static public let TAG_USER_COURSE_LIST = "TAG_USER_COURSE_LIST"
    static public let TAG_JOIN_TIMESTAMP = "TAG_JOIN_TIMESTAMP"
    static public let TAG_JOIN_YR = "TAG_JOIN_YR"
    static public let TAG_SELF_INTRO = "TAG_SELF_INTRO"
    static public let TAG_FILE_LIST = "TAG_FILE_LIST"
    static public let TAG_SUBS_LIST = "TAG_SUBS_LIST"
    static public let TAG_FILE_ID = "TAG_FILE_ID"
    static public let TAG_FILE_NAME = "TAG_FILE_NAME"
    static public let TAG_FILE_COURSE = "TAG_FILE_COURSE"
    static public let TAG_FILE_LINK = "TAG_FILE_LINK"
    static public let TAG_FILE_TIMESTAMP = "TAG_FILE_TIMESTAMP"
    
    /* RETURN DICTIONARYS STRUCTRUES */
    //
    // Custom ID
    //      TAG_CUSTOM_ID:          String
    //      TAG_USER_ID:            String
    //
    // User Info
    //      TAG_USER_ID:            String
    //      TAG_USER_NAME:          String
    //      TAG_USER_COURSE_LIST:   Set<String>
    //      TAG_JOIN_TIMESTAMP:     NSNumber
    //      TAG_JOIN_YR:            NSNumber
    //      TAG_SELF_INTRO:         String
    //
    // User File List
    //      TAG_USER_ID:            String
    //      TAG_FILE_LIST:          Set<String>
    //
    // User Subscribled List
    //      TAG_USER_ID:            String
    //      TAG_SUBS_LIST:          Set<String>
    //
    // Files
    //      TAG_FILE_ID:            String
    //      TAG_USER_ID:            String
    //      TAG_FILE_NAME:          String
    //      TAG_FILE_COURSE:        String
    //      TAG_FILE_LINK:          String
    //      TAG_FILE_TIMESTAMP:     NSNumber
}

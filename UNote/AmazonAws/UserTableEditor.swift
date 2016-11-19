//
//  UserTableEditor.swift
//  UNote_Social
//
//  Created by Paul Yeung on 2/10/2016.
//  Copyright © 2016 Paul. All rights reserved.
//

import Foundation
import AWSMobileHubHelper
import AWSDynamoDB

protocol UserLoginProtocol {
    func didLoginSucceed(_ email:String)
    func didLoginFailed()
}

protocol UserTableEditorCallBackProtocol {
    
    func didSetItemWith(_ state:Bool, itemType:String)
    func didGetItemSucceedWithItem(_ itemType:String, item:NSDictionary?)
    func didGetItemFailedWithError(_ itemType:String, error:String)
}

protocol UserUploadDownloadCallBackProtocol {
    func didUploadFileSucceedWith(_ fileid:String)
    func didUploadFileFailedWith(_ fileid:String, error:String)
    
    func didDownloadFileSucceedWith(_ fileid:String, data:NSData)
    func didDownloadFileFailedWith(_ fileid:String, error:String)
}

class UserTableEditor {
    
    /* DELEGATE RETURN ITEMS TYPES */
    let TYPE_ACCOUNT = "TYPE_ACCOUNT"
    let TYPE_USER_INFO = "TYPE_USER_INFO"
    let TYPE_USER_FILE = "TYPE_USER_FILE"
    let TYPE_USER_SUBS = "TYPE_USER_SUBS"
    let TYPE_FILE = "TYPE_FILE"
    
    /* DELEGATE RETURN DICTIONARYS TAGS */
    let TAG_USER_ID = "TAG_USER_ID"
    let TAG_CUSTOM_ID = "TAG_CUSTOM_ID"
    let TAG_USER_NAME = "TAG_USER_NAME"
    let TAG_USER_COURSE_LIST = "TAG_USER_COURSE_LIST"
    let TAG_JOIN_TIMESTAMP = "TAG_JOIN_TIMESTAMP"
    let TAG_JOIN_YR = "TAG_JOIN_YR"
    let TAG_SELF_INTRO = "TAG_SELF_INTRO"
    let TAG_FILE_LIST = "TAG_FILE_LIST"
    let TAG_SUBS_LIST = "TAG_SUBS_LIST"
    let TAG_FILE_ID = "TAG_FILE_ID"
    let TAG_FILE_NAME = "TAG_FILE_NAME"
    let TAG_FILE_COURSE = "TAG_FILE_COURSE"
    let TAG_FILE_LINK = "TAG_FILE_LINK"
    let TAG_FILE_TIMESTAMP = "TAG_FILE_TIMESTAMP"
    
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
    //
    
    var loginer:UserLoginProtocol?
    var delegate:UserTableEditorCallBackProtocol?
    var fileManager:UserUploadDownloadCallBackProtocol?
    
    func getListOfUsers(){
        
    }
    
    /*********************************/
    /*****        User ID        *****/
    /*********************************/
    func getUserIdentity() -> String {
        return Appdata.sharedInstance.myUserID
    }
    
    /*********************************/
    /*****        Account        *****/
    /*********************************/
    func setMyAccount(_ email:String, pw:String){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let config:AWSDynamoDBObjectMapperConfiguration = AWSDynamoDBObjectMapperConfiguration()
        
        let itemToCreate = AccountTable()
        itemToCreate?._email = email
        itemToCreate?._password = pw
        
        config.saveBehavior = AWSDynamoDBObjectMapperSaveBehavior.update
        config.consistentRead = true
        objectMapper.save(itemToCreate!, completionHandler:{(error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                
                // Fail Block
                self.delegate?.didSetItemWith(false, itemType: c.TYPE_ACCOUNT)
                return
            }
            
            // Succeed Block
            log.d("sat")
            self.delegate?.didSetItemWith(true, itemType: c.TYPE_ACCOUNT)
            
            
        })
    }
    
    func loginAccount(_ email:String, pw:String){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        objectMapper.load(AccountTable.classForCoder(), hashKey: email, rangeKey: pw, completionHandler:{(result, error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                // Fail Block
                self.delegate?.didGetItemFailedWithError(c.TYPE_ACCOUNT, error: error.localizedDescription)
                return
            }
            if let result:AccountTable = result as? AccountTable{
                
                // Succeed with Result
                NSLog("%@",result)
                log.d("YOOOOOOOO, UserId = \(result._email)")
                self.loginer?.didLoginSucceed(result._email!)
                
            } else {
                
                // Succeed with object not exist
                log.d("NO RESULT")
                self.loginer?.didLoginFailed()
                
            }
        })
    }
    
    /*********************************/
    /*****      Users Info       *****/
    /*********************************/
    
    func scanAllUser(){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let exp:AWSDynamoDBScanExpression = AWSDynamoDBScanExpression()
        //        exp.projectionExpression = "userId"
        objectMapper.scan(UsersTable.classForCoder(), expression: exp, completionHandler: {(result, error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                // Fail Block
                log.d("FAIL")
                self.delegate?.didGetItemFailedWithError(c.TYPE_USER_INFO, error: error.localizedDescription)
                
                return
            }
            
            log.d("HI")
            
            if let result:AWSDynamoDBPaginatedOutput = result
            {
                log.d("HIHI")
                // Succeed with Result
                
                if result.items.count==0 {
                    self.delegate?.didGetItemSucceedWithItem(c.TYPE_USER_INFO, item: nil)
                }
                else
                {
                    for var i in 0..<result.items.count
                    {
                        let item:UsersTable = result.items[i] as! UsersTable
                        
                        log.d("Item read.")
                        log.d("userId: \(item._userId)")
                        log.d("name: \(item._name)")
                        log.d("courseList: \(item._courseList)")
                        log.d("joinTimestamp: \(item._joinTimestamp)")
                        log.d("joinYr: \(item._joinYr)")
                        log.d("selfIntro: \(item._selfIntro)")
                        log.d("----------")
                        let dict = NSMutableDictionary()
                        dict.setObject(item._userId!, forKey: c.TAG_USER_ID as NSCopying)
                        dict.setObject(item._name!, forKey: c.TAG_USER_NAME as NSCopying)
                        dict.setObject(item._courseList!, forKey: c.TAG_USER_COURSE_LIST as NSCopying)
                        dict.setObject(item._joinTimestamp!, forKey: c.TAG_JOIN_TIMESTAMP as NSCopying)
                        dict.setObject(item._joinYr!, forKey: c.TAG_JOIN_YR as NSCopying)
                        dict.setObject(item._selfIntro!, forKey: c.TAG_SELF_INTRO as NSCopying)
                        self.delegate?.didGetItemSucceedWithItem(c.TYPE_USER_INFO, item: dict)
                    }
                }
            }
            else {
                // Succeed with object not exist
                log.d("Not found")
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_USER_INFO, item: nil)
            }
        })
    }
    
    func getUserInfoById(_ userId:String){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.load(UsersTable.classForCoder(), hashKey: userId, rangeKey: nil, completionHandler:{(result, error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                // Fail Block
                self.delegate?.didGetItemFailedWithError(c.TYPE_USER_INFO, error: error.localizedDescription)
                
                return
            }
            if let result:UsersTable = result as? UsersTable{
                
                // Succeed with Result
                
                log.d("Item read.")
                log.d("name: \(result._name)")
                let dict = NSMutableDictionary()
                dict.setObject(result._userId!, forKey: c.TAG_USER_ID as NSCopying)
                dict.setObject(result._name!, forKey: c.TAG_USER_NAME as NSCopying)
                dict.setObject(result._courseList!, forKey: c.TAG_USER_COURSE_LIST as NSCopying)
                dict.setObject(result._joinTimestamp!, forKey: c.TAG_JOIN_TIMESTAMP as NSCopying)
                dict.setObject(result._joinYr!, forKey: c.TAG_JOIN_YR as NSCopying)
                dict.setObject(result._selfIntro!, forKey: c.TAG_SELF_INTRO as NSCopying)
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_USER_INFO, item: dict)
                
                
                
            } else {
                
                // Succeed with object not exist
                log.d("Not found")
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_USER_INFO, item: nil)
                
                
            }
        })
    }
    
    func setUserInfo(_ _courseList:Set<String>?,
                     joinTimestamp:Int64?,
                     joinYr:Int?,
                     name:String?,
                     selfIntro:String?) {   // fields can be null
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let itemToCreate = UsersTable()
        // Blank check
        itemToCreate?._userId = Appdata.sharedInstance.myUserID
        if let _courseList = _courseList          { if _courseList.count>0 { itemToCreate?._courseList = _courseList}}
        //if let joinTimestamp = joinTimestamp    { itemToCreate?._joinTimestamp = joinTimestamp as NSNumber? }
        
        if let joinTimestamp = joinTimestamp    { itemToCreate?._joinTimestamp = NSNumber(value:joinTimestamp) }
        
        if let joinYr = joinYr                  { itemToCreate?._joinYr = joinYr as NSNumber? }
        if let name = name                      { itemToCreate?._name = name }
        if let selfIntro = selfIntro            { itemToCreate?._selfIntro = selfIntro }
        //強迫症._.   ?? 咩意思？
        
        let config:AWSDynamoDBObjectMapperConfiguration = AWSDynamoDBObjectMapperConfiguration()
        config.saveBehavior = AWSDynamoDBObjectMapperSaveBehavior.update
        config.consistentRead = true
        objectMapper.save(itemToCreate!, configuration: config, completionHandler:{(error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                self.delegate?.didSetItemWith(false, itemType: c.TYPE_USER_INFO)
                return
            }
            log.d("Item saved.")
            self.delegate?.didSetItemWith(true, itemType: c.TYPE_USER_INFO)
            //self.delegate?.didModifyDataSucceed(itemToCreate._userId!)
        })
    }
    
    /*********************************/
    /***** User Subscrible List  *****/
    /*********************************/
    
    func setSubscribleList(_ list:NSArray){
        
        if list.count<0{
            return
        }
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let config:AWSDynamoDBObjectMapperConfiguration = AWSDynamoDBObjectMapperConfiguration()
        
        let itemToCreate = UserSubscribledList()
        
        itemToCreate?._userId = Appdata.sharedInstance.myUserID
        let arr = list as! Array<String>
        itemToCreate?._subsList = Set(arr)
        
        config.saveBehavior = AWSDynamoDBObjectMapperSaveBehavior.update
        config.consistentRead = true
        objectMapper.save(itemToCreate!, completionHandler:{(error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                // Fail Block
                self.delegate?.didSetItemWith(false, itemType: c.TYPE_USER_SUBS)
                
                return
            }
            
            // Succeed Block
            self.delegate?.didSetItemWith(true, itemType: c.TYPE_USER_SUBS)
            
            
        })
        
    }
    
    func getSubscribleList(_ userId:String){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.load(UserSubscribledList.classForCoder(), hashKey: userId, rangeKey: nil, completionHandler:{(result, error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                // Fail Block
                self.delegate?.didGetItemFailedWithError(c.TYPE_USER_SUBS, error: error.localizedDescription)
                
                return
            }
            if let result:UserSubscribledList = result as? UserSubscribledList{
                
                // Succeed with Result
                NSLog("%@",result)
                log.d("YOOOOOOOO, UserId = \(result._userId)")
                log.d("Subscribled: \(result._subsList)")
                
                let dict = NSMutableDictionary()
                dict.setObject(result._userId!, forKey: c.TAG_USER_ID as NSCopying)
                dict.setObject(result._subsList!, forKey: c.TAG_SUBS_LIST as NSCopying)
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_USER_SUBS, item: dict)
                
                
            } else {
                
                // Succeed with object not exist
                log.d("NO RESULT")
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_USER_SUBS, item: nil)
            }
        })
    }
    
    /*********************************/
    /*****      User File List   *****/
    /*********************************/
    
    func setUserFilesListTable(_ list:NSArray){
        
        if list.count<0{
            return
        }
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let config:AWSDynamoDBObjectMapperConfiguration = AWSDynamoDBObjectMapperConfiguration()
        
        let itemToCreate = UserFilesListTable()
        
        itemToCreate?._userId = Appdata.sharedInstance.myUserID
        let arr = list as! Array<String>
        itemToCreate?._filesList = Set(arr)
        
        config.saveBehavior = AWSDynamoDBObjectMapperSaveBehavior.update
        config.consistentRead = true
        objectMapper.save(itemToCreate!, completionHandler:{(error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                // Fail Block
                self.delegate?.didSetItemWith(false, itemType: c.TYPE_USER_FILE)
                
                return
            }
            
            // Succeed Block
            self.delegate?.didSetItemWith(true, itemType: c.TYPE_USER_FILE)
        })
    }
    
    func getUserFilesListTable(_ userId:String){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.load(UserFilesListTable.classForCoder(), hashKey: userId, rangeKey: nil, completionHandler:{(result, error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                // Fail Block
                self.delegate?.didGetItemFailedWithError(c.TYPE_USER_FILE, error: error.localizedDescription)
                return
            }
            if let result:UserFilesListTable = result as? UserFilesListTable{
                
                // Succeed with Result
                NSLog("%@",result)
                log.d("YOOOOOOOO, UserId = \(result._userId)")
                log.d("files: \(result._filesList)")
                
                let dict = NSMutableDictionary()
                dict.setObject(result._userId!, forKey: c.TAG_USER_ID as NSCopying)
                dict.setObject(result._filesList!, forKey: c.TAG_FILE_LIST as NSCopying)
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_USER_FILE, item: dict)
                //log.d("delegate: \(self.delegate)")
                
            } else {
                
                // Succeed with object not exist
                log.d("NO RESULT")
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_USER_FILE, item: nil)
                
            }
        })
    }
    
    /*********************************/
    /*****          File         *****/
    /*********************************/
    
    func getFileInfoByfileId(_ fileId:String){
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.load(FilesTable.classForCoder(), hashKey: fileId, rangeKey: nil, completionHandler:{(result, error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                // Fail Block
                self.delegate?.didGetItemFailedWithError(c.TYPE_FILE, error: error.localizedDescription)
                
                return
            }
            if let result:FilesTable = result as? FilesTable{
                
                // Succeed with Result
                
                log.d("Item read.")
                log.d("name: \(result._name)")
                let dict = NSMutableDictionary()
                dict.setObject(result._fileId!, forKey: c.TAG_FILE_ID as NSCopying)
                dict.setObject(result._userId!, forKey: c.TAG_USER_ID as NSCopying)
                dict.setObject(result._name!, forKey: c.TAG_FILE_NAME as NSCopying)
                if result._course != nil{
                    
                    
                    print(result._course)
                    dict.setObject(result._course!, forKey: c.TAG_FILE_COURSE as NSCopying)
                }else{
                    
                    print(result._course)
                    dict.setObject("unclassified course", forKey: c.TAG_FILE_COURSE as NSCopying)
                    
                }
                if result._fileLink != nil {
                    print(result._fileLink)
                    dict.setObject(result._fileLink!, forKey: c.TAG_FILE_LINK as NSCopying)
                    
                } else {
                    print(result._fileLink)
                    dict.setObject("unclassified file link", forKey: c.TAG_FILE_LINK as NSCopying)
                }
                dict.setObject(result._timestamp!, forKey: c.TAG_FILE_TIMESTAMP as NSCopying)
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_FILE, item: dict)
                
            } else {
                
                // Succeed with object not exist
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_FILE, item: nil)
                
            }
        })
    }
    
    func setFileInfo(_ fileId:String?,
                     name:String?,
                     course:String?,
                     fileLink:String?) {   // fields can be null
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let itemToCreate = FilesTable()
        // Blank check
        itemToCreate?._userId = Appdata.sharedInstance.myUserID
        if let fileId = fileId      { itemToCreate?._fileId = fileId}
        if let name = name          { itemToCreate?._name = name }
        if let fileLink = fileLink  { itemToCreate?._fileLink = fileLink }
        if let course = course  { itemToCreate?._course = course }
        let f :DateFormatter = DateFormatter()
        f.dateFormat = "YYYYMMddhhmmss"
        let s = f.string(from: Date())
        let numDate = Int64(s)
        
        itemToCreate?._timestamp = NSNumber(value: numDate!)
        
        
        let config:AWSDynamoDBObjectMapperConfiguration = AWSDynamoDBObjectMapperConfiguration()
        config.saveBehavior = AWSDynamoDBObjectMapperSaveBehavior.update
        config.consistentRead = true
        
        objectMapper.save(itemToCreate!, configuration: config, completionHandler:{(error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                self.delegate?.didSetItemWith(false, itemType: c.TYPE_FILE)
                return
            }
            log.d("Item saved.")
            //self.delegate?.didModifyDataSucceed(itemToCreate._userId!)
            self.delegate?.didSetItemWith(true, itemType: c.TYPE_FILE)
            
        })
    }
    
    func queryFileInfoByUserId(_ userid:String){
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.indexName = "byUser"
        queryExpression.hashKeyAttribute = "userId"
        queryExpression.hashKeyValues = (userid)
        
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        objectMapper.query(FilesTable.classForCoder(), expression: queryExpression, completionHandler:{(result, error) -> Void in
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                
                // Fail Block
                
                return
            }
            
            if let result:AWSDynamoDBPaginatedOutput = result{
                
                // Succeed with Result
                
                for var i in 0..<result.items.count {
                    
                    let item:FilesTable = result.items[i] as! FilesTable
                    
                    log.d("Item read.")
                    log.d("name: \(item._name)")
                    let dict = NSMutableDictionary()
                    dict.setObject(item._fileId!, forKey: "fileId" as NSCopying)
                    dict.setObject(item._userId!, forKey: "userId" as NSCopying)
                    dict.setObject(item._name!, forKey: "name" as NSCopying)
                    dict.setObject(item._course!, forKey: "course" as NSCopying)
                    dict.setObject(item._fileLink!, forKey: "fileLink" as NSCopying)
                    dict.setObject(item._timestamp!, forKey: "timestamp" as NSCopying)
                    self.delegate?.didGetItemSucceedWithItem(c.TYPE_FILE, item: dict)
                }
                
                if result.items.count==0 {
                    self.delegate?.didGetItemSucceedWithItem(c.TYPE_FILE, item: nil)
                }
                
            } else {
                
                // Succeed with object not exist
                self.delegate?.didGetItemSucceedWithItem(c.TYPE_FILE, item: nil)
                
            }
        })
    }
    
    /* File upload/ download */
    
    var prefix = "public/"
    public func uploadFile(data: NSData, fileid:String){
        //        let key: String = "\(self.prefix)\(specifiedKey)"
        let key: String = "\(self.prefix)\(fileid)"
        
        let manager: AWSUserFileManager! = AWSUserFileManager.defaultUserFileManager()
        let localContent = manager.localContent(with: data as Data, key: key)
        
        localContent.uploadWithPin(onCompletion: true, progressBlock: {[weak self](content: AWSLocalContent?, progress: Progress?) -> Void in
            if let progress = progress {
                log.d("uploading... \(progress.completedUnitCount)/\(progress.totalUnitCount)")
            }
            
            }, completionHandler: {(content: AWSContent?, error: Error?) -> Void in
                if let error = error {
                    log.d("Failed to upload an object. \(error)")
                    self.fileManager?.didUploadFileFailedWith(fileid, error: error.localizedDescription)
                    return
                } else {
                    log.d("Upload Succeed.")
                    self.fileManager?.didUploadFileSucceedWith(fileid)
                }
        })
    }
    
    public func downloadFile(fileid:String){
        
        var localfileid = "\(self.prefix)\(fileid)"
        
        
        let contentManager:AWSContentManager! = AWSContentManager.defaultContentManager()
        let content = contentManager.content(withKey: localfileid)
        content.download(with: .always, pinOnCompletion: false, progressBlock: { (content:AWSContent, progress:Progress?) in
            if let progress = progress {
                log.d("downloading... \(progress.completedUnitCount)/\(progress.totalUnitCount)")
            }
        }) { (content:AWSContent?, data:Data?, error:Error?) in
            if let error = error {
                log.d("Download failed, \(error)")
                self.fileManager?.didDownloadFileFailedWith(localfileid, error: error.localizedDescription)
                return
            }
            log.d("Download Succeed")
            self.fileManager?.didDownloadFileSucceedWith(localfileid, data: NSData(data: data!))
        }
    }
}

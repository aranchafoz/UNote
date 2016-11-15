//
//  CameraViewController.swift
//  UNote
//
//  Created by eda on 17/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//


import UIKit
import EventKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserTableEditorCallBackProtocol{
    
    
    var courseField: UITextField!
    
    var auto_saveImageToCorresspondingFolder : Bool!
    
    let currentEventStore = EKEventStore()
    
    let ImageCoreDataStack = CourseListCore()
    //var ImageBinaryData = [TakenPhoto]()
    
    var userAttendingCourseTitle : String!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func photoLibrary(_ sender: AnyObject) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    @IBAction func openCamera(_ sender: AnyObject) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
            
            
        }
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        imageView.image = selectedImage
        
        
        // do stuff in this function
        
        
        
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    @IBAction func saveButton(_ sender: AnyObject) {
        
        
        //test this function when we run on run camera
        
        
//                let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
//        
//                let compressedJPGImage = UIImage(data: imageData!)
//                UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        
        
        //Dont use coredata, use database
        
//                let context = ImageCoreDataStack.persistentContainer.viewContext
//        
//                let notesImageCore = TakenPhoto(context: context)
//        
        
        
        
        
                //let storeToDBFile = imageData as NSData?
        
        
        var thisFileCourse : String? = nil
        
        if auto_saveImageToCorresspondingFolder == true {
        
        
                    thisFileCourse = self.userAttendingCourseTitle
        
        }else if auto_saveImageToCorresspondingFolder == false{
            
            let alert = UIAlertController()
            
            let action = UIAlertAction(title: "some wrong", style: .default, handler: nil)
            
            alert.addAction(action)
            
                    thisFileCourse = "defaultTestCourse"
            
        }
        
        if (self.userAttendingCourseTitle) != nil {
            
            let courseName = self.userAttendingCourseTitle
            let fileid:String = String(c.getTimestamp())
            Appdata.sharedInstance.myFileList.add(fileid)
            Appdata.sharedInstance.awsEditor?.setFileInfo(fileid, name: fileid+".pdf", course: courseName, fileLink: "/file/")
            
        }else{
            
            
            var alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: configurationTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler:{ (UIAlertAction) in
                print("Done !!")
                
                print("Item : \(self.courseField.text)")
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
            
            
            
        }
        
        
        
        
        
        
               // ImageCoreDataStack.saveContext()
        
        //wait to be debug on this c.getTimeestamp() function
        
        
        
        // create the alert
        let alert = UIAlertController(title: "Saved", message: "Saved image.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let askCurrentCourseAttendMessage = UIAlertController(title: "Asking", message: "If you want to save your picture corresponding folder, please click OK , otherwise Cancel", preferredStyle: .alert)
        
        askAuthorizedAccessCalendar()
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("OK Pressed")
            
            self.auto_saveImageToCorresspondingFolder = true
            
            
            self.accessCurrentAttendingCourse(eventStore: self.currentEventStore)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            print("Cancel Pressed")
            
            self.auto_saveImageToCorresspondingFolder = false
        }
        
        
        
        
        askCurrentCourseAttendMessage.addAction(okAction)
        askCurrentCourseAttendMessage.addAction(cancelAction)
        
        
        self.present(askCurrentCourseAttendMessage, animated: true, completion: nil)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func accessCurrentAttendingCourse(eventStore : EKEventStore){
        
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        let alertController = UIAlertController()
        
        for calendar in calendars {
            if calendar.title == "College Calendar" {
                
                let five_minsAgo = Date(timeIntervalSinceNow: -1*1*300)
                let five_minsAfter = Date(timeIntervalSinceNow: 1*5*300)
                
                let predicate = eventStore.predicateForEvents(withStart: five_minsAgo, end: five_minsAfter, calendars: [calendar])
                
                let events = eventStore.events(matching: predicate)
                
                
                if events.count == 1 {
                    
                    userAttendingCourseTitle = events[0].title
                }else{
                    
                    let action = UIAlertAction(title: "Detect at least two lesson on the College Calendar, please delete the unattended course shedule", style: .default, handler: nil)
                    
                    
                    alertController.addAction(action)
                
                
                }
                
                
                
                
            }
        }
        
        
        
        
        
    }
    
    
    
    func askAuthorizedAccessCalendar(){
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            
            print("authorized")
        case .denied:
            
            print("Access denied")
            
            
            
        case .notDetermined:
            print("not determined")
            
            currentEventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                if granted {
                    
                    print("grandted")
                    
                    
                }else{
                    print("Access denied")
                    
                    
                }
                
                
            })
            
            
        default:
            print("case default")
            
        }
        
        
        
        
        
    }
    
    
    func configurationTextField(textField: UITextField!)
    {
        print("generating the TextField")
        textField.placeholder = "Enter an item"
        courseField = textField
    }
    
    func handleCancel(alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    
    
    
    func didGetItemSucceedWithItem(_ itemType: String, item: NSDictionary?) {
        
        
    }
    
    func didSetItemWith(_ state: Bool, itemType: String) {
        log.d("call this funciton")
        
        if state && itemType == c.TYPE_FILE{
            
            Appdata.sharedInstance.awsEditor?.setUserFilesListTable(Appdata.sharedInstance.myFileList)
            
            Appdata.sharedInstance.awsEditor?.getFileInfoByfileId(Appdata.sharedInstance.myFileList.lastObject as! String)
            
        }
        
        
        
    }
    
    
    
    func didGetItemFailedWithError(_ itemType: String, error: String) {
    
        log.d("Save file error Handling")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //setup delegate
        Appdata.sharedInstance.awsEditor?.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        Appdata.sharedInstance.awsEditor?.delegate = nil
    }
}


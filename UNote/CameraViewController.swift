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
    
    @IBOutlet weak var filenoteName: UITextField!
    
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
        
        var noteName :String!
        
        
        if self.filenoteName.text == nil || self.filenoteName.text == ""{
           
            
            print("wrong wrong")
            
            
            let alert = UIAlertController(title: "", message: "Please enter a file name", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
       
            
            alert.addAction(action)
            
            self.present(alert, animated: false, completion: nil)
            
            return
            
        }else{
            
            if imageView.image == UIImage(named: "notebook") {
                let alert = UIAlertController(title: "", message: "Please, select an image before", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                
                alert.addAction(action)
                
                self.present(alert, animated: false, completion: nil)
                
                return
                
            } else {
                
                noteName = filenoteName.text!
                
            }
        }

        
        
        var thisFileCourse : String? = nil
        
        if auto_saveImageToCorresspondingFolder == true {
        
        
                    thisFileCourse = self.userAttendingCourseTitle
        
        }else if auto_saveImageToCorresspondingFolder == false{
            
            let alert = UIAlertController(title: "Error!", message: "The feature is block beacuse user don't allow the app to use it!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert, animated: false, completion: nil)
            
            
            thisFileCourse = "defaultTestCourse"
            
        }
        
        if (self.userAttendingCourseTitle) != nil {
            
            let courseName = self.userAttendingCourseTitle
            let fileid:String = String(c.getTimestamp())
            Appdata.sharedInstance.myFileList.add(fileid)
            Appdata.sharedInstance.awsEditor?.setFileInfo(fileid,name: "\(noteName).jpg", course: courseName, fileLink: "/file/")
            
        }else{
            
            var manual_courseName:String!
            
            let alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: configurationTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler:{ (UIAlertAction) in
                print("Done !!")
                print("Item : \(self.courseField.text)")
                
                    manual_courseName = self.courseField.text
                print(manual_courseName)
                
              
                let fileid:String = String(c.getTimestamp())
                Appdata.sharedInstance.myFileList.add(fileid)
                Appdata.sharedInstance.awsEditor?.setFileInfo(fileid, name: "\(noteName).jpg", course: manual_courseName, fileLink: "/file/")
                
                
                
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
            
            
            
        }
        
        
        
        
        // create the alert
        let alert = UIAlertController(title: "Saved", message: "Image has been saved in your Notes!", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        imageView.image = UIImage(named: "notebook")
        filenoteName.text = nil
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let askCurrentCourseAttendMessage = UIAlertController(title: "Storage", message: "Do you want to save your picture in corresponding folder?", preferredStyle: .alert)
        
        askAuthorizedAccessCalendar()
        
        
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("OK Pressed")
            
            self.auto_saveImageToCorresspondingFolder = true
            
            
            self.accessCurrentAttendingCourse(eventStore: self.currentEventStore)
            
        }
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive) {
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
        
        for calendar in calendars {
            if calendar.title == "College Calendar" {
                
                let five_minsAgo = Date(timeIntervalSinceNow: -1*1*300)
                let five_minsAfter = Date(timeIntervalSinceNow: 1*5*300)
                
                let predicate = eventStore.predicateForEvents(withStart: five_minsAgo, end: five_minsAfter, calendars: [calendar])
                
                let events = eventStore.events(matching: predicate)
                
                
                if events.count == 1 {
                    
                    userAttendingCourseTitle = events[0].title
                }else if events.count > 1 {
                    
                    
                    
                    
                    let alertController = UIAlertController(title: "Warning!", message: "Detect at least two lesson on the College Calendar, please delete the unattended course shedule", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    
                    alertController.addAction(action)
                
                    
                    // show the alert
                    self.present(alertController, animated: true, completion: nil)
                
                }else if events.count == 0{
                    
                    
                    let alertController = UIAlertController(title: "Warning!", message: "The App could no detect user college calendar", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    
                    alertController.addAction(action)
                    
                    
                    // show the alert
                    self.present(alertController, animated: true, completion: nil)
                    
                    
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
     
        textField.placeholder = "Enter the course name"
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


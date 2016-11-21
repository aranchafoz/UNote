//
//  CameraViewController.swift
//  UNote
//
//  Created by eda on 17/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//


import UIKit
import EventKit

extension UIImage{
    enum JPEGQuality:CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
        
        
    }
    
    
    var pngData:Data?{
        return UIImagePNGRepresentation(self)
        
    }
    
    func jpegData(_ quality:JPEGQuality) -> Data {
        
        return UIImageJPEGRepresentation(self, quality.rawValue)!
    }
    
    
    
    
}



class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserTableEditorCallBackProtocol,UserUploadDownloadCallBackProtocol{
    
    @IBOutlet weak var filenoteName: UITextField!
    
    var courseField: UITextField!
    
    var auto_saveImageToCorresspondingFolder : Bool!
    
    
    @IBOutlet weak var alternativeCourse: UITextField!
    
    
    
    
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
    
    var readyUploadImage:UIImage!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        print("====")
        print(info.debugDescription)
    
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            
            imageView.image = selectedImage
            readyUploadImage = selectedImage
            
            
        }else if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
         
            
            
            imageView.image = selectedImage
            readyUploadImage = selectedImage
            
        }else{
        
            
            
            print("errrr")
        
        }
        
        
        
        
        
        
        // do stuff in this function
        
        
        
        
        self.dismiss(animated: true, completion: nil)
        
        
        
        
        
    }
 
    
    
    func didUploadFileFailedWith(_ fileid: String, error: String) {
        print("ffff")
    }
    
    func didUploadFileSucceedWith(_ fileid: String) {
    
        
        print("ssss")
        
    }
    func didDownloadFileFailedWith(_ fileid: String, error: String) {
        
    }
 
    func didDownloadFileSucceedWith(_ fileid: String, data: NSData) {
        
    }
    
    
    @IBAction func saveButton(_ sender: AnyObject) {
        
        
        //test this function when we run on run camera
        
        
//                let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
//        
//                let compressedJPGImage = UIImage(data: imageData!)
//                UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        
        
        
        
                //let storeToDBFile = imageData as NSData?
        
        var noteName :String!
        
        
        if self.filenoteName.text == nil || self.filenoteName.text == ""{
           
            
            
            
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
            
            
            print("invoke")
            
            var courseName = self.userAttendingCourseTitle
            let fileid:String = String(c.getTimestamp())
            
            
            if self.alternativeCourse.text != nil && self.alternativeCourse.text != "" {
                
                
                courseName = self.alternativeCourse.text
                
            }
            
            
            
            //let imageData = UIImagePNGRepresentation(self.readyUploadImage)
            
            //let imageNSData = NSData(data: imageData!)
            
            let imageData = readyUploadImage.jpegData(.lowest)
            
            
            Appdata.sharedInstance.myFileList.add(fileid)
            Appdata.sharedInstance.awsEditor?.setFileInfo(fileid,name: noteName, course: courseName, fileLink: "/file/")
            
            
            Appdata.sharedInstance.awsEditor?.uploadFile(data: imageData as NSData, fileid: fileid)
            
            
        }else{
            
            var manual_courseName:String!
            
            
            
            
            
            
            let alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: configurationTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler:{ (UIAlertAction) in
                
                manual_courseName = self.courseField.text
                
                
            //    let imageData = UIImagePNGRepresentation(self.readyUploadImage)
                
              //  let imageNSData = NSData(data: imageData!)
                
                let imageData = self.readyUploadImage.jpegData(.lowest)
                
                
                
                
                if self.alternativeCourse.text != nil && self.alternativeCourse.text != "" {
                    
                    
                    manual_courseName = self.alternativeCourse.text
                    
                }
                
                
                
                let fileid:String = String(c.getTimestamp())
                Appdata.sharedInstance.myFileList.add(fileid)
                Appdata.sharedInstance.awsEditor?.setFileInfo(fileid, name: noteName, course: manual_courseName, fileLink: "/file/")
                Appdata.sharedInstance.awsEditor?.uploadFile(data: imageData as NSData, fileid: fileid)
                
                
                
                
                
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        // create the alert
        let alert = UIAlertController(title: "Saved", message: "Image has been saved in your Notes and upload to the server!", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
        self.imageView.image = UIImage(named: "notebook")
        self.filenoteName.text = nil
        
        

    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.alternativeCourse.placeholder = "Optional, If your note belong to other course"
    
        
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
                    
                    print("user attending")
                    print(self.userAttendingCourseTitle)
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
        Appdata.sharedInstance.awsEditor?.fileManager = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        Appdata.sharedInstance.awsEditor?.delegate = nil
        
        Appdata.sharedInstance.awsEditor?.fileManager = nil
    }
}


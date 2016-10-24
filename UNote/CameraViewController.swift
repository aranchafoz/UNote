//
//  CameraViewController.swift
//  UNote
//
//  Created by eda on 17/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//


import UIKit
import EventKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var auto_saveImageToCorresspondingFolder : Bool!
    
    let currentEventStore = EKEventStore()
    
    let ImageCoreDataStack = CourseListCore()
    var ImageBinaryData = [TakenPhoto]()
    
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
        
        
                let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)
        
                let compressedJPGImage = UIImage(data: imageData!)
                UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
                let context = ImageCoreDataStack.persistentContainer.viewContext
        
                let notesImageCore = TakenPhoto(context: context)
        
                //notesImageCore.noteImage = imageData as NSData?
        
                notesImageCore.noteImage = nil
                notesImageCore.noteTitle = "example1"
                //notesImageCore.courseName =
        
                if auto_saveImageToCorresspondingFolder == true {
        
        
                    notesImageCore.courseName = self.userAttendingCourseTitle
        
                }
        
        
                ImageCoreDataStack.saveContext()
        
        
        
        
        
        
        
        //test save data function without camera function in simulator, will discard
//        
//        let context = ImageCoreDataStack.persistentContainer.viewContext
//        
//        let notesImageCore = TakenPhoto(context: context)
//        
//        //notesImageCore.noteImage = imageData as NSData?
//        notesImageCore.noteImage = nil
//        notesImageCore.noteTitle = "3000"
//        notesImageCore.courseName = "ee3000"
//        
//        ImageCoreDataStack.saveContext()
//        
//        
//        
        
        
        
        
        
        
        
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
        
        for calendar in calendars {
            if calendar.title == "College Calendar" {
                
                let five_minsAgo = Date(timeIntervalSinceNow: -1*1*300)
                let five_minsAfter = Date(timeIntervalSinceNow: 1*5*300)
                
                let predicate = eventStore.predicateForEvents(withStart: five_minsAgo, end: five_minsAfter, calendars: [calendar])
                
                let events = eventStore.events(matching: predicate)
                
                
                if events.count == 1 {
                    
                    userAttendingCourseTitle = events[0].title
                }else{
                    
                    print("College Calendar is not well set, two course detect at the same time")
                    
                    
                    
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


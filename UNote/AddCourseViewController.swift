//
//  AddCourseViewController.swift
//  UNote
//
//  Created by SUNGKAHO on 20/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//

import UIKit
import EventKit
import CoreData
class AddCourseViewController: UIViewController, UserTableEditorCallBackProtocol {

    @IBOutlet weak var courseName: UITextField!
    
    @IBOutlet weak var courseDuration: UITextField!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    let reoccrEventStore = EKEventStore()
    
    var coreDataCourse : [CourseList] = []
    
    
    var coreDataStack = CourseListCore()
    
    
    @IBAction func addSubject(_ sender: AnyObject) {
        
        
        
        if ((courseName.text?.isEmpty)! || (courseDuration.text?.isEmpty)!){
            
            print("not valid course title")
            return
        }else{
            
            createCourse(store: reoccrEventStore)
            
        }
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        self.endDatePicker.datePickerMode = UIDatePickerMode.date
        
        courseName.placeholder = "course title"
        
        courseDuration.placeholder = "course duration in minutes"
        
        //let eventStore = EKEventStore()
        endDatePicker.resignFirstResponder()
        
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            
            autocheckCalendar()
            
        
            break
            
            
        case .denied:
            
            print("Access denied")
            
        case .notDetermined:
            print("not determined")
            
            reoccrEventStore.requestAccess(to: .event, completion: { (granted: Bool, NSError) -> Void in
                if granted {
                    
                    print("grandted")
                    
                    
                    self.autocheckCalendar()
                    
                    
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
    
    
    
    func createCourse(store: EKEventStore){
        
        
        let icloudSource = sourceInEventStore(eventStore: store, type: .calDAV, title: "iCloud")
        
        
        if icloudSource == nil {
            
            print("no icloud")
            
            return
            
        }
        
        
        
        
        
        
        let calendar = calendarWithTitle(title: "College Calendar",
                                         type: .calDAV,
                                         source: icloudSource!,
                                         eventType: .event)
        

        
        
        createCourse(store: store, calendar: calendar!)
            
        
        
        
    }
    
    
    private func createCourse(store: EKEventStore, calendar: EKCalendar) -> Bool{
        
        
        let event  = EKEvent(eventStore: store)
        
        let startDate = self.startDatePicker.date
        
        
        let hoursInterval : TimeInterval!
        
        let rawMins = Int(self.courseDuration.text!)
        
        
        hoursInterval = TimeInterval(rawMins! * 60)
        
        
        
        
        let endDate = startDate.addingTimeInterval(hoursInterval)
        
        
        event.calendar = calendar
        event.title = self.courseName.text!
        
        event.startDate = startDate
        
        event.endDate = endDate
        
        _ = self.endDatePicker.date.timeIntervalSince(self.startDatePicker.date)
        let recurringEnd = EKRecurrenceEnd(end: self.endDatePicker.date)
        
        
        let recurringRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: recurringEnd)
        
        
        event.recurrenceRules = [recurringRule]
        
        
        
        
        do{
            try store.save(event, span: .futureEvents)
            
            print("event title" + event.title)
            print("Successfully created the recurring event.")
            
            let context = coreDataStack.persistentContainer.viewContext
            
            
            
            let addCourseToCore = CourseList(context: context)
           
            
            addCourseToCore.courseTitle = event.title
            
            
            
            
            
            coreDataStack.saveContext()
                
            try store.commit()
            
            return true
            
        }catch let error as NSError{
            
            print("Failed to create the recurring " + "event with error = \(error)")
            
        }
        
        
        
        return false
        
    }
    
    func sourceInEventStore(
        eventStore: EKEventStore,
        type: EKSourceType,
        title: String) -> EKSource?{
        
        for source in eventStore.sources{
            if source.sourceType.rawValue == type.rawValue &&
                source.title.caseInsensitiveCompare(title) ==
                ComparisonResult.orderedSame{
                return source
            }
        }
        
        return nil
    }
    
    func calendarWithTitle(
        title: String,
        type: EKCalendarType,
        source: EKSource,
        eventType: EKEntityType) -> EKCalendar?{
        
        for calendar in source.calendars(for: eventType) as Set<EKCalendar>{
            if calendar.title.caseInsensitiveCompare(title) ==
                ComparisonResult.orderedSame &&
                calendar.type.rawValue == type.rawValue{
                
                print("I have find calendar name")
                
                
                print(calendar.title)
                
                
                
                return calendar
            }
        }
        
        return nil
    }
    
    
    func checkCalendar() -> EKCalendar {
        var retCal: EKCalendar?
        
        let calendars = self.reoccrEventStore.calendars(for: .event) // Grab every calendar the user has
        var exists: Bool = false
        for calendar in calendars { // Search all these calendars
            if calendar.title == "College Calendar" {
                exists = true
                retCal = calendar
            }
        }
        
        
        if !exists {
            let newCalendar = EKCalendar(for:.event, eventStore:reoccrEventStore)
            newCalendar.title="College Calendar"
            newCalendar.source = reoccrEventStore.defaultCalendarForNewEvents.source
            
            
            do{
                
                try reoccrEventStore.saveCalendar(newCalendar, commit:true)
                
                
            }catch let err as NSError{
                print(err)
            }
            
            
            retCal = newCalendar
        }
        
        return retCal!
        
    }
    

    
    
    func autocheckCalendar() {
        
        let calendars = self.reoccrEventStore.calendars(for: .event) // Grab every calendar the user has
        var exists: Bool = false
        for calendar in calendars { // Search all these calendars
            if calendar.title == "College Calendar" {
                exists = true
            }
        }
        
        
        
        if !exists {
            let newCalendar = EKCalendar(for:.event, eventStore:reoccrEventStore)
            newCalendar.title="College Calendar"
            newCalendar.source = reoccrEventStore.defaultCalendarForNewEvents.source
       
            
            do{
                
                try reoccrEventStore.saveCalendar(newCalendar, commit:true)
                
            }catch let err as NSError{
                print(err)
            }
        
            
        }
        
    }
    
    
    
    func didSetItemWith(_ state: Bool, itemType: String) {
        
    }
    
    func didGetItemFailedWithError(_ itemType: String, error: String) {
        
        
    }
    
    func didGetItemSucceedWithItem(_ itemType: String, item: NSDictionary?) {
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        // setup delegate
        Appdata.sharedInstance.awsEditor?.delegate = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // dismiss delegate
        Appdata.sharedInstance.awsEditor?.delegate = nil
        
        
    }
    



}

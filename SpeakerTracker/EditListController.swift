//
//  EditListController.swift
//  SpeakerTracker
//
//  Created by Warwick on 31/07/16.
//  Copyright © 2016 Warwick McNaughton. All rights reserved.
//
//  Abstract:
//  Manages the editing of the member list for the current meeting.
//  See abstract for ViewController for user defaults.
//
//


import UIKit

class EditListController: UIViewController {

    
    @IBOutlet weak var meetingName: UITextField!
    @IBOutlet weak var memberList: UITextView!
    
    @IBAction func saveList(_ sender: UIButton) {
        
        // Array for storing each name
        var nameArray = [String]()
        
        // Turn text from text view into an array of characters
        let text = memberList.text
        let textCharacterArray = Array(text!.characters)
        
        // Iterate through array of characters, saving a name to nameArray at each new line character
        var tmpString = ""
        for char in textCharacterArray {
            if char != "\n" {
                tmpString.append(char)
            } else {
                nameArray.append(tmpString)
                tmpString = ""
            }
        }
        
        // If tmpString not empty then have reached end of file without appending last name
        if tmpString.isEmpty == false {
            nameArray.append(tmpString)
        }
        
        // Get current meeting names
        let defaults = UserDefaults.standard

        // Get meeting name
        let meeting = meetingName.text
        var meetingsArray = [String]()
        meetingsArray.append(meeting!)
        
        // Save to user defaults
        defaults.set(nameArray, forKey: meeting!)
        defaults.set(meetingsArray, forKey: "MeetingNames")
        defaults.set(meeting, forKey: "CurrentMeeting")
        
        performSegue(withIdentifier: "Main.storyboard", sender: self)
    }
    
    
    
    // Store memberlist height
    var memberListHeight: CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Defaults
        
        let defaults = UserDefaults.standard
//        if let memberListForMeeting = defaults.array(forKey: "Meetings") {
//            memberList.text = memberListForMeeting[0] as! String
//        }
        if let currentMeeting = defaults.object(forKey: "CurrentMeeting") {
            meetingName.text = currentMeeting as? String
            let nameArray = defaults.array(forKey: currentMeeting as! String) as! [String]
            var textString = String()
            for item in nameArray {
                
                textString = textString + item as String + "\n"
            }
            memberList.text = textString
        }
        
        // Notifications
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowNotification(_:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHideNotification(_:)), name: .UIKeyboardDidHide, object: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    func handleKeyboardShowNotification(_ notification: NSNotification) {
        
        // Store current height of member list
        memberListHeight = memberList.frame.size.height
        
        // Get top of keyboard
        let y_kbTop = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as! NSValue).cgRectValue.origin.y
        
        // Get top of memberlist
        let y_listTop = memberList.frame.origin.y
        
        // Calculate new height memberlist
        let h_listHeight = y_kbTop - y_listTop - 25
        
        memberList.frame.size.height = h_listHeight
    }
    
    
    func handleKeyboardHideNotification(_ notification: NSNotification) {
        memberList.frame.size.height = memberListHeight!
        
    }
    
}

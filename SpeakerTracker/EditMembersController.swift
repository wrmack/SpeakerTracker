//
//  EditListController.swift
//  SpeakerTracker
//
//  Created by Warwick on 31/07/16.
//  Copyright © 2016 Warwick McNaughton. All rights reserved.
//



/*  Abstract:
 *  Manages the editing of the member list for the current meeting.
 *  See abstract for ViewController for user defaults.
 */



import UIKit

class EditMembersController: UIViewController, EditMeetingsControllerDelegate {

    // MARK: - Storyboard outlets
    
    @IBOutlet weak var memberListTextView: UITextView!
    @IBOutlet weak var meetingNameLabel: UILabel!
    
    // MARK: - Storyboard actions
    
    @IBAction func saveList(_ sender: UIButton) {
        
        // Array for storing each name
        var nameArray = [String]()
        
        // Turn text from text view into an array of characters
        let text = memberListTextView.text
        let textCharacterArray = Array(text!)
        
        // Iterate through array of characters, saving a name to nameArray at each new-line character
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
        
        // If final item in name array is empty then remove it
        while nameArray.last != nil && nameArray.last! == "" {
                nameArray.removeLast()
        }

        // Get meeting name
        let meeting = meetingNameLabel.text
        
        // Save to user defaults - names for this meeting and update name of current meeting
        let defaults = UserDefaults.standard
        defaults.set(nameArray, forKey: meeting!)
        defaults.set(meeting, forKey: "CurrentMeeting")
        
        performSegue(withIdentifier: "Main.storyboard", sender: self)
    }
    
    
    
    @IBAction func showMeetings(_ sender: UIButton) {
        
        // Create instance of EditMeetingsController as a popover
        let editMeetingsController = EditMeetingsController()
        editMeetingsController.delegate = self
        editMeetingsController.modalPresentationStyle = UIModalPresentationStyle.popover
        present(editMeetingsController, animated: true, completion: nil)
        
        let editMeetingsPopoverController = editMeetingsController.popoverPresentationController
        editMeetingsPopoverController!.sourceView = sender
        editMeetingsPopoverController!.sourceRect = CGRect(x: 0, y: sender.frame.size.height, width: sender.frame.size.width, height: 1)
        editMeetingsPopoverController!.permittedArrowDirections = .up

    }
    
    // MARK: - Properties
    
    // Store memberlist height
    var memberListHeight: CGFloat?
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Appearance tweaks
        meetingNameLabel.layer.cornerRadius = 5
        meetingNameLabel.layer.masksToBounds = true
        memberListTextView.layer.cornerRadius = 5
        
        
        // User defaults
        
        let defaults = UserDefaults.standard
//        if let memberListForMeeting = defaults.array(forKey: "Meetings") {
//            memberList.text = memberListForMeeting[0] as! String
//        }
        if let currentMeeting = defaults.object(forKey: "CurrentMeeting") {
            meetingNameLabel.text = currentMeeting as? String
            var namesArray = [String]()
            if let array = defaults.array(forKey: currentMeeting as! String) {
                namesArray = array as! [String]
                var textString = String()
                for item in namesArray {
                    
                    textString = textString + item as String + "\n"
                }
                memberListTextView.text = textString
            }

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
    
    // MARK: - Notification handlers
    
    @objc func handleKeyboardShowNotification(_ notification: NSNotification) {
        
        // Store current height of member list
        memberListHeight = memberListTextView.frame.size.height
        
        // Get top of keyboard
        let y_kbTop = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as! NSValue).cgRectValue.origin.y
        
        // Get top of memberlist
        let y_listTop = memberListTextView.frame.origin.y
        
        // Calculate new height memberlist
        let h_listHeight = y_kbTop - y_listTop - 25
        
        memberListTextView.frame.size.height = h_listHeight
    }
    
    
    @objc func handleKeyboardHideNotification(_ notification: NSNotification) {
        memberListTextView.frame.size.height = memberListHeight!
        
    }
    
    // MARK: - Delegate methods
    
    func didSelectMeeting(_ meetingName: String) {
        meetingNameLabel.text = meetingName
        let defaults = UserDefaults.standard
        defaults.set(meetingName, forKey: "CurrentMeeting")
        var textString = String()
        if let nameArray = defaults.array(forKey: meetingName) as? [String] {
            for item in nameArray {            
                textString = textString + item as String + "\n"
            }            
        }
        else {textString = ""}
        memberListTextView.text = textString
    }
}

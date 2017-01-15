//
//  EditMeetingsController.swift
//  SpeakerTracker
//
//  Created by Warwick on 13/01/17.
//  Copyright © 2017 Warwick McNaughton. All rights reserved.
//

import Foundation
import UIKit

protocol EditMeetingsControllerDelegate: class {
    func didSelectMeeting(_ meetingName: String)
}

class EditMeetingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Constants
    
    private let TOOLBAR_HEIGHT: CGFloat = 40
    private let TABLE_CELL_HEIGHT: CGFloat = 40
    
    
    // MARK: Variables
    
    private var numberOfMeetings = 1
    private var meetingsArray = [String]()
    private var theTableView: UITableView?
    private var editButton: UIButton?
    internal weak var delegate: EditMeetingsControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        /* --------------------- Create toolbar with edit button ---------------------------- */
        
        let theToolbar = UIView()
        theToolbar.backgroundColor = UIColor.init(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
        editButton = UIButton(type: .system)
        editButton!.setTitle("Edit", for: .normal)
        editButton!.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17.0)
        editButton!.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
        editButton!.showsTouchWhenHighlighted = true
        theToolbar.addSubview(editButton!)
        view.addSubview(theToolbar)
        
        theToolbar.translatesAutoresizingMaskIntoConstraints = false
        theToolbar.leadingAnchor.constraint(equalTo: theToolbar.superview!.leadingAnchor).isActive = true
        theToolbar.topAnchor.constraint(equalTo: theToolbar.superview!.topAnchor).isActive = true
        theToolbar.heightAnchor.constraint(equalToConstant: TOOLBAR_HEIGHT).isActive = true
        theToolbar.trailingAnchor.constraint(equalTo: theToolbar.superview!.trailingAnchor).isActive = true
        
        editButton!.translatesAutoresizingMaskIntoConstraints = false
        editButton!.leadingAnchor.constraint(equalTo: theToolbar.leadingAnchor, constant: 10).isActive = true
        editButton!.centerYAnchor.constraint(equalTo: theToolbar.centerYAnchor).isActive = true
        editButton!.heightAnchor.constraint(equalToConstant: 35).isActive = true
        editButton!.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        /* -------------------  Get list of meetings ------------------------ */
        
        let defaults = UserDefaults.standard
        if let array = defaults.array(forKey: "MeetingNames") {
            meetingsArray = array as! [String]
            numberOfMeetings = meetingsArray.count
        }
        
        
        /* -------------------  Create the table  ------------------------------- */
        
        let tableRect = CGRect(x: 0, y: TOOLBAR_HEIGHT, width: view.bounds.size.width, height: view.bounds.size.height - TOOLBAR_HEIGHT)
        
        theTableView = UITableView(frame:tableRect) // Rest of view
        theTableView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        theTableView!.rowHeight = UITableViewAutomaticDimension
        theTableView!.estimatedRowHeight = TABLE_CELL_HEIGHT
        theTableView!.allowsSelection = true
        theTableView!.dataSource = self
        theTableView!.delegate = self
        theTableView!.allowsSelectionDuringEditing = true
        
        view.addSubview(theTableView!)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Delegates -
    
    //MARK: UITableViewDataSource protocols
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.isEditing == false {
            return meetingsArray.count
        }
        else {
            return meetingsArray.count + 1
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myIdentifier = "MyReuseIdentifier"
        var tvCell = tableView.dequeueReusableCell(withIdentifier: myIdentifier)
        if tvCell == nil{
            tvCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:myIdentifier)
            tvCell!.backgroundColor = UIColor.white
            tvCell!.textLabel!.numberOfLines = 0
            tvCell!.textLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        }
        
        if (indexPath.row < meetingsArray.count)  {
            let meetingName = meetingsArray[(indexPath as NSIndexPath).row]
            tvCell!.textLabel!.text = meetingName
            tvCell!.textLabel!.font = UIFont.boldSystemFont(ofSize: 17.0)
            tvCell!.textLabel!.textColor = UIColor.black
        }
        if indexPath.row == meetingsArray.count {
            tvCell!.textLabel!.text = "Add meeting"
            tvCell!.textLabel!.font = UIFont.systemFont(ofSize: 17.0)
            tvCell!.textLabel!.textColor = UIColor.lightGray
        }
        return tvCell!
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        /* -------------------  Adding a meeting ------------------ */
        
        if (editingStyle == .insert) {
            
            // Create an alert controller to present an action sheet with a text field for user to enter name of meeting
            
            var testField: UITextField?
            let alert = UIAlertController(title: "Add meeting", message: "Type name of meeting", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {
                textField in
                testField = textField
            })
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                self.meetingsArray.append(testField!.text!)
                tableView.insertRows(at: [IndexPath(row:indexPath.row + 1,section:0)], with: .automatic)
                tableView.reloadRows(at: [IndexPath(row:indexPath.row,section:0)], with: .automatic)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                action in
            })
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: {
            })
        }
        
        
        /* ------------------  Deleting a meeting ----------------- */
        
        if (editingStyle == .delete) {
            
            // Remove from user defaults
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: self.meetingsArray[indexPath.row])
            
            // Remove from array of meetings
            self.meetingsArray.remove(at: indexPath.row)
            
            // Delete row in table
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
    }

    
    //MARK: UITableViewDelegate protocols
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /* ------------ User is not editing but is selecting a meeting to display ------- */
        
        if (tableView.isEditing == false) {
            delegate?.didSelectMeeting(meetingsArray[indexPath.row])
        }
        
            
        /* ------------ User wants to edit the name ---------------- */
        
        else if (tableView.isEditing == true) {
            
            // Create an alert controller to present an action sheet with a text field for user to enter name of meeting
            
            var testField: UITextField?
            let alert = UIAlertController(title: "Rename", message: "Change name of meeting", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {
                textField in
                testField = textField
                testField?.text = self.meetingsArray[indexPath.row]
                
            })
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
                
                // Get members associated with old name then remove them from defaults
                let defaults = UserDefaults.standard
                let membersForMeeting = defaults.array(forKey: self.meetingsArray[indexPath.row])
                defaults.removeObject(forKey: self.meetingsArray[indexPath.row])
                
                // Get new name
                let newName = testField!.text!
                self.meetingsArray[indexPath.row] = newName
                
                // Save new name with current members to defaults
                defaults.set(membersForMeeting, forKey: newName)
                
                // Refresh the UI to display the changes
                tableView.reloadRows(at: [IndexPath(row:indexPath.row,section:0)], with: .automatic)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                action in
            })
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: {
            })

        }
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if (indexPath.row < meetingsArray.count) {
            return .delete
        }
        else if (indexPath.row == (meetingsArray.count)) {
            return .insert
        }
        else {
            return .none
        }
    }


    // MARK: Helpers
    
    func editButtonPressed(_ sender: UIButton) {
        
        if (theTableView?.isEditing == false) {
            theTableView?.setEditing(true, animated: true)
            editButton?.setTitle("List", for: .normal)
        }
        else {
            theTableView?.setEditing(false, animated: true)
            let defaults = UserDefaults.standard
            defaults.set(meetingsArray, forKey: "MeetingNames")
            editButton?.setTitle("Edit", for: .normal)
        }
        theTableView?.reloadData()
    }
    

}

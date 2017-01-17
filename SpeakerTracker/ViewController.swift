//
//  ViewController.swift
//  SpeakerTracker
//
//  Created by Warwick on 29/07/16.
//  Copyright © 2016 Warwick McNaughton. All rights reserved.
//


/* Abstract
 *
 * Manages display of the three speaking lists and timer.  
 * Presents EditMembersController for editing the member list for current meeting.
 * Presents MeetingChooserViewController for selecting the meeting to display.
 * An undo stack is maintained such that whenever a name is moved from one table to another the undo stack is updated.
 *
 * User defaults include:
 *      Key: "MeetingNames"; Value: an array of names of all meeting names.
 *      Key: a meeting name; Value: an array of the member names for that meeting.
 *      Key: "CurrentMeeting"; Value: name of current meeting
 *
 *
 */



import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MeetingChooserViewControllerDelegate  {

    // MARK: - Storyboard references
    
    @IBOutlet weak var meetingName: UILabel!
    @IBOutlet weak var baseList: UITableView!
    @IBOutlet weak var speakerList: UITableView!
    @IBOutlet weak var doneList: UITableView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var meetingButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var showTimerButton: UIButton!    
    @IBOutlet weak var memberTextConstraintLeading: NSLayoutConstraint!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var smTimerLabel: UILabel!
    @IBOutlet weak var smStartButton: UIButton!
    @IBOutlet weak var smPauseButton: UIButton!
    @IBOutlet weak var smStopButton: UIButton!
    @IBOutlet weak var smTimerBackground: UIView!

    
    
    // MARK: Storyboard actions
    
    @IBAction func meetingChooserPressed(_ sender: UIButton) {
        
        // Create instance of MeetingChooserViewController and set its presentation style to be a popover
        meetingChooser = MeetingChooserViewController()
        meetingChooser?.delegate = self
        meetingChooser?.modalPresentationStyle = UIModalPresentationStyle.popover
        present(meetingChooser!, animated: true, completion: nil)
        
        // Get the associated popover presentation controller and set its source
        let meetingChooserPopoverController = meetingChooser?.popoverPresentationController
        meetingChooserPopoverController!.sourceView = sender
        meetingChooserPopoverController!.sourceRect = CGRect(x: 0, y: sender.frame.size.height, width: sender.frame.size.width, height: 1)
        meetingChooserPopoverController!.permittedArrowDirections = .up

    }

    
/**
     A storyboard button action.  The right button on a base-list table row was pressed.
     The name is removed from the base-list and appended to the speaker's list.
     
 */
    @IBAction func baseRightButtonPressed(_ sender: UIButton) {
        
        // Find the cell's text by iterating through the sender's superview's (ie the contentView) subviews
        // until we find the UILabel
        var nameText: String?
        let siblingViews = sender.superview!.subviews
        for view in siblingViews {
            if view is UILabel {
                nameText = (view as! UILabel).text
            }
        }
        
        // Call function to remove name from this table and append to table on right
        moveNameRight(nameText!, fromTableWithIndex: 0)
    }

    
    /**
     * A storyboard button action.  The left button on a speaker-list table row was pressed.
     * The name is removed from the speaker-list table and inserted into the base-list table in its
     * proper position.
     */
    
    @IBAction func speakerLeftButtonPressed(_ sender: UIButton) {
        
        // Find the cell's text by iterating through the sender's superview's (ie the contentView) subviews
        // until we find the UILabel
        var nameText: String?
        let siblingViews = sender.superview!.subviews
        for view in siblingViews {
            if view is UILabel {
                nameText = (view as! UILabel).text
            }
        }
        
        // Get current position for undo stack
        var (_, speakerNames) = tableCollection[1]
        var counter = 0
        var pos1 = 0
        for item in speakerNames {
            if item == nameText {
            pos1 = counter
            } else {
                counter += 1
            }
        }
        
        // Remove it from speaker list
        speakerNames.remove(at: pos1)
        tableCollection[1] = (speakerList, speakerNames)
        
        
        // The selected name needs to be added back into member list in the baseList table
        // Compare the intial full member list with the current member list to get correct position
        // Check each original name against remaining names until get to selected name.
        var (_, currentBaseNameList) = tableCollection[0]
        counter = 0
        var pos2 = 0
        for item in baseNames {
            if item == nameText{
                pos2 = counter
            }
            if currentBaseNameList.contains(item) {
                counter += 1
            }
        }
        currentBaseNameList.insert(nameText!, at: pos2)
        tableCollection[0] = (baseList, currentBaseNameList)
        
        // Update undo stack
        undoStack.append((1, pos1, 0, pos2, nameText!))
        
        
        // Reload tables
        baseList.reloadData()
        speakerList.reloadData()
        
    }
    
    
    
    /**
     * A storyboard button action.  The right button on a speaker-list table row was pressed.
     * The name is removed from the speaker-list and appended to the done-list table.
     */
    
    @IBAction func speakerRightButtonPressed(_ sender: UIButton) {
        
        // Find the cell's text by iterating through the sender's superview's (ie the contentView) subviews
        // until we find the UILabel
        var nameText: String?
        let siblingViews = sender.superview!.subviews
        for view in siblingViews {
            if view is UILabel {
                nameText = (view as! UILabel).text
            }
        }
        
        
        // Call function to remove name from this table and append to table on right
        moveNameRight(nameText!, fromTableWithIndex: 1)
    }
    

    /**
     * A storyboard button action.  The left button on a done-list table row was pressed.
     * The name is removed from the done-list and appended to the speaker-list.
     */
    
    @IBAction func doneLeftButtonPressed(_ sender: UIButton) {
        
        // Find the cell's text by iterating through the sender's superview's (ie the contentView) subviews
        // until we find the UILabel
        var nameText: String?
        let siblingViews = sender.superview!.subviews
        for view in siblingViews {
            if view is UILabel {
                nameText = (view as! UILabel).text
            }
        }
        
        // Get current position for undo stack
        var (_, doneNames) = tableCollection[2]
        var counter = 0
        var pos1 = 0
        for item in doneNames {
            if item == nameText {
                pos1 = counter
            } else {
                counter += 1
            }
        }
        
        // Remove it from done list
        doneNames.remove(at: pos1)
        tableCollection[2] = (speakerList, doneNames)
        
        
        // The selected name needs to be appended to the speaker list table
        var (_, currentSpeakerNameList) = tableCollection[1]
        currentSpeakerNameList.append(nameText!)
        tableCollection[1] = (speakerList, currentSpeakerNameList)
        
        // Update undo stack
        undoStack.append((2, pos1, 1, currentSpeakerNameList.count - 1, nameText!))
        
        
        // Reload tables
        speakerList.reloadData()
        doneList.reloadData()


    }

    
/**
     Resets all lists and the undo stack.
 */
    
    @IBAction func resetAll(_ sender: UIButton) {
        tableCollection = [(baseList, baseNames), (speakerList, [String]()), (doneList, [String]())]
        
        undoStack = [(Int, Int, Int, Int, String)]()
        
        // Reload tables
        baseList.reloadData()
        speakerList.reloadData()
        doneList.reloadData()
    }
 
    
/**
 * A storyboard button action.  The undo button was pressed.  The undo stack comprises an array of tuples.
 * Each tuple corresponds to an action of a name being moved. The tuple stores the name's position in the source table
 * and the name's position in the destination table.
 *
 * When the undo button is pressed, the last tuple in the array is popped off the array and the action reversed.
 */
    
    @IBAction func undoPressed(_ sender: UIButton) {
        
        let lastAction = undoStack.popLast()
        
        if lastAction != nil {
            
            // Break down the tuple
            let (table1Index, _, _, _, _) = lastAction!
            let (_, pos1, _, _, _) = lastAction!
            let (_, _, table2Index, _, _) = lastAction!
            let (_, _, _, pos2, _) = lastAction!
            let (_, _, _, _, name) = lastAction!
            
            // Remove it from table2 at pos2
            var (table2, nameList2) = tableCollection[table2Index]
            nameList2.remove(at: pos2)
            tableCollection[table2Index] = (table2, nameList2)
            
            // Return 'name' to 'table1' at position 'pos1'
            var (table1, nameList1) = tableCollection[table1Index]
            nameList1.insert(name, at: pos1)
            tableCollection[table1Index] = (table1, nameList1)
            
            // Reload data into tables
            baseList.reloadData()
            speakerList.reloadData()
            doneList.reloadData()
        }
    
    }
    
/**
 * A storyboard button action.  The button to show the large timer was pressed.
 * The large timer is displayed (or, if already displayed, is hidden - the button is a toggle)
 */
    
    @IBAction func showTimer(_ sender: UIButton) {
        if timerVisible == false {
            dimmerView.isHidden = false
            timerLabel.isHidden = false
            startButton.isHidden = false
            startButton.isEnabled = true
            pauseButton.isHidden = false
            pauseButton.isEnabled = true
            stopButton.isHidden = false
            stopButton.isEnabled = true
            timerVisible = true
            view.bringSubview(toFront: dimmerView)
            view.bringSubview(toFront: timerLabel)
            view.bringSubview(toFront: stackView)
            view.bringSubview(toFront: startButton)
            view.bringSubview(toFront: pauseButton)
            view.bringSubview(toFront: stopButton)
            showTimerButton.setTitle("Hide timer", for: .normal)
            
        } else {
            dimmerView.isHidden = true
            timerLabel.isHidden = true
            startButton.isHidden = true
            startButton.isEnabled = false
            pauseButton.isHidden = true
            pauseButton.isEnabled = false
            stopButton.isHidden = true
            stopButton.isEnabled = false
            timerVisible = false
            view.sendSubview(toBack:stackView)
            showTimerButton.setTitle("Show timer", for: .normal)
        }
    }
  
    
/**
 * A storyboard button action.  The large timer's start button was pressed.
 */
    
    @IBAction func startTimer(_ sender: UIButton) {
        handleStartTimer()
    }
   
    
/**
 * A storyboard button action.  The small timer's start button was pressed.
 */
    
    @IBAction func startSmTimer(_ sender: UIButton) {
        handleStartTimer()
    }

    
/**
 * A helper function.  Called when a timer's start button is pressed.
 * It resets the timer display and creates a new instance of a Timer class to fire at 1 second intervals.
 * On each fire, timerFireMethod(_: ) is called.
 */
    
    func handleStartTimer() {
        
        if pausePressed != true {
            startTime = Date()
            timerLabel.text = "00:00"
            smTimerLabel.text = "00:00"
            
        } else {
            
            // Reset pause toggle
            pausePressed = false
            
            // New start time is 'now' less the number seconds showing when paused
            startTime = Date() - TimeInterval(secondsElapsedWhenTimerPaused)
        }
        
        startButton.isEnabled = false
        stopButton.isEnabled = true
        pauseButton.isEnabled = true
        smStartButton.isEnabled = false
        smStopButton.isEnabled = true
        smPauseButton.isEnabled = true
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFireMethod(_: )), userInfo: nil, repeats: true )
    
    }
    
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        handlePauseTimer()
    }
    
    
    @IBAction func pauseSmTimer(_ sender: UIButton) {
        handlePauseTimer()
    }
 
    
/**
 * Called when either pause button is pressed
 */
    
    func handlePauseTimer() {
        
        // Set pause toggle
        pausePressed = true
        
        // Stop firing timer events
        timer?.invalidate()
        
        // Get seconds since timer started. Add this when restarting the timer so does not start from zero.
        secondsElapsedWhenTimerPaused = abs(Int(startTime!.timeIntervalSinceNow))
        
        // Re-enable start button and disable pause button
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        stopButton.isEnabled = true
        smStartButton.isEnabled = true
        smPauseButton.isEnabled = false
        smStopButton.isEnabled = true
    }
    
    
    
    @IBAction func stopTimer(_ sender: UIButton) {
        handleStopTimer()
    }
    
    
    @IBAction func stopSmTimer(_ sender: UIButton) {
        handleStopTimer()
    }
    
    /// Called when either stop button is pressed
    func handleStopTimer() {
        timer?.invalidate()
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        smStartButton.isEnabled = true
        smPauseButton.isEnabled = false
        smStopButton.isEnabled = false
    }
    
    
    @IBAction func reorderButton(_ sender: UIButton) {
        
        if reorderOn == false {
            speakerList.isEditing = true
            reorderOn = true
            baseList.isUserInteractionEnabled = false
            doneList.isUserInteractionEnabled = false
            for cell in speakerList.visibleCells {
                (cell as! WMTableViewCell).leftButton?.isHidden = true
                (cell as! WMTableViewCell).rightButton?.isHidden = true
                (cell as! WMTableViewCell).setNeedsUpdateConstraints()
            }
        } else {
            speakerList.isEditing = false
            reorderOn = false
            baseList.isUserInteractionEnabled = true
            doneList.isUserInteractionEnabled = true
            for cell in speakerList.visibleCells {
                (cell as! WMTableViewCell).leftButton?.isHidden = false
                (cell as! WMTableViewCell).rightButton?.isHidden = false
                (cell as! WMTableViewCell).setNeedsUpdateConstraints()
            }
        }
    }
    
    
    
    @IBAction func cancelUnwindAction(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    
    @IBAction func saveUnwindAction(unwindSegue: UIStoryboardSegue) {
        
        // Get any saved defaults
        let defaults = UserDefaults.standard
        if let currentMeeting = defaults.object(forKey: "CurrentMeeting") {
            baseNames = defaults.array(forKey: currentMeeting as! String) as! [String]
            meetingName.text = currentMeeting as? String
        }
        tableCollection = [(baseList, baseNames), (speakerList, [String]()), (doneList, [String]())]
        
        baseList.reloadData()
        speakerList.reloadData()
        doneList.reloadData()
        
        undoStack = [(Int, Int, Int, Int, String)]()
        
    }
    
    
    
    
    // MARK: - Properties
    
    /// Tables are stored as an array of 3 tuples.  Each tuple contains the UITableView reference and an array of members.
    var tableCollection = [(UITableView, [String])]()
    
    /// Stores the total list of members as presented initially in first table.  The default names are overwritten if user has saved a list to user defaults.
    var baseNames = ["Member1", "Member2", "Member3"]
    
    /// Tracks whether the timer is visible.
    var timerVisible = false
    
    /// A reference to the timer.
    var timer: Timer?
    
    /// Stores the start time after timer is started.
    var startTime: Date?
    
    /// Tracks the pause toggle
    var pausePressed = false
    
    /// Stores time when pause is pressed
    var secondsElapsedWhenTimerPaused = 0
    
    /// Tracks the reorder toggle on speaker list
    var reorderOn = false
    
    /// The undo stack is an array of tuples.  Each tuple holds the 'from' table index, the position of the name, the 'to' table index, position in table and name of member.
    var undoStack = [(Int, Int, Int, Int, String)]()
    
    /// A view controller to display the meeting chooser popover
    var meetingChooser: MeetingChooserViewController?
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Appearance tweaks
        smTimerBackground.layer.cornerRadius = 10
        meetingButton.layer.cornerRadius = 5
        editButton.layer.cornerRadius = 5
        undoButton.layer.cornerRadius = 5
        resetButton.layer.cornerRadius = 5
        showTimerButton.layer.cornerRadius = 5
        
        
        // Set self to supply datasources for table views
        baseList.dataSource = self
        speakerList.dataSource = self
        doneList.dataSource = self
        speakerList.delegate = self
        
        
        // At start up, hide timer views and ensure stackview is at back so does not intercept touches
        dimmerView.isHidden = true
        timerLabel.isHidden = true
        startButton.isHidden = true
        pauseButton.isHidden = true
        stopButton.isHidden = true
        view.sendSubview(toBack:stackView)
        
        
        // If iPad Pro 12.9" make adjustments to row height
        let iPadScreenWidth = self.view.frame.size.width
        if iPadScreenWidth > 1300 {
            baseList.rowHeight = UITableViewAutomaticDimension
            baseList.rowHeight = 60
            remainingLabel.font = UIFont(name: "Arial", size: 20)
            speakerList.rowHeight = 60
            speakerLabel.font = UIFont(name: "Arial", size: 20)
            doneList.rowHeight = 60
            doneLabel.font = UIFont(name: "Arial", size: 20)
        }
        
        
        // Get any saved defaults
        let defaults = UserDefaults.standard
        baseNames = [String]()
        if let currentMeeting = defaults.object(forKey: "CurrentMeeting") {
            if let namesArray = (defaults.array(forKey: currentMeeting as! String)) {
                baseNames = namesArray as! [String]
            }
            meetingName.text = currentMeeting as? String
        }
        
        // Initialise table collection
        tableCollection = [(baseList, baseNames), (speakerList, [String]()), (doneList, [String]())]
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: - UITableViewDataSource protocols
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Get the name array of the tableview.  The number of rows is equal to the number of names in the array.
        
        let tag = tableView.tag
        var (_, nameArray): (UITableView, [String])
        var numRows: Int?
        
        switch tag {
        case 1:
            (_,nameArray) = tableCollection[0]
            numRows = nameArray.count
        case 2:
            (_,nameArray) = tableCollection[1]
            numRows = nameArray.count
        case 3:
            (_,nameArray) = tableCollection[2]
            numRows = nameArray.count
        default:
            break
        }
        
        return numRows!
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // For the passed in table view, get the name array.  The name is found by using the passed-in index path row as the index for the array.
        
        var tvCell = WMTableViewCell()
        let tag = tableView.tag
        
        switch tag {
        case 1:
            var name = " "
            var (_,nameArray) = tableCollection[0]
            if nameArray.count > 0  {
                name = nameArray[indexPath.row]
            }
            tvCell = tableView.dequeueReusableCell(withIdentifier: "wmcell", for: indexPath) as! WMTableViewCell
            tvCell.memberText?.text = name
            if self.view.frame.size.width > 1300 {tvCell.memberText?.font = UIFont(name: "Arial", size: 28)} // if iPad Pro 12"
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            tvCell.addGestureRecognizer(swipeGesture)
        
        case 2:
            var name = " "
            var (_,nameArray) = tableCollection[1]
            if nameArray.count > 0  {
                name = nameArray[indexPath.row]
            }
            tvCell = (tableView.dequeueReusableCell(withIdentifier: "wmcell", for: indexPath) as? WMTableViewCell)!
            tvCell.memberText!.text = name
            if self.view.frame.size.width > 1300 {tvCell.memberText?.font = UIFont(name: "Arial", size: 28)} // if iPad Pro 12"
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            tvCell.addGestureRecognizer(swipeGesture)
            
        case 3:
            var name = " "
            var (_,nameArray) = tableCollection[2]
            if nameArray.count > 0  {
                name = nameArray[indexPath.row]
            }
            tvCell = (tableView.dequeueReusableCell(withIdentifier: "wmcell", for: indexPath) as? WMTableViewCell)!
            tvCell.memberText!.text = name
            if self.view.frame.size.width > 1300 {tvCell.memberText?.font = UIFont(name: "Arial", size: 28)} // if iPad Pro 12"
            
        default:
            break
        }
        
        return tvCell
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var (_, speakerNames) = tableCollection[1]
        let nameToMove = speakerNames.remove(at: sourceIndexPath.row)
        speakerNames.insert(nameToMove, at: destinationIndexPath.row)
        tableCollection[1] = (speakerList, speakerNames)
        
        // Update undo stack
        undoStack.append((1, sourceIndexPath.row, 1, destinationIndexPath.row, speakerNames[destinationIndexPath.row]))
    }
    
    
    // MARK: - UITableView delegate methods
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        // Don't want a delete or insert accessory
        return .none
        
    }
    
    
    // MARK: - MeetingChooserViewController delegate methods

/**
     MeetingChooserViewController delegate method, which is called when user selects a meeting using the meeting chooser.
     - parameter meetingName: The selected meeting name.
 */
    
     func didSelectMeeting(_ meetingName: String) {
        
        // Dismiss popover controller
        meetingChooser?.dismiss(animated: true, completion: nil)
        
        // Display name of meeting
        self.meetingName.text = meetingName
        
        // Update defaults for current meeting
        let defaults = UserDefaults.standard
        defaults.set(meetingName, forKey: "CurrentMeeting")
        
        // Reinitialise baseNames
        baseNames = [String]()
        
        // Get the members for this meeting (if members have been added to defaults)
        if let namesArray = (defaults.array(forKey: meetingName)) {
            baseNames = namesArray as! [String]
        }
        
        // Initialise table collection
        tableCollection = [(baseList, baseNames), (speakerList, [String]()), (doneList, [String]())]
        baseList.reloadData()
        speakerList.reloadData()
        doneList.reloadData()
    }

    
    
    // MARK: - Handle swipe gestures
    
    /// When cell is swiped, we get the member's name, remove it from current table and add it to next table
    func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        
        // Get reference to table cell
        let cell = recognizer.view! as! WMTableViewCell
        
        // Get reference to table and name list
        var currentTable: UITableView?
        var currentNames: [String]?
        var runningIndex = 0
        var foundIndex = 0
        for (table, list) in tableCollection {
            if cell.isDescendant(of: table) {
                currentTable = table
                currentNames = list
                foundIndex = runningIndex
            }
            runningIndex += 1
        }
        
        
        // Get member's name
        if let nameText = cell.memberText!.text {
        
            // Create temporary new array omitting member's name
            var tmpArray = [String]()
            var position = 0
            var counter = 0
            for item in currentNames! {
                if item != nameText {
                    tmpArray.append(item)
                    counter += 1
                } else {
                    position = counter
                }
            }
            
            // Set master array to new array
            tableCollection[foundIndex] = (currentTable!, tmpArray)
            var (nextTable, nextNameList) = tableCollection[foundIndex + 1]
            nextNameList.append(nameText)
            tableCollection[foundIndex + 1] = (nextTable, nextNameList)
            
            // Update undo stack
            undoStack.append((foundIndex, position,  foundIndex + 1, nextNameList.count - 1,nameText))

            
            // Reload tables
            baseList.reloadData()
            speakerList.reloadData()
            doneList.reloadData()
        }
    }
    
    

    
    
    // MARK: - Handle timer fires
    
/**
 * Called every time the timer fires (every second).  
 * Updates the timer displays.
 */
    
    func timerFireMethod(_ timer: Timer) {
       
        let secondsSinceStart: Int = abs(Int(startTime!.timeIntervalSinceNow))
        let minutes = secondsSinceStart / 60
        let seconds = secondsSinceStart - (minutes * 60)
        var secondsString = String(seconds)
        if secondsString.characters.count == 1 {
            secondsString = "0" + secondsString
        }
        var minutesString = String(minutes)
        if minutesString.characters.count == 1 {
            minutesString = "0" + minutesString
        }
        //print("\(minutesString) : \(secondsString)")
        timerLabel.text = "\(minutesString):\(secondsString)"
        smTimerLabel.text = "\(minutesString):\(secondsString)"
    }
    
    
    
    // MARK: - Helper methods
    
/**
     Moves a name from the passed-in table and appends it to the next table on the right.
     - parameters:
       - name: the name to move
       - index: the index of the table from which the name is moving
 */
    
    func moveNameRight(_ name: String, fromTableWithIndex index: Int) {
        
        // Current names
        let (currentTable, currentNames) = tableCollection[index]
        
        // Create temporary array omitting member's name
        var tmpArray = [String]()
        var position = 0
        var counter = 0
        for item in currentNames {
            if item != name {
                tmpArray.append(item)
                counter += 1
            } else {
                position = counter
            }
        }
        
        // Set current table's member names array to temporary array
        tableCollection[index] = (currentTable, tmpArray)
        
        // Append passed in name to table on right
        var (nextTable, nextNameList) = tableCollection[index + 1]
        nextNameList.append(name)
        tableCollection[index + 1] = (nextTable, nextNameList)
        
        // Update undo stack
        undoStack.append((index, position, index + 1, nextNameList.count - 1, name))
        
        // Reload tables
        baseList.reloadData()
        speakerList.reloadData()
        doneList.reloadData()
        
    }
    
}


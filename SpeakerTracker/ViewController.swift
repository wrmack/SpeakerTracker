//
//  ViewController.swift
//  SpeakerTracker
//
//  Created by Warwick on 29/07/16.
//  Copyright © 2016 Warwick McNaughton. All rights reserved.
//
//  Abstract:
//  Manages display of the three speaking lists and timer.  Calls EditListController for editing the member list for current meeting.
//  User defaults include:
//      Key: "MeetingNames"; Value: an array of names of all meeting names.
//      Key: a meeting name; Value: an array of the member names for that meeting.
//      Key: "CurrentMeeting"; Value: Name of current meeting


import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    // MARK: - Storyboard connections and actions
    
    // Storyboard connections
    
    @IBOutlet weak var meetingName: UILabel!
    @IBOutlet weak var baseList: UITableView!
    @IBOutlet weak var speakerList: UITableView!
    @IBOutlet weak var doneList: UITableView!
    @IBOutlet weak var dimmerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    
    // Storyboard actions
    
    @IBAction func showTimer(_ sender: UIButton) {
        if timerVisible == false {
            dimmerView.isHidden = false
            timerLabel.isHidden = false
            startButton.isHidden = false
            pauseButton.isHidden = false
            stopButton.isHidden = false
            timerVisible = true
            view.bringSubview(toFront: dimmerView)
            view.bringSubview(toFront: timerLabel)
            view.bringSubview(toFront: stackView)
            view.bringSubview(toFront: startButton)
            view.bringSubview(toFront: pauseButton)
            view.bringSubview(toFront: stopButton)
        } else {
            dimmerView.isHidden = true
            timerLabel.isHidden = true
            startButton.isHidden = true
            pauseButton.isHidden = true
            stopButton.isHidden = true
            timerVisible = false
        }
    }
    
    @IBAction func resetAll(_ sender: UIButton) {
        tableCollection = [(baseList, baseNames), (speakerList, [String]()), (doneList, [String]())]
        
        // Reload tables
        baseList.reloadData()
        speakerList.reloadData()
        doneList.reloadData()
    }
    
    
    
    
    @IBAction func startTimer(_ sender: UIButton) {
        
        if pausePressed != true {
            startTime = Date()
            timerLabel.text = "00:00"
        
        } else {
            
            // Reset pause toggle
            pausePressed = false
            
            // New start time is 'now' less the number seconds showing when paused
            startTime = Date() - TimeInterval(secondsElapsedWhenTimerPaused)
        }
        
        sender.isEnabled = false
        stopButton.isEnabled = true
        pauseButton.isEnabled = true
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFireMethod(_: )), userInfo: nil, repeats: true )
    }
    
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        
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
    }
    
    
    @IBAction func stopTimer(_ sender: UIButton) {
        timer?.invalidate()
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        sender.isEnabled = false
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
        
    }
    
    
    
    
    // MARK: - Properties
    
    var tableCollection = [(UITableView, [String])]()
    var baseNames = ["Member1", "Member2"]
    var timerVisible = false
    var timer: Timer?
    var startTime: Date?
    var pausePressed = false
    var secondsElapsedWhenTimerPaused = 0
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self to supply datasources for table views
        baseList.dataSource = self
        speakerList.dataSource = self
        doneList.dataSource = self
        speakerList.delegate = self
        
        
        // At start up, hide timer views
        dimmerView.isHidden = true
        timerLabel.isHidden = true
        startButton.isHidden = true
        pauseButton.isHidden = true
        stopButton.isHidden = true
        
        // Get any saved defaults
        let defaults = UserDefaults.standard
        if let currentMeeting = defaults.object(forKey: "CurrentMeeting") {
            baseNames = defaults.array(forKey: currentMeeting as! String) as! [String]
            meetingName.text = currentMeeting as? String
        }
        
        // Initialise table collection
        tableCollection = [(baseList, baseNames), (speakerList, [String]()), (doneList, [String]())]
        
        // Add long-press gestures to speakerlist table
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        speakerList.addGestureRecognizer(longPress)
        speakerList.addGestureRecognizer(tapGesture)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: - UITableViewDataSource protocols
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

        var tvCell: UITableViewCell?
        
        let tag = tableView.tag
        
        switch tag {
        case 1:
            var name = " "
            var (_,nameArray) = tableCollection[0]
            if nameArray.count > 0  {
                name = nameArray[indexPath.row]
            }
            tvCell = tableView.dequeueReusableCell(withIdentifier: "MyReuseIdentifier1", for: indexPath)
            tvCell?.textLabel!.text = name
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            tvCell?.addGestureRecognizer(swipeGesture)
        
        case 2:
            var name = " "
            var (_,nameArray) = tableCollection[1]
            if nameArray.count > 0  {
                name = nameArray[indexPath.row]
            }
            tvCell = tableView.dequeueReusableCell(withIdentifier: "MyReuseIdentifier2", for: indexPath)
            tvCell?.textLabel!.text = name
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
            tvCell?.addGestureRecognizer(swipeGesture)
            
        case 3:
            var name = " "
            var (_,nameArray) = tableCollection[2]
            if nameArray.count > 0  {
                name = nameArray[indexPath.row]
            }
            tvCell = tableView.dequeueReusableCell(withIdentifier: "MyReuseIdentifier3", for: indexPath)
            tvCell?.textLabel!.text = name
            
        default:
            break
        }
        
        return tvCell!
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    
    // MARK: - UITableView delegate methods
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {

            return .none
        
    }
    
    

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    

    
    
    
    // MARK: - Handle swipe and long press gestures
    
    /// When cell is swiped, we get the member's name, remove it from current table and add it to next table
    func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        
        // Get reference to table cell
        let cell = recognizer.view! as! UITableViewCell
        
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
        if let nameText = cell.textLabel!.text {
        
            // Create temporary new array omitting member's name
            var tmpArray = [String]()
            for item in currentNames! {
                if item != nameText {
                    tmpArray.append(item)
                }
            }
            
            // Set master array to new array
            tableCollection[foundIndex] = (currentTable!, tmpArray)
            var (nextTable, nextNameList) = tableCollection[foundIndex + 1]
            nextNameList.append(nameText)
            tableCollection[foundIndex + 1] = (nextTable, nextNameList)
            
            // Reload tables
            baseList.reloadData()
            speakerList.reloadData()
            doneList.reloadData()
        }
    }
    
    
    func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        speakerList.isEditing = true
    }
    
    
    
    func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        speakerList.isEditing = false
    }
    
    
    
    // MARK: - Handle timer fires
    
    /// This method is called every time the timer fires
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
    }
    
    
    // MARK: - Present edit list
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}


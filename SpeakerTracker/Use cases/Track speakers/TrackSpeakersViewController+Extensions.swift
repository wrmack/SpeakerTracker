//
//  TrackSpeakersViewController+Extensions.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 1/11/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//



/*
 Delegates and handlers
 
 */


import UIKit


extension TrackSpeakersViewController: UITableViewDataSource, UITableViewDelegate, DebateSectionHeaderViewDelegate {

    // MARK: - UITableViewDataSource protocols
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView.tag {
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return speakingTableNumberOfSections
        default:
            return 0
        }
    }
    
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tag = tableView.tag
        var numRows = 0
        
        switch tag {
        case 1:
            let nameDictionary = tableCollection[0].nameDictionary
            if let dictForSection = nameDictionary?[section] {
                numRows = dictForSection.count
            }
        case 2:
            let nameDictionary = tableCollection[1].nameDictionary 
            if let dictForSection = nameDictionary?[section] {
                numRows = dictForSection.count
            }
        case 3:
            if speakingTableSections[section]!.isCollapsed == false  { 
                let nameDictionary = tableCollection[2].nameDictionary
                if let dictForSection = nameDictionary?[section] {
                    numRows = dictForSection.count
                }
            }
        default:
            break
        }
        return numRows
    }
    
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var tvCell = tableView.dequeueReusableCell(withIdentifier: "wmcell", for: indexPath) as? WMTableViewCell
        if tvCell == nil {
            tvCell = WMTableViewCell(style: .default, reuseIdentifier: "wmcell")
        }
        
        let tag = tableView.tag
        
        switch tag {
        case 1:
            var name: String?
            var nameDictionary = tableCollection[0].nameDictionary
            if nameDictionary!.count > 0  {
                let memberNameWithTimeArray = nameDictionary![indexPath.section]
                let memberNameWithTime = memberNameWithTimeArray![indexPath.row]
                name = memberNameWithTime.name
            }
            tvCell?.memberText?.text = name
            if self.view.frame.size.width > 1300 {tvCell?.memberText?.font = UIFont(name: "Arial", size: 28)} // if iPad Pro 12"
            
        case 2:
            var name: String?
            var nameDictionary = tableCollection[1].nameDictionary
            if nameDictionary!.count > 0  {
                let memberNameWithTimeArray = nameDictionary![indexPath.section]
                let memberNameWithTime = memberNameWithTimeArray![indexPath.row]
                name = memberNameWithTime.name
            }
            tvCell?.memberText!.text = name
            if self.view.frame.size.width > 1300 {tvCell?.memberText?.font = UIFont(name: "Arial", size: 28)} // if iPad Pro 12"
            
        case 3:
            var name: String?
            var time: String?
            var nameDictionary = tableCollection[2].nameDictionary
            if nameDictionary!.count > 0  {
                let memberNameWithTimeArray = nameDictionary![indexPath.section]
                let memberNameWithTime = memberNameWithTimeArray![indexPath.row]
                name = memberNameWithTime.name
                time = memberNameWithTime.time
            }
            tvCell?.memberText!.text = name
            var spkrIndexPath: IndexPath?
            if speakerRecording != nil { 
                spkrIndexPath = IndexPath(row: (speakerRecording?.row)!, section: (speakerRecording?.section)!)
            }
            
            // If this cell is recording
            if spkrIndexPath != nil && spkrIndexPath == indexPath {
                tvCell!.rightButton!.titleLabel!.font = UIFont.systemFont(ofSize:14)
                tvCell!.rightButton!.setTitleColor(UIColor.red, for: .normal)
                tvCell?.leftButton?.isEnabled = false
            }
            else {
                // Start with all enabled and all with play button
                tvCell?.leftButton?.isEnabled = true
                tvCell?.rightButton?.isEnabled = true
                tvCell?.isUserInteractionEnabled = true
                tvCell?.selectionStyle = .none
                tvCell!.rightButton?.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
                tvCell!.rightButton?.setTitle("▶︎", for: .normal)
                tvCell!.rightButton!.titleLabel!.font = UIFont.systemFont(ofSize: 22)
            }
            // Someone is speaking but not this row, so disable left button of this row
            if speakerRecording != nil && spkrIndexPath != indexPath {
                tvCell?.leftButton?.isEnabled = false
                //tvCell?.rightButton?.isEnabled = false
            }
            // Disable buttons in all rows of sections prior to last section
            if indexPath.section < (speakingTableNumberOfSections - 1) {
                tvCell?.leftButton?.isEnabled = false
                tvCell?.rightButton?.isEnabled = false
                tvCell?.isUserInteractionEnabled = false
            }
            // If there is a time associated with the member for the row
            if time != nil {
                tvCell?.rightButton?.setTitle(time, for: .normal)
                tvCell!.rightButton!.titleLabel!.font = UIFont.systemFont(ofSize:14)
                tvCell!.rightButton!.setTitleColor(UIColor.red, for: .normal)
            }
            if self.view.frame.size.width > 1300 {tvCell?.memberText?.font = UIFont(name: "Arial", size: 28)} // if iPad Pro 12"
            
        default:
            break
        }
        
        return tvCell!
    }
    
    
    internal func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var waitingNameDictionary = tableCollection[1].nameDictionary
        let nameWithTimeToMove = waitingNameDictionary![sourceIndexPath.section]!.remove(at: sourceIndexPath.row)
        waitingNameDictionary![destinationIndexPath.section]!.insert(nameWithTimeToMove, at: destinationIndexPath.row)
        tableCollection[1].nameDictionary = waitingNameDictionary
    }
    
    // MARK: - UITableView delegate methods
    
    internal func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        // Don't want a delete or insert accessory
        return .none
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 3 {
            var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DebateSectionHeaderView") as? DebateSectionHeaderView
            if header == nil {
                header = DebateSectionHeaderView(reuseIdentifier: "DebateSectionHeaderView")
            }
            header?.notesButton?.isHidden = true
            if speakingTableSections[section]!.isAmendment == true {
                header!.debateSectionLabel?.text = "Amendment debate"
                header!.disclosureButton!.isHidden = false
                if speakingTableSections[section]!.isCollapsed == true {
                    header?.disclosureButton?.setTitle("▹", for: .normal)
                }
                else {
                    header?.disclosureButton?.setTitle("▹", for: .normal)
                    header!.disclosureButton?.titleLabel?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                }
            }
            else {
                header!.debateSectionLabel?.text = "Main debate"
                header?.disclosureButton?.isHidden = true
                if eventRecordingIsOn == true {
                    if let debate = getCurrentDebate() {
                        let debateNumber = debate.debateNumber
                        header!.debateSectionLabel?.text = "Debate \(debateNumber!)"
                    }
                    if section == 0 {
                        header?.notesButton?.isHidden = false
                    }
                }
            }
            header?.delegate = self
            header?.sectionNumber = section
            return header
        }
        return nil
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 3 {
            return 32
        }
        return 0
    }
    
    
    // MARK: - DebateSectionHeaderViewDelegate methods
    
    internal func amendmentDisclosureButtonPressed(section: Int) {
        let header = speakingTable.headerView(forSection: section) as! DebateSectionHeaderView
        if speakingTableSections[section]!.isCollapsed == false {
            speakingTableSections[section]!.isCollapsed = true
            header.disclosureButton?.titleLabel?.rotate(0)
            speakingTable.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        }
        else if speakingTableSections[section]!.isCollapsed == true {
            speakingTableSections[section]!.isCollapsed = false
            header.disclosureButton?.titleLabel?.rotate(.pi/2)
            speakingTable.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        }
    }
    
    internal func pencilButtonPressed() {
        router!.routeToAddNoteToDebate()
    }
    
    
    // MARK: - Handle gestures
    
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    
    /// Get the member's name and index of table that was swiped and pass to functions to move name left or right.
    @objc internal func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        guard recognizer.view is UITableView else { return }
        var currentTable: UITableView?
        var tableIndex = 0
        
        switch recognizer.view!.tag {
        case 1:
            guard recognizer.direction == .right else { return }
            currentTable = remainingTable
            tableIndex = 0
        case 2:
            currentTable = waitingTable
            tableIndex = 1
        case 3:
            guard recognizer.direction == .left else { return }
            currentTable = speakingTable
            tableIndex = 2
        default:
            currentTable = nil
        }
        
        let swipeLocation = recognizer.location(in: currentTable)
        guard let swipedIndexPath = currentTable?.indexPathForRow(at: swipeLocation)  else { return }
        if recognizer.direction == .left {
            moveNameLeft(from: TablePosition(tableIndex: tableIndex, tableSection: swipedIndexPath.section, tableRow: swipedIndexPath.row))
        }
        if recognizer.direction == .right {
            moveNameRight(from: TablePosition(tableIndex: tableIndex, tableSection: swipedIndexPath.section, tableRow: swipedIndexPath.row))
        }
    }
    
    
    @objc internal func handleLongPressGesture(_ recognizer: UILongPressGestureRecognizer) {
        becomeFirstResponder()
        let pressLocation = recognizer.location(in: speakingTable)
        guard let pressIndexPath = speakingTable?.indexPathForRow(at: pressLocation)  else { return }
        let cell = speakingTable.cellForRow(at: pressIndexPath)
        let menuController = UIMenuController.shared
        menuController.setTargetRect((cell?.contentView.frame)!, in: (cell?.contentView)!)
        var item: UIMenuItem?
        if pressIndexPath.section == 0 && pressIndexPath.row == 0 {
            longPressTablePosition = TablePosition(tableIndex: 2, tableSection: 0, tableRow: 0)
            menuController.arrowDirection = .up
            item = UIMenuItem(title: "Exercises right of reply", action: #selector(exerciseRightOfReply))
            menuController.menuItems = [item!]
            menuController.setMenuVisible(true, animated: true)
        }
        let nameDictionary = tableCollection[2].nameDictionary
        if debateMode == .mainMotion {
            if pressIndexPath.row == nameDictionary![pressIndexPath.section]!.count - 1 {
                item = UIMenuItem(title: "Moves amendment", action: #selector(moveAmendment))
                menuController.menuItems = [item!]
                menuController.setMenuVisible(true, animated: true)
            }
        }
        if debateMode == .amendment {
            if pressIndexPath.row == nameDictionary![pressIndexPath.section]!.count - 1 {
                item = UIMenuItem(title: "Final speaker for amendment", action: #selector(closeAmendment))
                menuController.menuItems = [item!]
                menuController.setMenuVisible(true, animated: true)
            }
        }
    }
    
    
    @objc private func exerciseRightOfReply() {
        copyNameToEnd(from: longPressTablePosition!)
    }
    
    @objc private func moveAmendment() {
        beginAmendment()
    }
    
    @objc private func closeAmendment() {
        endAmendment()
    }
    
    
    // MARK: - Timer handlers
    
    /**
     * Called every time the timer fires (every second).
     * Updates the timer displays.
     */
    
    @objc private func timerFireMethod(_ timer: Timer) {
        
        let secondsSinceStart: Int = abs(Int(startTime!.timeIntervalSinceNow))
        let minutes = secondsSinceStart / 60
        let seconds = secondsSinceStart - (minutes * 60)
        let secondsString = String(format: "%02d", seconds)
        let minutesString = String(format: "%02d", minutes)
        timerLabel.text = "\(minutesString):\(secondsString)"
        smTimerLabel.text = "\(minutesString):\(secondsString)"
        speakerRecording!.button?.setTitle("\(minutesString):\(secondsString)", for: .normal)
    }
    
    
    /**
     Called when a timer's start button is pressed.
     It resets the timer display and creates a new instance of a Timer class to fire at 1 second intervals.
     On each fire, timerFireMethod(_: ) is called.
     Note: either create a timer using Timer.scheduledTimer(), which will be automatically added to runloop or Time() and add to runloop.
     https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
     */
    
    internal func handleStartTimer() {
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
        
        timer?.invalidate()
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerFireMethod(_: )), userInfo: nil, repeats: true )
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    
    /**
     Called when either pause button is pressed
     */
    
    internal func handlePauseTimer() {
        
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
    
    
    /// Called when either stop button is pressed
    internal func handleStopTimer() -> Int {
        timer?.invalidate()
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        smStartButton.isEnabled = true
        smPauseButton.isEnabled = false
        smStopButton.isEnabled = false
        let speakingTime = abs(Int(startTime!.timeIntervalSinceNow))
        return speakingTime
    }
}

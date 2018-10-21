//
//  TrackSpeakersViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 14/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TrackSpeakersDisplayLogic: class {
    func displayNames(viewModel: TrackSpeakers.Speakers.ViewModel)
}




class TrackSpeakersViewController: UIViewController, TrackSpeakersDisplayLogic,  UITableViewDelegate, UITableViewDataSource, EntitiesPopUpViewControllerDelegate, MeetingGroupsPopUpViewControllerDelegate, EventsPopUpViewControllerDelegate  {
    
    var interactor: TrackSpeakersBusinessLogic?
    var router: (NSObjectProtocol & TrackSpeakersRoutingLogic & TrackSpeakersDataPassing)?

    // MARK: - Properties
    
    /// Tables are stored as an array of 3 tuples.  Each tuple contains the UITableView reference and an array of members' names.
    var tableCollection = [(UITableView, [String])]()
    
    /// Stores the total list of members as presented initially in first table.  The default names are overwritten if user has saved a list to user defaults.
    var baseNames = [String?]()
    
    /// Tracks whether the timer is visible.
    var timerVisible = false
    
    /// A reference to the timer.
    var timer: Timer?
    
    /// Stores the start time when timer is started.
    var startTime: Date?
    
    /// Tracks the pause toggle
    var pausePressed = false
    
    /// Stores time when pause is pressed
    var secondsElapsedWhenTimerPaused = 0
    
    /// Tracks the reorder toggle on speaker list
    var reorderOn = false
    
    /// The undo stack is an array of tuples.  Each tuple holds: source table index, name position in source table, destination table index, name position in destination table and name of member.
    var undoStack = [(Int, Int, Int, Int, String)]()
    
    var speakerRecording = SpeakerRecording(row: nil, button: nil)
    
    var sideBarIsHidden = true
    
    var eventRecordingIsOn = false

    // MARK: - Storyboard outlets

    // MARK: Table views
    /// There are three table views with lists of speakers.  This is the left table view, containing the starting list of names.
    @IBOutlet weak var baseList: UITableView!
    
    /// There are three table views with lists of speakers.  This is the middle table view, containing the list of those wanting to speak.
    @IBOutlet weak var speakerList: UITableView!
    
    /// There are three table views with lists of speakers.  This is the right table view, containing the speaker and the list of those who have spoken.
    @IBOutlet weak var doneList: UITableView!
    
    // References to labels for purposes of tweaking appearance
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var speakerLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!

    
    // MARK: Timer buttons and labels
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var smTimerLabel: UILabel!
    @IBOutlet weak var smStartButton: UIButton!
    @IBOutlet weak var smPauseButton: UIButton!
    @IBOutlet weak var smStopButton: UIButton!
    
    // The view that dims the background when the large timer is displayed
    @IBOutlet weak var dimmerView: UIView!
    
    /// Holds start, pause and stop buttons for large timer
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: Buttons on right side of screen
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!    
    @IBOutlet weak var recordingOnLabel: UILabel!
    
    // MARK: Sidebar, views and buttons
    @IBOutlet weak var sideBarView: UIView!
    @IBOutlet weak var sideBarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var disclosureSideBarButtonView: UIView!
    @IBOutlet weak var discloseSideBarButton: UIButton!
    @IBOutlet weak var selectEntityButton: UIButton!
    @IBOutlet weak var selectMeetingGroupButton: UIButton!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var recordSwitch: UISwitch!
    @IBOutlet weak var selectEventButton: UIButton!
    @IBOutlet weak var debateNote: UITextField!
    @IBOutlet weak var meetingGroupLabel: UILabel!
    
    
    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit {
        print("TrackSpeakersViewController deinitialising")
    }
    
    
    // MARK: - Setup

    private func setup() {
        let viewController = self
        let interactor = TrackSpeakersInteractor()
        let presenter = TrackSpeakersPresenter()
        let router = TrackSpeakersRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Appearance tweaks
        undoButton.layer.cornerRadius = 2
        resetButton.layer.cornerRadius = 2
        disclosureSideBarButtonView.layer.cornerRadius = 10
        disclosureSideBarButtonView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        selectEntityButton.layer.cornerRadius = 10
        selectEntityButton.layer.masksToBounds = true
        selectMeetingGroupButton.layer.cornerRadius = 10
        selectMeetingGroupButton.layer.masksToBounds = true
        selectEventButton.layer.cornerRadius = 10
        selectEventButton.layer.masksToBounds = true
        
        // Set datasource and delegate for table views
        baseList.dataSource = self
        speakerList.dataSource = self
        doneList.dataSource = self
        speakerList.delegate = self
        
        
        // At start up, hide timer views, ensure stackview is at back so does not intercept touches, hide sidebar and the view containing the event selectors
        dimmerView.isHidden = true
        timerLabel.isHidden = true
        startButton.isHidden = true
        pauseButton.isHidden = true
        stopButton.isHidden = true
        view.sendSubview(toBack:stackView)
        sideBarLeadingConstraint.constant = -370
        eventView.isHidden = true
        
        
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
        

        selectMeetingGroupButton.isEnabled = (selectEntityButton.titleLabel?.text == "Select an entity") ? false : true
        recordSwitch.isEnabled = (selectMeetingGroupButton.titleLabel?.text == "Select a meeting group") ? false : true
        
        fetchNames()
        
        let swipeGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture1.direction = .right
        self.baseList.addGestureRecognizer(swipeGesture1)
        
        let swipeGesture2a = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture2a.direction = .left
        let swipeGesture2b = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture2b.direction = .right
        self.speakerList.addGestureRecognizer(swipeGesture2a)
        self.speakerList.addGestureRecognizer(swipeGesture2b)
        
        let swipeGesture3 = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture3.direction = .left
        self.doneList.addGestureRecognizer(swipeGesture3)
        
    }
    
    
    /*
     Adjust tab bar of original UITabBarController once views have loaded
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tabBarCont = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        let tabBarRect = tabBarCont.tabBar.frame
        tabBarCont.tabBar.frame = CGRect(x: view.frame.origin.x, y: tabBarRect.origin.y, width: view.frame.size.width, height: tabBarRect.size.height)
        
        // Get stored entities and meeting groups from user defaults
        if let entity = UserDefaultsManager.getCurrentEntity() {
            selectEntityButton.setTitle(entity.name, for: .normal)
            selectEntityButton.setTitleColor(UIColor.white, for: .normal)
            setCurrentEntity(entity: entity)
            selectMeetingGroupButton.isEnabled = true
        }
        if let meetingGroup = UserDefaultsManager.getCurrentMeetingGroup() {
            let checkIfBelongsToEntity = meetingGroupBelongsToCurrentEntity(meetingGroup: meetingGroup)
            if checkIfBelongsToEntity {
                selectMeetingGroupButton.setTitle(meetingGroup.name, for: .normal)
                selectMeetingGroupButton.setTitleColor(UIColor.white, for: .normal)
                setCurrentMeetingGroup(meetingGroup: meetingGroup)
                meetingGroupLabel.text = meetingGroup.name
                meetingGroupLabel.textColor = UIColor(white: 0.94, alpha: 1.0)
                recordSwitch.isEnabled = true
            }
            else {
                selectMeetingGroupButton.setTitle("", for: .normal)
                meetingGroupLabel.text = "〈  Select a meeting group in side-bar"
            }
            fetchNames()
        }
    }
    
    
    // MARK: - Storyboard actions
    
    // MARK: Sidebar buttons
    @IBAction func discloseSideBarPressed(_ sender: UIButton) {
        if sideBarIsHidden == true {
            sideBarIsHidden = false
            sender.setTitle("◀︎", for: .normal)
            UIView.animate(withDuration: 1.0, animations: {
                self.sideBarLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        else {
            sideBarIsHidden = true
            sender.setTitle("▶︎", for: .normal)
            UIView.animate(withDuration: 1.0, animations: {
                self.sideBarLeadingConstraint.constant = -370
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func selectEntityPressed(_ button: UIButton) {
        let entityPopUpController = DisplayEntitiesPopUpViewController(nibName: nil, bundle: nil)
        entityPopUpController.modalPresentationStyle = .popover
        present(entityPopUpController, animated: true, completion: nil)
        
        let popoverController = entityPopUpController.popoverPresentationController
        popoverController!.delegate = self as? UIPopoverPresentationControllerDelegate
        popoverController!.sourceView = button.superview!
        popoverController!.sourceRect =  CGRect(x: button.frame.origin.x, y: button.frame.origin.y, width: 300, height: button.frame.size.height)
        popoverController!.permittedArrowDirections = .up
        entityPopUpController.delegate = self
        entityPopUpController.reloadData()
    }
    
    @IBAction func selectMeetingGroupPressed(_ sender: UIButton) {
        let currentEntity = getCurrentEntity()
        if currentEntity == nil {
            let alert = UIAlertController(title: "Meeting group not found", message: "Select an entity first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let meetingGroupPopUpController = DisplayMeetingGroupsPopUpViewController(entity: currentEntity!)
            meetingGroupPopUpController.modalPresentationStyle = .popover
            present(meetingGroupPopUpController, animated: true, completion: nil)
            
            let popoverController = meetingGroupPopUpController.popoverPresentationController
            popoverController!.delegate = self as? UIPopoverPresentationControllerDelegate
            popoverController!.sourceView = sender.superview!
            popoverController!.sourceRect =  CGRect(x: sender.frame.origin.x, y: sender.frame.origin.y, width: 300, height: sender.frame.size.height)
            popoverController!.permittedArrowDirections = .up
            meetingGroupPopUpController.delegate = self
        }
    }
    
    
    @IBAction func selectEventPressed(_ button: UIButton) {
        let entity = getCurrentEntity()
        let meetingGroup = getCurrentMeetingGroup()
        let eventPopUpController = DisplayEventsPopUpViewController(entity: entity!, meetingGroup: meetingGroup!)
        eventPopUpController.modalPresentationStyle = .popover
        present(eventPopUpController, animated: true, completion: nil)
        
        let popoverController = eventPopUpController.popoverPresentationController
        popoverController!.delegate = self as? UIPopoverPresentationControllerDelegate
        popoverController!.sourceView = button.superview!
        popoverController!.sourceRect = button.frame
        popoverController!.permittedArrowDirections = .any
        eventPopUpController.delegate = self
    }
    
    
    @IBAction func recordSwitchPressed(_ sender: UISwitch) {
        if sender.isOn == true {
            eventView.isHidden = false
        }
        else {
            eventView.isHidden = true
            recordingOnLabel.textColor = UIColor.darkGray
            eventRecordingIsOn = false
            addCurrentDebateToEvent()
        }
    }
    
    
    // MARK: Table view row buttons
    
    /**
     A storyboard button action.  The right button on a base-list table row was pressed.
     Gets name of member and passes this to helper function which moves name to table on right.
     */
        
    @IBAction func baseRightButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: baseList)
        let index = baseList.indexPathForRow(at: pointInTable!)
        moveNameRight(from: TablePosition(tableIndex: 0, tableRow: index?.row))
    }
    
    
    /**
     * A storyboard button action.  The left button on a speaker-list table row was pressed.
     * Gets name of member and passes this to helper function which moves name to table on left.
     */
    
    
    @IBAction func speakerLeftButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: speakerList)
        let index = speakerList.indexPathForRow(at: pointInTable!)
        moveNameLeft(from: TablePosition(tableIndex: 1, tableRow: index?.row))
    }
    
    
    /**
     * A storyboard button action.  The right button on a speaker-list table row was pressed.
     * Gets name of member and passes this to helper function which moves name to table on right.
     */
    
    @IBAction func speakerRightButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: speakerList)
        let index = speakerList.indexPathForRow(at: pointInTable!)
        moveNameRight(from: TablePosition(tableIndex: 1, tableRow: index?.row))
    }
    
    
    /**
     * A storyboard button action.  The left button on a done-list table row was pressed.
     * Gets name of member and passes this to helper function which moves name to table on left.
     */
    
    @IBAction func doneLeftButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: doneList)
        let index = doneList.indexPathForRow(at: pointInTable!)
        if speakerRecording.row == index!.row {
            _ = handleStopTimer()
        }
        let cell = doneList.cellForRow(at: index!) as! WMTableViewCell
        cell.rightButton?.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
        cell.rightButton?.setTitle("▶︎", for: .normal)
        cell.rightButton!.titleLabel!.font = UIFont.systemFont(ofSize: 22)
        moveNameLeft(from: TablePosition(tableIndex: 2, tableRow: index?.row))
    }
    
    /*
     If current speaker is on different row:
     - turn off current speaker if still speaking (check status of start button)
     - start timer for this speaker.
     If current speaker is this speaker:
     - stop this speaker
     */
    @IBAction func doneRightButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {

        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: doneList)
        let index = doneList.indexPathForRow(at: pointInTable!)
        if speakerRecording.row != index!.row {
            if smStartButton.isEnabled == false {
                _ = handleStopTimer()
            }
            speakerRecording.row = index?.row
            speakerRecording.button = sender
            sender.setTitleColor(UIColor.red, for: .normal)
            sender.setTitle("00:00", for: .normal)
            sender.titleLabel!.font = UIFont.systemFont(ofSize:14)
            handleStartTimer()
            setCurrentSpeaker(row: index!.row)
        }
        else {
            if smStartButton.isEnabled == false {
                _ = handleStopTimer()
            }
            speakerRecording = SpeakerRecording(row: nil, button: nil)
        }
    }
    
    @IBAction func reorderButton(_ sender: UIButton) {
        
        if reorderOn == false {
            let (_, speakerArray) = tableCollection[1]
            if speakerArray.count > 1 {
                speakerList.isEditing = true
                reorderOn = true
                sender.tintColor = UIColor(red: 0.6, green: 0.6, blue: 1.0, alpha: 1.0)
                baseList.isUserInteractionEnabled = false
                doneList.isUserInteractionEnabled = false
                for cell in speakerList.visibleCells {
                    (cell as! WMTableViewCell).leftButton?.isHidden = true
                    (cell as! WMTableViewCell).rightButton?.isHidden = true
                    (cell as! WMTableViewCell).setNeedsUpdateConstraints()
                }
            }
        } else {
            speakerList.isEditing = false
            reorderOn = false
            sender.tintColor = UIColor.lightGray
            baseList.isUserInteractionEnabled = true
            doneList.isUserInteractionEnabled = true
            for cell in speakerList.visibleCells {
                (cell as! WMTableViewCell).leftButton?.isHidden = false
                (cell as! WMTableViewCell).rightButton?.isHidden = false
                (cell as! WMTableViewCell).setNeedsUpdateConstraints()
            }
        }
    }
    
    
    // MARK: Controls
    
    /**
     Resets all lists and the undo stack.
     */
    
    @IBAction func resetAll(_ sender: UIButton) {
        var (_, nameArray): (UITableView, [String])
        (_,nameArray) = tableCollection[2]
        let numRows = nameArray.count
        for row in 0..<numRows {
            let cell = doneList.cellForRow(at: IndexPath(row: row, section: 0)) as! WMTableViewCell
            cell.rightButton?.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1.0, alpha: 1.0), for: .normal)
            cell.rightButton?.setTitle("▶︎", for: .normal)
            cell.rightButton!.titleLabel!.font = UIFont.systemFont(ofSize: 22)
        }
        if smStartButton.isEnabled == false {
            _ = handleStopTimer()
        }
        resetAllNames()
        if eventRecordingIsOn == true {
            addCurrentDebateToEvent()
        }
    }
    
    
    /**
     A storyboard button action:  the undo button was pressed.
     
     The undo stack comprises an array of tuples.
     Each tuple holds: source table index, name position in source table, destination table index, name position in destination table and name of member.
     
     When the undo button is pressed, the last tuple in the array is popped off the array and the action reversed.
     */
    
    @IBAction func undoPressed(_ sender: UIButton) {
        undoLastAction()
    }
    
    
    // MARK: Timer buttons
    /**
     * A storyboard button action.  When the button is pressed, the large timer is toggled on and off.
     */
    @IBAction func showLargeTimer(_ sender: UIButton) {
        
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
            expandButton.setImage(UIImage(named: "shrink2"), for: .normal)
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
            expandButton.setImage(UIImage(named: "expand2"), for: .normal)
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
    
    @IBAction func pauseTimer(_ sender: UIButton) {
        handlePauseTimer()
    }
    
    @IBAction func pauseSmTimer(_ sender: UIButton) {
        handlePauseTimer()
    }
    
    @IBAction func stopTimer(_ sender: UIButton) {
        _ = handleStopTimer()
    }
    
    @IBAction func stopSmTimer(_ sender: UIButton) {
        _ = handleStopTimer()
    }
    
    
    // MARK: - Datastore

    func setCurrentEntity(entity: Entity) {
         interactor?.setCurrentEntity(entity: entity)
    }
    
    func getCurrentEntity() -> Entity? {
        return interactor!.getCurrentEntity()
    }
    
    func setCurrentMeetingGroup(meetingGroup: MeetingGroup) {
        interactor?.setCurrentMeetingGroup(meetingGroup: meetingGroup)
    }
    
    func getCurrentMeetingGroup()-> MeetingGroup? {
        return interactor?.getCurrentMeetingGroup()
    }
    
    func meetingGroupBelongsToCurrentEntity(meetingGroup: MeetingGroup) -> Bool {
        return interactor!.meetingGroupBelongsToCurrentEntity(meetingGroup: meetingGroup)
    }

    func setCurrentSpeaker(row: Int) {
        interactor!.setCurrentSpeaker(row: row)
    }
    
    func addCurrentSpeakerToDebate(debateNote: String, startTime: Date, speakingTime: Int) {
        interactor!.addCurrentSpeakerToDebate(debateNote: debateNote, startTime: startTime, speakingTime: speakingTime)
    }
    
    func setCurrentEvent(event: Event?) {
        interactor!.setCurrentEvent(event: event)
    }
    
    func addCurrentDebateToEvent() {
        interactor?.addCurrentDebateToEvent()
    }
    
    
    // MARK: - VIP
    
    func fetchNames() {
        interactor!.fetchNames()
    }
    
    func moveNameRight(from tablePosition: TablePosition ) {
        interactor!.moveNameRight(from: tablePosition)
    }
    
    func moveNameLeft(from tablePosition: TablePosition ) {
        interactor!.moveNameLeft(from: tablePosition) 
    }
    
    func resetAllNames() {
        interactor!.resetAllNames()
    }
    
    func undoLastAction() {
        interactor!.undoLastAction()
    }
    
    func displayNames(viewModel: TrackSpeakers.Speakers.ViewModel) {
        tableCollection = [(baseList, viewModel.baseNames!), (speakerList, viewModel.speakerNames!), (doneList, viewModel.doneNames!)]
        baseList.reloadData()
        speakerList.reloadData()
        doneList.reloadData()
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
        
        var tvCell = tableView.dequeueReusableCell(withIdentifier: "wmcell", for: indexPath) as? WMTableViewCell
        if tvCell == nil {
            tvCell = WMTableViewCell(style: .default, reuseIdentifier: "wmcell")
        }
        
        let tag = tableView.tag
        
        switch tag {
        case 1:
            var name = ""
            var (_,nameArray) = tableCollection[0]
            if nameArray.count > 0  {
                name = nameArray[indexPath.row]
            }
            tvCell!.isDoneListCell = false
            tvCell?.memberText?.text = name
            if self.view.frame.size.width > 1300 {tvCell?.memberText?.font = UIFont(name: "Arial", size: 28)} // if iPad Pro 12"
            
        case 2:
            var name = ""
            var (_,nameArray) = tableCollection[1]
            if nameArray.count > 0  {
                name = nameArray[indexPath.row]
            }
            tvCell!.isDoneListCell = false
            tvCell?.memberText!.text = name
            if self.view.frame.size.width > 1300 {tvCell?.memberText?.font = UIFont(name: "Arial", size: 28)} // if iPad Pro 12"
            
        case 3:
            var name = ""
            var (_,nameArray) = tableCollection[2]
            if nameArray.count > 0  {
                name = nameArray[indexPath.row]
            }
            tvCell!.isDoneListCell = true
            tvCell?.memberText!.text = name
            if self.view.frame.size.width > 1300 {tvCell?.memberText?.font = UIFont(name: "Arial", size: 28)} // if iPad Pro 12"
            
        default:
            break
        }
        
        return tvCell!
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var (_, speakerNames) = tableCollection[1]
        let nameToMove = speakerNames.remove(at: sourceIndexPath.row)
        speakerNames.insert(nameToMove, at: destinationIndexPath.row)
        tableCollection[1] = (speakerList, speakerNames)
        
        undoStack.append((1, sourceIndexPath.row, 1, destinationIndexPath.row, speakerNames[destinationIndexPath.row]))
        if undoStack.count > 10 {
            let newStack = Array(undoStack.dropFirst())
            undoStack = newStack
        }
    }
    
    
    // MARK: - UITableView delegate methods
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        // Don't want a delete or insert accessory
        return .none
        
    }
    
    
    // MARK: - EntitiesPopUpViewControllerDelegate methods
    
    func didSelectEntityInPopUpViewController(_ viewController: DisplayEntitiesPopUpViewController, entity: Entity) {
        dismiss(animated: false, completion: nil)
        selectEntityButton.setTitle(entity.name, for: .normal)
        selectEntityButton.setTitleColor(UIColor.white, for: .normal)
        selectEntityButton.titleLabel?.textAlignment = .left
        selectMeetingGroupButton.isEnabled = true
        setCurrentEntity(entity: entity)
    }
    
    
    // MARK: - MeetingGroupsPopUpViewControllerDelegate methods
    
    func didSelectMeetingGroupInPopUpViewController(_ viewController: DisplayMeetingGroupsPopUpViewController, meetingGroup: MeetingGroup) {
        dismiss(animated: false, completion: nil)
        selectMeetingGroupButton.setTitle(meetingGroup.name, for: .normal)
        selectMeetingGroupButton.setTitleColor(UIColor.white, for: .normal)
        selectMeetingGroupButton.titleLabel?.textAlignment = .left
        setCurrentMeetingGroup(meetingGroup: meetingGroup)
        recordSwitch.isEnabled = true
        meetingGroupLabel.text = meetingGroup.name
        meetingGroupLabel.textColor = UIColor(white: 0.94, alpha: 1.0)
        fetchNames()
        let defaults = UserDefaults.standard
        let entity = getCurrentEntity()
        let encodedEntity = try? JSONEncoder().encode(entity)
        defaults.set(encodedEntity, forKey: "CurrentEntity")
        let encodedMeetingGroup = try? JSONEncoder().encode(meetingGroup)
        defaults.set(encodedMeetingGroup, forKey: "CurrentMeetingGroup")
    }
    
    
    // MARK: - EventsPopUpViewControllerDelegate methods
    
    func didSelectEventInPopUpViewController(_ viewController: DisplayEventsPopUpViewController, event: Event) {
        dismiss(animated: false, completion: nil)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: event.date!)
        selectEventButton.setTitle(dateString, for: .normal)
        selectEventButton.setTitleColor(UIColor.white, for: .normal)
        selectEventButton.titleLabel?.textAlignment = .left
        setCurrentEvent(event: event)
        recordingOnLabel.textColor = UIColor.red
        eventRecordingIsOn = true
    }
    
    
    // MARK: - Handle swipe gestures
    
    /// Get the member's name and index of table that was swiped and pass to functions to move name left or right.
    @objc func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        guard recognizer.view is UITableView else { return }
        var currentTable: UITableView?
        var tableIndex = 0
        
        switch recognizer.view!.tag {
        case 1:
            guard recognizer.direction == .right else { return }
            currentTable = baseList
            tableIndex = 0
        case 2:
            currentTable = speakerList
            tableIndex = 1
        case 3:
            guard recognizer.direction == .left else { return }
            currentTable = doneList
            tableIndex = 2
        default:
            currentTable = nil
        }
        
        let swipeLocation = recognizer.location(in: currentTable)
        guard let swipedIndexPath = currentTable?.indexPathForRow(at: swipeLocation)  else { return }
        if recognizer.direction == .left {
            moveNameLeft(from: TablePosition(tableIndex: tableIndex, tableRow: swipedIndexPath.row))
        }
        if recognizer.direction == .right {
            moveNameRight(from: TablePosition(tableIndex: tableIndex, tableRow: swipedIndexPath.row))
        }
    }
    
    
    // MARK: - Timer handlers
    
    /**
     * Called every time the timer fires (every second).
     * Updates the timer displays.
     */
    
    @objc func timerFireMethod(_ timer: Timer) {
        
        let secondsSinceStart: Int = abs(Int(startTime!.timeIntervalSinceNow))
        let minutes = secondsSinceStart / 60
        let seconds = secondsSinceStart - (minutes * 60)
        var secondsString = String(seconds)
        if secondsString.count == 1 {
            secondsString = "0" + secondsString
        }
        var minutesString = String(minutes)
        if minutesString.count == 1 {
            minutesString = "0" + minutesString
        }
        timerLabel.text = "\(minutesString):\(secondsString)"
        smTimerLabel.text = "\(minutesString):\(secondsString)"
        speakerRecording.button?.setTitle("\(minutesString):\(secondsString)", for: .normal)
    }
    
    
    /**
     Called when a timer's start button is pressed.
     It resets the timer display and creates a new instance of a Timer class to fire at 1 second intervals.
     On each fire, timerFireMethod(_: ) is called.
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
    
    
    /**
     Called when either pause button is pressed
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
    
    
    /// Called when either stop button is pressed
    func handleStopTimer() -> Int {
        timer?.invalidate()
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        smStartButton.isEnabled = true
        smPauseButton.isEnabled = false
        smStopButton.isEnabled = false
        let speakingTime = abs(Int(startTime!.timeIntervalSinceNow))
        if eventRecordingIsOn == true {
            addCurrentSpeakerToDebate(debateNote: debateNote.text!, startTime: startTime!, speakingTime: speakingTime)
        }
        return speakingTime
    }
    
    
 

}

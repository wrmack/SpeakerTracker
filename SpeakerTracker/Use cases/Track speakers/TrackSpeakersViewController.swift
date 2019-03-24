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




class TrackSpeakersViewController: UIViewController, TrackSpeakersDisplayLogic {
    
    private var interactor: TrackSpeakersBusinessLogic?
    var router: (NSObjectProtocol & TrackSpeakersRoutingLogic & TrackSpeakersDataPassing)?

    // MARK: - Properties
    
    // Table collection
    internal var tableCollection = [MembersTable]()

    // Timer properties
    internal var timer: Timer?
    private var timerVisible = false
    internal var startTime: Date?
    internal var pausePressed = false
    internal var secondsElapsedWhenTimerPaused = 0
    
    // Sidebar
    private var sideBarIsHidden = true
    
    // Waiting list table
     private var reorderOn = false
    
    // Speaker list table
    internal var speakerRecording: SpeakerRecording?
    internal var longPressTablePosition: TablePosition?
    internal var speakingTableNumberOfSections = 1
    internal var debateMode = DebateMode.mainMotion
    internal var speakingTableSections = [ 0 : SectionStatus()]
    
    // Event recording
    var eventRecordingIsOn = false
  

    // MARK: - Storyboard outlets

    // The left table view, containing the starting list of names.
    @IBOutlet weak internal var remainingTable: UITableView!
    
    // The middle table view, containing the list of those wanting to speak.
    @IBOutlet weak internal var waitingTable: UITableView!
    
    // The right table view, containing the current speaker and the list of those who have spoken.
    @IBOutlet weak internal var speakingTable: UITableView!
    
    // References to labels for purposes of tweaking appearance
    @IBOutlet private weak var remainingLabel: UILabel!
    @IBOutlet weak private var waitingLabel: UILabel!
    @IBOutlet weak private var speakingLabel: UILabel!
    
    // Timer buttons and labels
    @IBOutlet  weak internal var timerLabel: UILabel!
    @IBOutlet  weak internal var startButton: UIButton!
    @IBOutlet  weak internal var pauseButton: UIButton!
    @IBOutlet  weak internal var stopButton: UIButton!
    @IBOutlet  weak internal var smTimerLabel: UILabel!
    @IBOutlet  weak internal var smStartButton: UIButton!
    @IBOutlet  weak internal var smPauseButton: UIButton!
    @IBOutlet  weak internal var smStopButton: UIButton!
    
    // The view that dims the background when the large timer is displayed
    @IBOutlet private weak var dimmerView: UIView!
    
    // Holds start, pause and stop buttons for large timer
    @IBOutlet private weak var stackView: UIStackView!
    
    // Buttons on right side of screen
    @IBOutlet private weak var expandButton: UIButton!
    @IBOutlet private weak var undoButton: UIButton!
    @IBOutlet internal weak var resetButton: UIButton!
    @IBOutlet internal weak var recordingOnLabel: UILabel!
    
    // Sidebar, views and buttons
    @IBOutlet private weak var sideBarView: UIView!
    @IBOutlet private weak var sideBarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var disclosureSideBarButtonView: UIView!
    @IBOutlet private weak var discloseSideBarButton: UIButton!
    @IBOutlet internal weak var selectEntityButton: UIButton!
    @IBOutlet internal weak var selectMeetingGroupButton: UIButton!
    @IBOutlet internal weak var selectEventButton: UIButton!
    @IBOutlet private weak var eventView: UIView!
    @IBOutlet internal weak var recordSwitch: UISwitch!
    @IBOutlet private weak var debateNote: UITextField!
    
    // Display - current meeting group and event
    @IBOutlet internal weak var meetingGroupLabel: UILabel!
    @IBOutlet weak private var meetingEventLabel: UILabel!
    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupVIP()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupVIP()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("TrackSpeakersViewController deinitialising")
    }
    
    
    // MARK: - Setup

    private func setupVIP() {
        let viewController = self
        let interactor = TrackSpeakersInteractor()
        let presenter = TrackSpeakersPresenter()
        let router = TrackSpeakersRouter()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    private func setupTableCollection() {
        let memberTableRemaining = MembersTable(tableView: remainingTable, nameDictionary: nil)
        let memberTableWaiting = MembersTable(tableView: waitingTable, nameDictionary: nil)
        let memberTableSpeaking = MembersTable(tableView: speakingTable, nameDictionary: nil)
    
        tableCollection = [memberTableRemaining, memberTableWaiting, memberTableSpeaking]
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
        remainingTable.dataSource = self
        waitingTable.dataSource = self
        waitingTable.delegate = self
        speakingTable.dataSource = self
        speakingTable.delegate = self
        speakingTable.register(DebateSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "DebateSectionHeaderView")
        
        // At start up, hide timer views, ensure stackview is at back so does not intercept touches, hide sidebar and the view containing the event selectors
        dimmerView.isHidden = true
        timerLabel.isHidden = true
        startButton.isHidden = true
        pauseButton.isHidden = true
        stopButton.isHidden = true
        _ = handleStopTimer()
        view.sendSubviewToBack(stackView)
        sideBarLeadingConstraint.constant = -370
        eventView.isHidden = true
        
        // If iPad Pro 12.9" make adjustments to row height
        let iPadScreenWidth = self.view.frame.size.width
        if iPadScreenWidth > 1300 {
            remainingTable.rowHeight = UITableView.automaticDimension
            remainingTable.rowHeight = 60
            remainingLabel.font = UIFont(name: "Arial", size: 20)
            waitingTable.rowHeight = 60
            waitingLabel.font = UIFont(name: "Arial", size: 20)
            speakingTable.rowHeight = 60
            speakingLabel.font = UIFont(name: "Arial", size: 20)
        }
        
        selectMeetingGroupButton.isEnabled = (selectEntityButton.titleLabel?.text == "Select an entity") ? false : true
        recordSwitch.isEnabled = (selectMeetingGroupButton.titleLabel?.text == "Select a meeting group") ? false : true
        
        let swipeGesture1 = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture1.direction = .right
        self.remainingTable.addGestureRecognizer(swipeGesture1)
        
        let swipeGesture2a = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture2a.direction = .left
        let swipeGesture2b = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture2b.direction = .right
        self.waitingTable.addGestureRecognizer(swipeGesture2a)
        self.waitingTable.addGestureRecognizer(swipeGesture2b)
        
        let swipeGesture3 = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture3.direction = .left
        self.speakingTable.addGestureRecognizer(swipeGesture3)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        self.speakingTable.addGestureRecognizer(longPressGesture)

        setupTableCollection()
    }
    
 
    
    /*
     Adjust tab bar of original UITabBarController once views have loaded
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.object(forKey: "MeetingNames")  != nil {
            let alert = UIAlertController(title: "Version upgrade", message: "The app will try to import your old version's committees into a dummy entity. Go to Setup to check.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                Utilities.updateFromOriginalVersion(callback: {success in
                    if success {
                        self.setupAfterViewAppears()
                    }
                    else {
                        print("Problem importing original data")
                    }
                })
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            setupAfterViewAppears()
        }
 
    }
        
    
    func setupAfterViewAppears() {
        let tabBarCont = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        let tabBarRect = tabBarCont.tabBar.frame
        tabBarCont.tabBar.frame = CGRect(x: view.frame.origin.x, y: tabBarRect.origin.y, width: view.frame.size.width, height: tabBarRect.size.height)
        for item in tabBarCont.tabBar.items! {
            item.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], for: .normal)
        }
        
        
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
    @IBAction private func discloseSideBarPressed(_ sender: UIButton) {
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
    
    @IBAction private func selectEntityPressed(_ button: UIButton) {
        router!.routeToSelectEntity(button: button)
    }
    
    @IBAction private func selectMeetingGroupPressed(_ button: UIButton) {
        router!.routeToSelectMeetingGroup(button: button)
    }
    
    @IBAction private func selectEventPressed(_ button: UIButton) {
        router?.routeToSelectEvent(button: button)
    }
    
    @IBAction private func recordSwitchPressed(_ sender: UISwitch) {
        if sender.isOn == true {
            eventView.isHidden = false
        }
        else {
            eventView.isHidden = true
            recordingOnLabel.textColor = UIColor.darkGray
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.alignment = .center
            let title = NSAttributedString(string: "Reset", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0), NSAttributedString.Key.paragraphStyle : paraStyle])
            resetButton.setAttributedTitle(title, for: .normal)
            eventRecordingIsOn = false
            addCurrentDebateToEvent()
        }
    }
    
    
    // MARK: Table view row buttons
    

    //  The right button on a remaining table row was pressed.
    
    @IBAction private func remainingTableRightButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {

        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: remainingTable)
        let index = remainingTable.indexPathForRow(at: pointInTable!)
        moveNameRight(from: TablePosition(tableIndex: 0, tableSection: index?.section, tableRow: index?.row))
    }


    

     // The left button on a waiting table row was pressed.
    
    @IBAction private func waitingTableLeftButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: waitingTable)
        let index = waitingTable.indexPathForRow(at: pointInTable!)
        moveNameLeft(from: TablePosition(tableIndex: 1, tableSection: index?.section, tableRow: index?.row))
    }
    
    
     // The right button on a waiting table row was pressed.
    
    @IBAction private func waitingTableRightButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {

        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: waitingTable)
        let index = waitingTable.indexPathForRow(at: pointInTable!)
        moveNameRight(from: TablePosition(tableIndex: 1, tableSection: index?.section, tableRow: index?.row))
    }
    

     // The left button on a speaking table row was pressed.
    
    @IBAction private func speakingTableLeftButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: speakingTable)
        let indexPath = speakingTable.indexPathForRow(at: pointInTable!)
        if speakerRecording != nil {
            let spkrIndexPath = IndexPath(row: (speakerRecording?.row)!, section: (speakerRecording?.section)!)
            if spkrIndexPath == indexPath {
                _ = handleStopTimer()
                speakerRecording = nil
            }
        }
        moveNameLeft(from: TablePosition(tableIndex: 2, tableSection: indexPath?.section, tableRow: indexPath?.row))
    }
    
    /*
     The right button on a speaking table row was pressed.
     If current speaker is on different row:
     - turn off current speaker if still speaking (check status of start button)
     - start timer for this speaker.
     If current speaker is this speaker:
     - stop this speaker
     */
    
    @IBAction private func speakingTableRightButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        let touch = event.allTouches?.first
        let pointInTable = touch?.location(in: speakingTable)
        let indexPath = speakingTable.indexPathForRow(at: pointInTable!)
        let cell = speakingTable.cellForRow(at: indexPath!) as! WMTableViewCell
        // Someone is speaking
        if speakerRecording != nil {
            let spkrIndexPath = IndexPath(row: (speakerRecording?.row)!, section: (speakerRecording?.section)!)
            // Not the row that was tapped,so shut them down so can start this row
            if spkrIndexPath != indexPath {
                if smStartButton.isEnabled == false {
                    let speakingTime = handleStopTimer()
                    addCurrentSpeakerToDebate(startTime: startTime!, speakingTime: speakingTime)
                }
                speakerRecording!.section = indexPath?.section
                speakerRecording!.row = indexPath?.row
                speakerRecording!.button = sender
                sender.setTitleColor(UIColor.red, for: .normal)
                sender.setTitle("00:00", for: .normal)
                sender.titleLabel!.font = UIFont.systemFont(ofSize:14)
                handleStartTimer()
                setCurrentSpeaker(section: (indexPath?.section)! , row: indexPath!.row)
            }
            else {
                // Speaker is the row that was tapped so stop the speaker
                if smStartButton.isEnabled == false {
                    let speakingTime = handleStopTimer()
                     addCurrentSpeakerToDebate(startTime: startTime!, speakingTime: speakingTime)
                }
                speakerRecording = nil
            }
        }
        else {
            // No-one else speaking, so start timer for tapped row
            speakerRecording = SpeakerRecording()
            speakerRecording!.row = indexPath!.row
            speakerRecording!.section = indexPath?.section
            speakerRecording!.button = sender
            sender.setTitleColor(UIColor.red, for: .normal)
            sender.setTitle("00:00", for: .normal)
            sender.titleLabel!.font = UIFont.systemFont(ofSize:14)
            cell.leftButton?.isEnabled = false
            cell.selectionStyle = .none
            handleStartTimer()
            setCurrentSpeaker(section: (indexPath?.section)! , row: indexPath!.row)
        }
        fetchNames()
    }
    
    @IBAction private func reorderButton(_ sender: UIButton) {
        
        if reorderOn == false {
            let membersTableWaiting = tableCollection[1]
            let nameDictionary = membersTableWaiting.nameDictionary
            let speakerArray = nameDictionary![0]
            if speakerArray!.count > 1 {
                waitingTable.isEditing = true
                reorderOn = true
                sender.tintColor = UIColor(red: 0.6, green: 0.6, blue: 1.0, alpha: 1.0)
                remainingTable.isUserInteractionEnabled = false
                speakingTable.isUserInteractionEnabled = false
                for cell in waitingTable.visibleCells {
                    (cell as! WMTableViewCell).leftButton?.isHidden = true
                    (cell as! WMTableViewCell).rightButton?.isHidden = true
                    (cell as! WMTableViewCell).setNeedsUpdateConstraints()
                }
            }
        } else {
            waitingTable.isEditing = false
            reorderOn = false
            sender.tintColor = UIColor.lightGray
            remainingTable.isUserInteractionEnabled = true
            speakingTable.isUserInteractionEnabled = true
            for cell in waitingTable.visibleCells {
                (cell as! WMTableViewCell).leftButton?.isHidden = false
                (cell as! WMTableViewCell).rightButton?.isHidden = false
                (cell as! WMTableViewCell).setNeedsUpdateConstraints()
            }
        }
    }
    
    
    // MARK: Controls
    
    /*
     Reset button pressed
     */
    @IBAction private func resetAll(_ sender: UIButton) {
        if smStartButton.isEnabled == false {
            _ = handleStopTimer()
        }
        debateMode = .mainMotion
        setupTableCollection()
        speakerRecording = nil
        if eventRecordingIsOn == true {
            addCurrentDebateToEvent()
        }
        resetAllNames()
    }
    
    
    /*
     The undo button was pressed.
     */
    @IBAction private func undoPressed(_ sender: UIButton) {
        undoLastAction()
    }
    
    
    // MARK: Timer buttons
    /*
     The large timer is toggled on and off.
     */
    @IBAction private func showLargeTimer(_ sender: UIButton) {
        
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
            view.bringSubviewToFront(dimmerView)
            view.bringSubviewToFront(timerLabel)
            view.bringSubviewToFront(stackView)
            view.bringSubviewToFront(startButton)
            view.bringSubviewToFront(pauseButton)
            view.bringSubviewToFront(stopButton)
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
            view.sendSubviewToBack(stackView)
            expandButton.setImage(UIImage(named: "expand2"), for: .normal)
        }
    }
    
    
    /*
     The large timer's start button was pressed.
     */
    @IBAction private func startTimer(_ sender: UIButton) {
        handleStartTimer()
    }
    
    
    /*
     The small timer button actions
     */
    @IBAction private func startSmTimer(_ sender: UIButton) {
        handleStartTimer()
    }
    
    @IBAction private func pauseTimer(_ sender: UIButton) {
        handlePauseTimer()
    }
    
    @IBAction private func pauseSmTimer(_ sender: UIButton) {
        handlePauseTimer()
    }
    
    @IBAction private func stopTimer(_ sender: UIButton) {
        _ = handleStopTimer()
    }
    
    @IBAction private func stopSmTimer(_ sender: UIButton) {
        let speakingTime = handleStopTimer()
        if speakerRecording != nil {
            addCurrentSpeakerToDebate(startTime: startTime!, speakingTime: speakingTime)
            speakerRecording = nil
        }
    }
    
    @IBAction private func infoButtonPressed(_ sender: UIButton) {
        router!.routeToShowHelpController()
    }
    
    // MARK: - Datastore

    private func setCurrentEntity(entity: Entity) {
         interactor?.setCurrentEntity(entity: entity)
    }
    
    private func getCurrentEntity() -> Entity? {
        return interactor!.getCurrentEntity()
    }
    
    private func setCurrentMeetingGroup(meetingGroup: MeetingGroup) {
        interactor?.setCurrentMeetingGroup(meetingGroup: meetingGroup)
    }
    
    private func getCurrentMeetingGroup()-> MeetingGroup? {
        return interactor?.getCurrentMeetingGroup()
    }
    
    private func meetingGroupBelongsToCurrentEntity(meetingGroup: MeetingGroup) -> Bool {
        return interactor!.meetingGroupBelongsToCurrentEntity(meetingGroup: meetingGroup)
    }

    private func setCurrentSpeaker(section: Int, row: Int) {
        interactor!.setCurrentSpeaker(section: section, row: row)
    }
    
    private func setCurrentEvent(event: Event?) {
        interactor!.setCurrentEvent(event: event)
    }
    
    private func addCurrentDebateToEvent() {
        interactor?.addCurrentDebateToEvent(debateNote: debateNote?.text)
    }
    
    internal func getCurrentDebate()-> Debate? {
        return interactor!.getCurrentDebate()
    }
    
    private func addCurrentSpeakerToDebate(startTime: Date, speakingTime: Int) {
        interactor!.addCurrentSpeakerToDebateSection(startTime: startTime, speakingTime: speakingTime)
    }
    
    private func getSpeakingListNumberOfSections() -> Int {
        return interactor!.getSpeakingListNumberOfSections()
    }
    
    // MARK: - VIP
    
    private func fetchNames() {
        interactor!.fetchNames()
    }
    
    internal func displayNames(viewModel: TrackSpeakers.Speakers.ViewModel) {
        let remainingNameDictionary = viewModel.remainingNames
        let memberTableRemaining = MembersTable(tableView: remainingTable, nameDictionary: remainingNameDictionary)
        let waitingNameDictionary = viewModel.waitingNames
        let memberTableWaiting = MembersTable(tableView: waitingTable, nameDictionary: waitingNameDictionary)
        let speakingNameDictionary = viewModel.speakingNames
        let memberTableSpeaking = MembersTable(tableView: speakingTable, nameDictionary: speakingNameDictionary)
        tableCollection = [memberTableRemaining, memberTableWaiting, memberTableSpeaking]
        speakingTableNumberOfSections = getSpeakingListNumberOfSections()
        remainingTable.reloadData()
        waitingTable.reloadData()
        speakingTable.reloadData()
    }
    
    internal func moveNameRight(from tablePosition: TablePosition ) {
        interactor!.moveNameRight(from: tablePosition)
        fetchNames()
    }
    
    internal  func moveNameLeft(from tablePosition: TablePosition ) {
        interactor!.moveNameLeft(from: tablePosition)
        fetchNames()
    }
    
    internal  func copyNameToEnd(from tablePosition: TablePosition ) {
        interactor!.copyNameToEnd(from: tablePosition)
        fetchNames()
    }
    
    private func resetAllNames() {
        interactor!.setUpForNewDebate()
        fetchNames()
    }
    
    private func undoLastAction() {
        interactor!.undoLastAction()
        fetchNames()
    }
    
   internal func updateAfterSelectingMeetingGroup() {
        interactor?.updateAfterSelectingMeetingGroup()
        fetchNames()
    }
  
   internal func updateAfterSelectingEvent() {
        interactor?.updateAfterSelectingEvent()
        let event = interactor?.getCurrentEvent()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let dateStrg = formatter.string(from: (event?.date)!)
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let timeStrg = formatter.string(from: (event?.date)!)
        meetingEventLabel.text = timeStrg + ", " + dateStrg
        fetchNames()
    }
    
    internal func beginAmendment() {
        debateMode = .amendment
        speakingTableNumberOfSections += 1
        let section = speakingTableNumberOfSections - 1
        let status = SectionStatus(isCollapsed: false, isAmendment: true)
        speakingTableSections[section] = status
        interactor!.beginAmendment()
        fetchNames()
    }
    
    internal func endAmendment() {
        debateMode = .mainMotion
        speakingTableNumberOfSections += 1
        let section = speakingTableNumberOfSections - 1
        let status = SectionStatus(isCollapsed: false, isAmendment: false)
        speakingTableSections[section] = status
        interactor!.endAmendment()
        fetchNames()
    }
 
}

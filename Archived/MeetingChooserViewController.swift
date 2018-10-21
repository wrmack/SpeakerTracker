//
//  MeetingChooserViewController.swift
//  SpeakerTracker
//
//  Created by Warwick on 14/01/17.
//  Copyright © 2017 Warwick McNaughton. All rights reserved.
//

import UIKit

protocol MeetingChooserViewControllerDelegate: class {
    func didSelectMeeting(_ meetingName: String)
}


class MeetingChooserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Constants
    
    private let TABLE_CELL_HEIGHT: CGFloat = 40
    
    
    // MARK: Variables
    
    //private var numberOfMeetings = 1
    private var meetingsArray = [String]()
    private var theTableView: UITableView?
    internal weak var delegate: MeetingChooserViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* -------------------  Get list of meetings ------------------------ */
        
        let defaults = UserDefaults.standard
        if let array = defaults.array(forKey: "MeetingNames") {
            meetingsArray = array as! [String]
        }
        
        
        /* --------------------- Create heading ---------------------------- */
        
        let theHeading = UIView()
        theHeading.backgroundColor = UIColor.lightGray
        let theLabel = UILabel()
        theLabel.text = "Select a meeting"
        theLabel.textAlignment = .center
        theHeading.addSubview(theLabel)
        view.addSubview(theHeading)

        theHeading.translatesAutoresizingMaskIntoConstraints = false
        theHeading.leadingAnchor.constraint(equalTo: theHeading.superview!.leadingAnchor).isActive = true
        theHeading.topAnchor.constraint(equalTo: theHeading.superview!.topAnchor).isActive = true
        theHeading.heightAnchor.constraint(equalToConstant: 40).isActive = true
        theHeading.trailingAnchor.constraint(equalTo: theHeading.superview!.trailingAnchor).isActive = true
        
        theLabel.translatesAutoresizingMaskIntoConstraints = false
        theLabel.leadingAnchor.constraint(equalTo: theHeading.leadingAnchor).isActive = true
        theLabel.topAnchor.constraint(equalTo: theHeading.topAnchor).isActive = true
        theLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        theLabel.trailingAnchor.constraint(equalTo: theHeading.trailingAnchor).isActive = true
        
        
        /* -------------------  Create the table  ------------------------------- */
        
        let tableRect = CGRect(x: 0, y: 40, width: view.bounds.size.width, height: view.bounds.size.height - 40)
        
        theTableView = UITableView(frame:tableRect) // Rest of view
        theTableView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        theTableView!.rowHeight = UITableViewAutomaticDimension
        theTableView!.estimatedRowHeight = TABLE_CELL_HEIGHT
        theTableView!.allowsSelection = true
        theTableView!.dataSource = self
        theTableView!.delegate = self
        
        view.addSubview(theTableView!)
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: UITableViewDataSource protocols
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return meetingsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myIdentifier = "MyReuseIdentifier"
        var tvCell = tableView.dequeueReusableCell(withIdentifier: myIdentifier)
        if tvCell == nil{
            tvCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:myIdentifier)
            tvCell!.textLabel!.font = UIFont.boldSystemFont(ofSize: 17.0)
            tvCell!.textLabel!.textColor = UIColor.black
            tvCell!.backgroundColor = UIColor.white
            tvCell!.textLabel!.numberOfLines = 0
            tvCell!.textLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        }
        
        let meetingName = meetingsArray[(indexPath as NSIndexPath).row]
        tvCell!.textLabel!.text = meetingName

        return tvCell!
    }
    
    
    
    //MARK: UITableViewDelegate protocols
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectMeeting(meetingsArray[indexPath.row])
    }
    

    


}

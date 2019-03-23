//
//  InfoViewController.swift
//  SpeakerTracker
//
//  Created by Warwick on 24/06/17.
//  Copyright © 2017 Warwick McNaughton. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

   @IBOutlet var infoTextView: UITextView!
   
   
   override func viewDidLoad() {
        super.viewDidLoad()

      let centeredStyle = NSMutableParagraphStyle()
      centeredStyle.alignment = NSTextAlignment.center
      let leftStyle = NSMutableParagraphStyle()
      leftStyle.alignment = NSTextAlignment.left
      
      let heading1Attributes = [NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 20)!,
                               NSAttributedString.Key.foregroundColor : UIColor.black,
                               NSAttributedString.Key.paragraphStyle: leftStyle] as [NSAttributedString.Key : Any]
      let heading2Attributes = [NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 18)!,
                                NSAttributedString.Key.foregroundColor : UIColor.black,
                                NSAttributedString.Key.paragraphStyle: leftStyle] as [NSAttributedString.Key : Any]
      let normalAttributes = [NSAttributedString.Key.font : UIFont(name: "Arial", size: 14)!,
                              NSAttributedString.Key.foregroundColor : UIColor.black,
                              NSAttributedString.Key.paragraphStyle: leftStyle] as [NSAttributedString.Key : Any]
      let normalBoldAttributes = [NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 14)!,
                              NSAttributedString.Key.foregroundColor : UIColor.black] as [NSAttributedString.Key : Any]
      let centeredAttributes = [NSAttributedString.Key.paragraphStyle: centeredStyle]
      
      let attStg = NSMutableAttributedString(string: "Set up Speaker Tracker", attributes: heading1Attributes)
      attStg.append(NSAttributedString(string: "\n\nThe app initially has one fictitious meeting: Committee 1.", attributes: normalAttributes))
      
      // 1. Create your own committees
      attStg.append(NSAttributedString(string: "\n\n1. Create your own meetings", attributes: heading2Attributes))
      attStg.append(NSAttributedString(string: "\n\nClick on the ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Edit", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " button then after the 'Add and edit members' screen appears, click on the ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Edit meetings", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " button to the right of the current meeting name." +
         " A pop-up will give you the ability to: " +
         "\n- change meeting names\n- delete meetings\n- add meetings.\n\nWhen finished editing meeting names, click ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Done", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " to check your changes then click on the ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Edit meetings", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: "  button again to dismiss the pop-up. Click on ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Save", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " to save your changes.", attributes: normalAttributes))
     
      // 2. Create list of committee members
      attStg.append(NSAttributedString(string: "\n\n2. Create list of meeting members", attributes: heading2Attributes))
      attStg.append(NSAttributedString(string: "\n\nIf back on the main screen, go to ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Edit", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " then after the 'Add and edit members' screen appears, choose the meeting you want by clicking the ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Edit meetings", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " button to the right of the current meeting name." +
         "\n\nAfter choosing the meeting from the second pop-up, click on the ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Edit meetings", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " button again to dismiss this pop-up. \n\nBack in the 'Add and edit members' screen, edit the list of members." +
         " When you tap in the text box of this screen the keyboard should appear. You will also have the ability to select, copy and paste by using long presses." +
         "\n\nWhen finished editing names of members, press ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Save.", attributes: normalBoldAttributes))
      
      // Choose committee
      attStg.append(NSAttributedString(string: "\n\nChoose meeting", attributes: heading1Attributes))
      attStg.append(NSAttributedString(string: "\n\nPress on ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: " Meeting", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " and the app will display the meeting that you select.", attributes: normalAttributes))
    
      // At a meeting
      attStg.append(NSAttributedString(string: "\n\nAt a meeting", attributes: heading1Attributes))
      attStg.append(NSAttributedString(string: "\n\n1. Chairperson asks for those who want to speak", attributes: heading2Attributes))
      attStg.append(NSAttributedString(string: "\n\nWhen a member indicates a wish to speak, move the member's name to the middle column: ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Waiting to speak.", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " To do this, either swipe the member's name to the right or press the angle-bracket to the right of the member's name." +
         "\n\nIf you need to change the order of those waiting to speak, press the re-order button to the right of the ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Waiting to speak", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " column heading. A member's name in this column can then be dragged into a different position." +
         "\n\nYou can return a member's name to the left column by swiping it to the left or by pressing the angle-bracket to the left of the member's name.", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "\n\n2. Member takes speaking turn", attributes: heading2Attributes))
      attStg.append(NSAttributedString(string: "\n\nThe member's name can be moved to the ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Spoken/speaking", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " column by swiping the name to the right or pressing on the angle-bracket to the right of the name." +
         "\n\nYou can time the member's speech in two ways: \n- press ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Show timer", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " to show a clock which fills the whole screen\n- use the small timer at the top right-hand corner of the screen." +
         "\n\nThe large timer, covering the whole screen, makes the lists inaccessible and so you may prefer the smaller timer. You can switch between the two because they are synchronised." +
         "\n\nThe play button starts the timer.\n\nThe pause button pauses the timer. Pressing the play button again will cause the timer to continue from where it was paused." +
         "\n\nThe stop button stops the timer. Pressing the play button again will cause the timer to start from zero.", attributes: normalAttributes))
      
      // Undo
      attStg.append(NSAttributedString(string: "\n\nUndo", attributes: heading1Attributes))
      attStg.append(NSAttributedString(string: "\n\nIf you inadvertently take an action by mistake you can undo your action by pressing the ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: " Undo", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " button.", attributes: normalAttributes))
      
      // Reset all
      attStg.append(NSAttributedString(string: "\n\nReset all", attributes: heading1Attributes))
      attStg.append(NSAttributedString(string: "\n\nPressing the ", attributes: normalAttributes))
      attStg.append(NSAttributedString(string: "Reset all", attributes: normalBoldAttributes))
      attStg.append(NSAttributedString(string: " button returns all members to the left-hand column.", attributes: normalAttributes))
      
      // Notes
      attStg.append(NSAttributedString(string: "\n\n---------------------------", attributes: centeredAttributes))
      attStg.append(NSAttributedString(string: "\n\nThe code for this app is open source so others can improve it.  The code is here:\n", attributes: normalAttributes))
      var link = NSURL(string: "https://github.com/wrmack/SpeakerTracker")
      attStg.append(NSAttributedString(string: "https://github.com/wrmack/SpeakerTracker", attributes: [NSAttributedString.Key.link : link!, NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 14)!]))
      attStg.append(NSAttributedString(string: "\n\nThese 'How to...' notes are also here:\n", attributes: normalAttributes))
      link = NSURL(string: "https://github.com/wrmack/SpeakerTracker/wiki")
      attStg.append(NSAttributedString(string: "https://github.com/wrmack/SpeakerTracker/wiki", attributes: [NSAttributedString.Key.link : link!, NSAttributedString.Key.font : UIFont(name: "Arial-BoldMT", size: 14)!]))
      attStg.append(NSAttributedString(string: "\n\nPrivacy statement:\nPersonal information entered into this app is stored only on the device which contains the app" +
         " and only for the purposes of the app. No personal information is transmitted outside the app or the device.", attributes: normalAttributes))
      
      
      infoTextView.attributedText = attStg
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

}

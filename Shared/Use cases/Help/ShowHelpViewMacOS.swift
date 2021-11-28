//
//  ShowHelpViewMacOS.swift.swift
//  Speaker-tracker-multi (macOS)
//
//  Created by Warwick McNaughton on 17/11/21.
//

import SwiftUI


struct ShowHelpViewMacOS: View {

    @Binding var showHelp: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button("Dismiss", action: {
                showHelp = false
            })
        }
        .padding(.vertical,10)
        .padding(.horizontal, 20)
        ScrollView {
            VStack(alignment: .leading) {

                Group {
                    Text("Help")
                        .font(.largeTitle)
                        .foregroundColor(Color(red: 0.12, green: 0.28, blue: 0.49))
                    Text("First time using the app")
                        .font(.title)
                        .foregroundColor(Color(red: 0.12, green: 0.28, blue: 0.49))
                    Text("Go to setup and create an entity.  Then create members and meeting groups for that entity.")
                    Text(
                        """
                        **Example**
                        Entity:  My council
                        Members:  Cr Member One, Cr Member Two, Cr Member Three
                        Meeting groups:  Full council, Committee One, Committee Two
                        """)

                    Text("Main sreen")
                        .font(.title)
                        .foregroundColor(Color(red: 0.12, green: 0.28, blue: 0.49))
                    Text("The lists")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.33, green: 0.55, blue: 0.8))
                    Text("**Remaining list**")
                    Text("All members start here, in alphabetical order of last name.")
                    Text("**Waiting list**")
                    Text(
                        """
                        Members who have signalled their wish to speak are listed here.\
                        The meeting chair can see who is next to speak.  \
                        Members can be re-ordered by dragging and dropping rows.
                        """)
                }
                .padding(.top,2)
                Group {
                    Text("**Speaking list**")
                    Text(
                        """
                        Shows the members who have previously spoken in the debate and the member currently speaking.
                        """
                    )
                    Text(
                        """
                        **Moving a member from one list to another**
                        """
                    )
                    Text(
                        """
                        Press the arrow to the side of the speaker's name. A member in the Speaking List \
                        cannot be moved between lists once the timer for the member is started.
                        """
                    )
                    Text("Debates")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.33, green: 0.55, blue: 0.8))
                    Text("**Speaking rules**")
                    Text(
                        """
                        This app is based on the rule that speakers in a debate to a motion only speak once.  \
                        A speaker may propose an amendment to a motion being debated.  All members, whether \
                        they have already spoken to the main (original) motion or not, may speak to the amendment.  \
                        Once the amendment is dispensed with, only those speakers who have not already spoken \
                        to the main motion may continue to speak to it. \
                        If your meeting rules allow speakers to speak more than once, and you wish to time a \
                        speaker who has already spoken once, right-click on the speaker and select the menu option to speak again.
                        """
                    )
                    Text("**Amendments**")
                    Text(
                        """
                        If the member who is speaking moves an amendment, right-click on the member when finished speaking to commence \
                        a debate on the amendment. All other members may speak to the amendment and are returned to the Remaining list. \
                        Right-click on the final speaker to the amendment to close the amendment debate.  The main debate resumes. \
                        Those members who have not already spoken in the main debate may speak.
                        """
                    )
                }
                .padding(.top,2)
                
                Group {
                    Text("Timing speeches")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.33, green: 0.55, blue: 0.8))
                    Text("**Timer**")
                    Text(
                        """
                        There is a clock at the top of the screen.  Pressing the full screen button shows a larger clock.  \
                        Both clocks are synced.  They display the same timing action.  When you press the play button next \
                        to a speaker's name, the play button is replaced by a clock.
                        To time a speaker you have options.
                        Press the play button for the top clock when the speaker commences.  The stop button stops the timer \
                        and when the play button is pressed again it starts from zero.  The pause button pauses the timer and \
                        when the play button is pressed again it resumes from where it was paused.
                        To retain a display of each speaker's time, press the play button next to the speaker's name.  \
                        The play button will be replaced by the time.  \
                        Press the clock next to speaker again to stop the timer, or press the stop button of the top clock.  \
                        The clock next to the speaker's name retains the time and is disabled so it cannot be restarted.
                        """
                    )
                    Text("Recording debates")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.33, green: 0.55, blue: 0.8))
                    Text("**Meeting events**")
                    Text(
                        """
                        When a meeting group comes together to have a meeting, we call this a 'meeting event'.  \
                        For the purposes of this app, a meeting event includes the name of the entity, the name of the \
                        group that is meeting (the 'meeting group'), the members of the meeting group and the date and \
                        time of the meeting.
                        You can record and save all debates that take place at a meeting event as below.
                        """
                    )
                    Text("**Create the meeting event**")
                    Text(
                        """
                        • Go to 'Setup'
                        • Select the 'Events' tab
                        • Select the 'Entity'
                        • Select the 'Meeting group'
                        • Press the 'Add' button
                        • Set the date and time, press 'Save'

                        """
                    )
                    Text("**Setup the meeting to record the meeting event**")
                    Text(
                        """
                        • Go to 'Speakers' (the main window for tracking speakers at a meeting)
                        • Press 'Meeting setup'
                        • Ensure 'Entity' and 'Meeting group' are correct
                        • Enable 'Create a record of this meeting'
                        • Select the 'Meeting event' from the pop-up
                        • Press 'Done'
                        
                        A red recording icon will now be visible.
                        """
                    )
                }
                .padding(.top,2)
                
                Group {
                    Text("**Record the meeting event**")
                    Text(
                        """
                        Press the pencil icon at the top of the 'Spoken / Speaking' table to add a note for the current debate, \
                        for example to identify which item in the agenda the debate relates to.
                        After each debate is completed, press the 'Save debate' button to save the debate and start a new one.
                        When the meeting event is over, save the final debate and end the meeting.
                        View the record of the meeting event's speaking times in 'Reports'.
                        """
                    )
                    Text("Setup")
                        .font(.title)
                        .foregroundColor(Color(red: 0.12, green: 0.28, blue: 0.49))
                    Text("**Entities**")
                    Text(
                        """
                        Add an entity and give it a name.  You can also edit the name of an existing entity.
                        """
                    )
                    Text("**Members**")
                    Text("Select an entity and add members, or edit existing members.")
                    Text("**Meeting groups**")
                    Text(
                        """
                        Select an entity and add meeting groups.  For each meeting group assign members from the entity's members.  \
                        You can also edit existing meeting groups.
                        """
                    )
                    Text("**Events**")
                }
                .padding(.top,2)
                Group {
                    Text(
                        """
                        Select an entity and a meeting group and create a meeting event which can be used when recording debates.  \
                        You can also edit existing events.
                        """
                    )
                    Text("Reports")
                        .font(.title)
                        .foregroundColor(Color(red: 0.12, green: 0.28, blue: 0.49))
                    Text(
                        """
                        Reports display the data held in events.
                        Select an entity and meeting group to view reports of meeting events that have been recorded. \
                        Select a report to view it.  You are able to airdrop it, email it, save it, print it or open \
                        it in another app.
                        To delete a report, delete its meeting event in Setup.
                        """
                    )
                    Text("Deletions")
                        .font(.title)
                        .foregroundColor(Color(red: 0.12, green: 0.28, blue: 0.49))
                    Text(
                        """
                        Deleting:
                        • an entity also deletes its members, meeting groups, events and reports
                        • a meeting group also deletes its meeting events and reports
                        • an event also deletes its reports
                        To keep a long-lasting archive of meeting event reports make a regular practice of \
                        sharing / exporting each report.
                        """
                    )
                    Text("App info")
                        .font(.title)
                        .foregroundColor(Color(red: 0.12, green: 0.28, blue: 0.49))
                    Text(
                        """
                        Source code: https://github.com/wrmack/SpeakerTracker
                        Developer:  Warwick McNaughton, warwick.mcnaughton@gmail.com \n
                        """
                    )
                    Text("**Privacy statement**")
                    Text(
                        """
                        The app does not use personal information for any purpose other than the purpose of tracking speakers \
                        at meetings and keeping a record of this. \
                        The personal information used for tracking speakers comprises members' names and speaking times.\n
                        """
                    )
                }
                .padding(.top,2)
                
                Divider()
                
                Spacer()

            }
            .padding(.horizontal,40)
            .padding(.vertical,30)
        }
        .colorScheme(.light)
        .background(Color(white:0.85))
        //    #if os(macOS)
        .frame(idealWidth:800, idealHeight:600)
        //    #endif
    }
        

}

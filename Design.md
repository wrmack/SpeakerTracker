#  Design

## User interface

The user interface comprises:

- a main tab view with tabs for 
     - tracking speakers 
     - setup 
     - reports
- the setup interface comprises a secondary tab view for setting up and editing 
     - entities
     - members
     - meeting groups 
     - events


## Setup flow

- user selects an item in the master list
- this changes the published property for currentIndex (in relevant EntityState or EventState)
- the detail view listens for changes to currentIndex and displays the selected item

## Model data









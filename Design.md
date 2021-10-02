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

## User interface state

ContentView needs to know which tabs are selected and when they change

The setup master views need to know which row is selected for highlighting purposes.
The setup detail views need to know which master row is selected to display the correct item detail.

## Model data

### Environment objects
#### AppState

- list of entities 
- list of events


#### SetupState

An Observable Object which holds state for the use-cases in setup.
- injected by scene delegate as an environment object
- publishes total number of rows (will change if user adds or deletes an item)
- publishes whether master has been set up (so detail view can do its thiing)
- publishes whether an item was edited
- publishes the selected entity
- publishes the selected meeting group
- publishes meeting group members
- stores sorted entities
- stores sorted members
- stores sorted meeting groups
- stores sorted events
- stores whether entities detail view is setup
- stores whether members detail view is setup
- stores whether meeting groups detail view is setup
- stores whether events detail view is setup







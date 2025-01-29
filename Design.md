#  Design

## Overall structure

The key elements of the structure are the following.

### Use-cases
- what a user wants to do with the app
- a View-Interactor-Presenter (VIP) pattern is used for separating concerns

### Persistent storage
- data that is retained between sessions
- CoreData framework used

### State
- data that is held in memory
- changes to state are published

--- 

## VIP pattern
- `View` 
    - provides the user interface 
    - listens for changes caused by user interaction and calls on `Interactor` to get or set data
    - listens for changes to the view model published by `Presenter` and refreshes the display
- `Interactor` 
    - gets or sets data by interacting with state or persistent storage
    - passes data to `Presenter`
- `Presenter`
    - formats data from `Interactor` into a view model
    - publishes the view model

The VIP pattern is used for each use-case.

Process flow is:

View --> Interactor --> Presenter --> View

---

## Data model

```
Entity
   - Members
   - Meeting groups
      - Members (subset of an entity's members)
      - Meeting events

Meeting event
   - Debates
      - Debate sections
         - Speech events

```    

---

## State

### EntityState
- state associated with the Entity model

### EventState
- state associated with the Event model

### TrackSpeakersState
- state associated with the TrackSpeakers use-case

### SetupSheetState
- state associated with editing use-cases

### ReportsState
- state associated with the display of meeting event reports

---












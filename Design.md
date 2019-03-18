# Design

## Overview
- The app design is based on use-cases, using the Viewcontroller-Interactor-Presenter (VIP) architecture pattern described in Clean-Swift.
- Apps are built to do stuff.  It is logical to design an app based on the use-cases that are relevant to the user.
- The VIP pattern separates responsibilities clearly and avoids the massive view-controller syndrome.
- Clean-swift bases its VIP on storyboard scenes.   I have applied the VIP pattern to any use-case, whether a view controller is required or not.  If a view-controller is not required, a controller (sub-class of NSObject) is used.

## View-controller / controller
- Sets up the VIP group for the use-case
- Sets up views
- Is delegate for views
- Handles user-actions
- Requests information from the VIP process, or simply from the datastore
- Displays information that has been processed through VIP and it receives from the Presenter as a view model
- Routes to other use-cases using a router
- A use-case which does not require its own views has, instead of a view-controller, a controller that: sets up the group, requests information from the datastore, and uses a router to pass control and data between use-case VIP groups
- Does not know about the model.
- Does not perform any business logic.

## Interactor
- Works with the model
- Performs all the business logic required of the use-case
- Receives requests from the view-controller for information, accesses the model to get the information, responds with the model data to the Presenter.
- Receives requests from the view-controller for information from the datastore which does not require presenting, and returns this information.
- Holds the group's datastore, which contains any model information that needs to be passed into or out by the router. 

## Presenter
- Performs any manipulation necessary for display purposes on the model data provided by the Interactor.
Passes the manipulated information to the viewcontroller for display.

## Router
- Manages routing / navigation between use-cases or storyboard scenes and segues
- Presents view controllers or creates instances of use-case controllers
- Passes data from current use-case datastore to new use-case datastore
- Handles holding strong references to new use-cases that are created and releasing references when the use-case returns.

## Moving between use-cases
- Options for passing data between use-cases include:
    - passing it from one use-case datastore to another use-case datastore using the routers
    - injecting the data when initialising the new use-case 
    - setting up a singleton model-manager which contains model data that all use-cases can access





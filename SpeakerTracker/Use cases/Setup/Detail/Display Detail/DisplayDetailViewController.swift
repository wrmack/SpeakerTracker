//
//  DisplayDetailViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 6/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol DisplayDetailDisplayLogic: class {
    func displayDetailFields(viewModel: DisplayDetail.Detail.ViewModel)
}

protocol DisplayDetailViewControllerDelegate: class {
    func didSelectEntityInDisplayDetailViewController(entity: Entity)
    func didSelectMeetingGroupInDisplayDetailViewController(meetingGroup: MeetingGroup)
}

protocol DisplayDetailViewControllerEditDelegate: class {
    func didPressEditButtonInDisplayDetailViewController(selectedItem: AnyObject?)
}


class DisplayDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DisplayDetailDisplayLogic, EntitiesPopUpViewControllerDelegate, MeetingGroupsPopUpViewControllerDelegate {
    
    var interactor: DisplayDetailBusinessLogic?
    var router: (NSObjectProtocol & DisplayDetailRoutingLogic & DisplayDetailDataPassing)?
    var fields:  [(String, String)]?
    var selectMeetingGroupLabel: UILabel?
    var selectMeetingGroupButton: UIButton?
    
    weak var delegate: DisplayDetailViewControllerDelegate?
    weak var editDelegate: DisplayDetailViewControllerEditDelegate?
    
    
    // Storyboard outlets

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailToolBar: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var detailToolbarHeightConstraint: NSLayoutConstraint!
    

    
    
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    deinit {
        print("DisplayDetailViewController deinitialised")
    }
    
    
    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = DisplayDetailInteractor()
        let presenter = DisplayDetailPresenter()
        let router = DisplayDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    
    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    
    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource  = self
        detailTableView.reloadData()
    }

    
    // MARK: - Exposed functions
    
    func updateDetails() {
        getFields()
    }
    
    
    func largeToolbar() {
        detailToolbarHeightConstraint.constant = 115
        self.view.layoutIfNeeded()
        if selectMeetingGroupLabel != nil {
            let isSubView = selectMeetingGroupLabel?.isDescendant(of: view)
            if isSubView! {
                return
            }
        }
        selectMeetingGroupLabel = UILabel()
        selectMeetingGroupLabel!.text = "Select a meeting group  〉"
        selectMeetingGroupLabel!.font = UIFont.systemFont(ofSize: 17.0)
        selectMeetingGroupLabel!.textColor = UIColor(white:0.0, alpha:1.0)
        detailToolBar.addSubview(selectMeetingGroupLabel!)
        selectMeetingGroupButton = UIButton()
        selectMeetingGroupButton!.setTitleColor(UIColor(white: 0.3, alpha: 0.5), for: .normal)
        selectMeetingGroupButton!.setTitle("No meeting group selected", for: UIControlState.normal)
        selectMeetingGroupButton!.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        selectMeetingGroupButton!.isHidden = false
        selectMeetingGroupButton!.titleLabel?.textAlignment = .left
        selectMeetingGroupButton!.contentHorizontalAlignment = .left
        selectMeetingGroupButton!.backgroundColor = detailButton.backgroundColor
        selectMeetingGroupButton!.addTarget(self, action: #selector(selectMeetingGroupButtonPressed(_:)), for: .touchUpInside)
        detailToolBar.addSubview(selectMeetingGroupButton!)
        
        // Autolayout
        selectMeetingGroupLabel!.translatesAutoresizingMaskIntoConstraints = false
        selectMeetingGroupLabel!.trailingAnchor.constraint(equalTo: detailLabel.trailingAnchor).isActive = true
        selectMeetingGroupLabel!.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 20).isActive = true
//        selectMeetingGroupLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        selectMeetingGroupLabel.heightAnchor.constraint(equalToConstant: TOOLBAR_HEIGHT).isActive = true
        selectMeetingGroupButton!.translatesAutoresizingMaskIntoConstraints = false
        selectMeetingGroupButton!.leadingAnchor.constraint(equalTo: detailButton.leadingAnchor).isActive = true
        selectMeetingGroupButton!.topAnchor.constraint(equalTo: detailButton.bottomAnchor, constant: 20).isActive = true
        selectMeetingGroupButton!.widthAnchor.constraint(equalTo: detailButton.widthAnchor).isActive = true
        selectMeetingGroupButton!.heightAnchor.constraint(equalTo: detailButton.heightAnchor).isActive = true
    }
    
    
    func smallToolbar() {
        selectMeetingGroupLabel?.removeFromSuperview()
        selectMeetingGroupButton?.removeFromSuperview()
        detailToolbarHeightConstraint.constant = 70
        self.view.layoutIfNeeded()
    }
    
    
    // MARK: - VIP
    
    private func getFields() {
        let request = DisplayDetail.Detail.Request()
        interactor?.getSelectedItemFields(request: request)
    }
    
    
    internal func displayDetailFields(viewModel: DisplayDetail.Detail.ViewModel) {
        fields = viewModel.detailFields
        detailTableView.reloadData()
    }
    
    
    // MARK: - Datastore
    
    func setCurrentEntity(entity: Entity) {
        interactor!.setCurrentEntity(entity: entity)
    }
    
    
    func getCurrentEntity()-> Entity {
        return interactor!.getCurrentEntity()
    }
    
    
    // Button actions
    
    @IBAction func entityButtonPressed(_ button: UIButton) {
        let entityPopUpController = DisplayEntitiesPopUpViewController(nibName: nil, bundle: nil)
        entityPopUpController.modalPresentationStyle = .popover
        present(entityPopUpController, animated: true, completion: nil)
        
        let popoverController = entityPopUpController.popoverPresentationController
        popoverController!.delegate = self as? UIPopoverPresentationControllerDelegate
        popoverController!.sourceView = button.superview!
        popoverController!.sourceRect = button.frame
        popoverController!.permittedArrowDirections = .up
        entityPopUpController.delegate = self
        entityPopUpController.reloadData()
    }
    
    
    @IBAction func editButtonPressed(_ button: UIButton) {
        let selectedItem = interactor!.getSelectedItem()
        editDelegate?.didPressEditButtonInDisplayDetailViewController(selectedItem: selectedItem)
    }

    
    @objc func selectMeetingGroupButtonPressed(_ sender: UIButton) {
        let meetingGroupsPopUpController = DisplayMeetingGroupsPopUpViewController(entity: getCurrentEntity())
        meetingGroupsPopUpController.modalPresentationStyle = .popover
        present(meetingGroupsPopUpController, animated: true, completion: nil)
        
        let popoverController = meetingGroupsPopUpController.popoverPresentationController
        popoverController!.delegate = self as? UIPopoverPresentationControllerDelegate
        popoverController!.sourceView = sender.superview!
        popoverController!.sourceRect = sender.frame
        popoverController!.permittedArrowDirections = .up
        meetingGroupsPopUpController.delegate = self
  //      meetingGroupsPopUpController.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = fields?.count {
            return num
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myIdentifier = "DetailCellView"
        let cell = tableView.dequeueReusableCell(withIdentifier: myIdentifier)
        let (title, detail) = fields![indexPath.row]
        cell?.textLabel?.text = title
        cell?.textLabel?.textColor = UIColor(white: 0.5, alpha: 1.0)
        cell?.detailTextLabel?.text = detail
        
        return cell!
    }

    
    // MARK: - EntityPopUpViewControllerDelegate methods
    
    func didSelectEntityInPopUpViewController(_ viewController: DisplayEntitiesPopUpViewController, entity: Entity) {
        dismiss(animated: false, completion: nil)
        detailButton.setTitle(entity.name, for: .normal)
        detailButton.setTitleColor(UIColor.black, for: .normal)
        detailButton.titleLabel?.textAlignment = .center
        setCurrentEntity(entity: entity)
        delegate?.didSelectEntityInDisplayDetailViewController(entity: entity)
    }
    
    
    // MARK: - MeetingGroupsPopUpViewControllerDelegate methods
    
    func didSelectMeetingGroupInPopUpViewController(_ viewController: DisplayMeetingGroupsPopUpViewController, meetingGroup: MeetingGroup) {
        dismiss(animated: false, completion: nil)
        selectMeetingGroupButton!.setTitle(meetingGroup.name, for: .normal)
        selectMeetingGroupButton!.setTitleColor(UIColor.black, for: .normal)
        selectMeetingGroupButton!.titleLabel?.textAlignment = .center
        delegate?.didSelectMeetingGroupInDisplayDetailViewController(meetingGroup: meetingGroup)
    }

}

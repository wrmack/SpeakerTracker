//
//  DisplayEntitiesPopUpViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 7/09/18.
//  Copyright © 2018 Warwick McNaughton. All rights reserved.
//

import UIKit

protocol EntitiesPopUpViewControllerDelegate: class {
    func didSelectEntityInPopUpViewController(_ viewController: DisplayEntitiesPopUpViewController, entity: Entity)
}

protocol DisplayEntitiesPopUpDisplayLogic: class {
    func displayEntities(viewModel: DisplayEntitiesPopUp.Entities.ViewModel)
}

class DisplayEntitiesPopUpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DisplayEntitiesPopUpDisplayLogic  {
    
    // MARK: Properties
    
    var interactor: DisplayEntitiesPopUpInteractor?
    weak var delegate: EntitiesPopUpViewControllerDelegate?
    private var theToolbar: UIView?
    private var theTitleLabel: UILabel?
    private var theTableView: UITableView?
    private var entityNames: [String]?
    
    // MARK: Constants
    
    private let BUTTON_Y: CGFloat = 27.0
    private let BUTTON_SPACE: CGFloat = 8.0
    private let BUTTON_HEIGHT: CGFloat = 30.0
    private let TITLE_Y: CGFloat = 8.0
    private let TITLE_HEIGHT: CGFloat = 28.0
    private let CANCEL_BUTTON_WIDTH: CGFloat = 56.0
    private let TOOLBAR_HEIGHT: CGFloat = 44.0  
    private let MAXIMUM_TABLE_WIDTH: CGFloat = 300.0
    private let MAXIMUM_TABLE_HEIGHT: CGFloat = 464.0
    private let TABLE_CELL_HEIGHT: CGFloat = 42.0
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        entityNames = [String]()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DisplayEntitiesPopUpViewController deinitialised")
    }

    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = DisplayEntitiesPopUpInteractor()
        let presenter = DisplayEntitiesPopUpPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white:0.8, alpha:1.0)
        self.preferredContentSize = CGSize(width: MAXIMUM_TABLE_WIDTH, height: MAXIMUM_TABLE_HEIGHT)
        
        let viewRect = self.view.bounds
        var toolbarRect = viewRect
        toolbarRect.size.height = TOOLBAR_HEIGHT
        toolbarRect.size.width = preferredContentSize.width
        theToolbar = UIView()
        self.view.addSubview(theToolbar!)
        
        /* ------------------------------  Toolbar auto layout --------------------------- */
        theToolbar!.translatesAutoresizingMaskIntoConstraints = false
        theToolbar!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        theToolbar!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        theToolbar!.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        theToolbar!.heightAnchor.constraint(equalToConstant: TOOLBAR_HEIGHT).isActive = true
        
        
        let toolbarWidth = theToolbar!.bounds.size.width
        let titleX = BUTTON_SPACE
        let titleWidth = (toolbarWidth - (BUTTON_SPACE + BUTTON_SPACE))
        let titleRect = CGRect(x: titleX, y: TITLE_Y, width: titleWidth, height: TITLE_HEIGHT)
        theTitleLabel = UILabel(frame:titleRect)
        theTitleLabel!.textAlignment = NSTextAlignment.center
        theTitleLabel!.font = UIFont.systemFont(ofSize: 19.0)
        theTitleLabel!.textColor = UIColor(white:0.0, alpha:1.0)
        theTitleLabel!.shadowColor = UIColor(white:0.65, alpha:1.0)
        theTitleLabel!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        theTitleLabel!.backgroundColor = UIColor.clear
        theTitleLabel!.shadowOffset = CGSize(width: 0.0, height: 1.0)
        theTitleLabel!.text = NSLocalizedString("Entities", comment:"title")
        theToolbar!.addSubview(theTitleLabel!)
        
        var tableRect = viewRect
        tableRect.origin.y += TOOLBAR_HEIGHT
        tableRect.size.height -= TOOLBAR_HEIGHT
        theTableView = UITableView(frame:tableRect)
        theTableView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        theTableView!.dataSource = self
        theTableView!.delegate = self
        theTableView!.rowHeight = TABLE_CELL_HEIGHT
        self.view.addSubview(theTableView!)
        
        fetchEntities()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theTableView!.reloadData()
        theTableView!.contentOffset = CGPoint.zero
    }
    
    override func viewDidAppear(_ animated:Bool) {
        super.viewDidAppear(animated)
        theTableView!.flashScrollIndicators()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        entityNames = [String]()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        theToolbar = nil
        theTitleLabel = nil
        theTableView = nil
        self.view = nil
        super.viewDidDisappear(animated)
    }
    
    
    // MARK: VIP
    
    func fetchEntities() {
        let request = DisplayEntitiesPopUp.Entities.Request()
        interactor?.fetchEntities(request: request) 
    }
    
    
    func displayEntities(viewModel: DisplayEntitiesPopUp.Entities.ViewModel) {
        entityNames = viewModel.entityNames!
        theTableView!.reloadData()
    }
    
    
    
    
    func reloadData() {
        entityNames = [String]()
    }
 
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if true {
            let entity = interactor!.getEntity(index: indexPath.row)
            delegate!.didSelectEntityInPopUpViewController(self, entity:entity!)
        }
    }
    
    
    
    // MARK: UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "popUpCell")
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"popUpCell")
            cell!.textLabel!.font = UIFont.systemFont(ofSize: 17.0)
            cell!.textLabel!.textAlignment = NSTextAlignment.center
            cell!.selectionStyle = UITableViewCellSelectionStyle.gray
        }
        if entityNames!.count == 0 {
            cell!.textLabel!.textColor = UIColor.lightGray
            cell!.textLabel!.text = "No entities set up"
            cell?.isUserInteractionEnabled = false
        } else {
            let entityName = entityNames![(indexPath).row]
            cell!.textLabel!.textColor = UIColor.black
            cell!.textLabel!.text = entityName
            cell?.isUserInteractionEnabled = true
        }
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        if entityNames!.count == 0 {
            return 1
        }
        return (entityNames!.count)
    }
    

}

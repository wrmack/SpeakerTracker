//
//  DisplayReportsViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 22/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol DisplayReportsViewControllerDelegate: class  {
    func didSelectEntityInDisplayReportsController(entity: Entity)
}

protocol DisplayReportsDisplayLogic: class {
    func displayReports(viewModel: DisplayReports.Reports.ViewModel)
}


class DisplayReportsViewController: UICollectionViewController, DisplayReportsDisplayLogic {
    var interactor: DisplayReportsBusinessLogic?
    var router: (NSObjectProtocol & DisplayReportsRoutingLogic & DisplayReportsDataPassing)?
    weak var delegate: DisplayReportsViewControllerDelegate?
    var thumbs = [ThumbFields]()
     
    
    

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
  // MARK: Setup
  
    private func setup() {
        let viewController = self
        let interactor = DisplayReportsInteractor()
        let presenter = DisplayReportsPresenter()
        let router = DisplayReportsRouter()
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
    
    
    @IBAction func unwindToDisplayReports(sender: UIStoryboardSegue) {
        let sourceViewController = sender.source
        // Pull any data from the view controller which initiated the unwind segue.
    }
    
  
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    
    func updateReports() {
        getReports()
    }
    
    
  //@IBOutlet weak var nameTextField: UITextField!
  
    // MARK: - VIP
    
    private func getReports() {
        let request = DisplayReports.Reports.Request()
        interactor?.getReports(request: request)  
    }
    
    
    internal func displayReports(viewModel: DisplayReports.Reports.ViewModel) {
        thumbs = viewModel.thumbFields! 
        collectionView?.reloadData()
    }
    
    
    
    // MARK: Collection view datasource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReportThumb", for: indexPath) as! WMCollectionViewCell
        cell.dateLabel.text = thumbs[indexPath.item].date
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReportsHeader", for: indexPath)
        header.backgroundColor = UIColor.lightGray
        return header
    }
    
    
    // MARK: - Collection view delegate methods
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item: \(indexPath.item)")
        interactor!.setSelectedItem(item: indexPath.item)
        router?.passSelectedItemToShowReport()
    }
    
    

}

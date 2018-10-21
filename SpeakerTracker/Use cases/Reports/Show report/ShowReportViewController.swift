//
//  ShowReportViewController.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 27/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ShowReportDisplayLogic: class {
    func displayText(viewModel: ShowReport.Report.ViewModel)
}



class ShowReportViewController: UIViewController, ShowReportDisplayLogic, UIActivityItemSource  {
    
    var interactor: ShowReportBusinessLogic?
    var router: (NSObjectProtocol & ShowReportRoutingLogic & ShowReportDataPassing)?
    var attText: NSAttributedString?
    

    @IBOutlet weak var attributedTextView: UITextView!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    
    // MARK: - Setup

    private func setup() {
        let viewController = self
        let interactor = ShowReportInteractor()
        let presenter = ShowReportPresenter()
        let router = ShowReportRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    
    // MARK: - Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

   
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        attributedTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        fetchText()
    }

    // MARK: - Button actions
    
    /*
     When share icon pressed, the attributed text is converted and saved to a pdf file.
     When saving is completed, the router calls the showSharePopUp method.
     */
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        interactor!.setAttText(attText: attText!)
        router!.routeToConvertToPdf()
    }
    
    
    // MARK: - VIP

    func fetchText() {
        let request = ShowReport.Report.Request()
        interactor?.fetchText(request: request)
    }


    func displayText(viewModel: ShowReport.Report.ViewModel) {
        attText = viewModel.attText
        attributedTextView.attributedText = attText
    }
    
    
    func showSharePopUp() {
        let items = [self]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        let popoverController = ac.popoverPresentationController
        popoverController!.delegate = self as? UIPopoverPresentationControllerDelegate
        popoverController!.sourceView = (shareButton.value(forKey: "view") as! UIView)
        popoverController!.sourceRect = (shareButton.value(forKey: "view") as! UIView).frame
        popoverController!.permittedArrowDirections = .up
        ac.completionWithItemsHandler = {  activityType, completed, returnedItems, activityError in
            self.interactor!.removePdf()
        }
    }
    
    
    
    // MARK: - UIActivityItemSource protocol methods
 
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentsDirectory as Any
    }
    
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
        return interactor!.getPdfUrl()
    }
    
    func activityViewController(_  activityViewController:UIActivityViewController, subjectForActivityType: UIActivity.ActivityType?) -> String {
        return "Subject line"
    }
}
 
//
//  ConvertToPdfInteractor.swift
//  SpeakerTracker
//
//  Created by Warwick McNaughton on 28/09/18.
//  Copyright (c) 2018 Warwick McNaughton. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreGraphics


protocol ConvertToPdfBusinessLogic {
    func convertToPdf(callback: @escaping ()->())
}

protocol ConvertToPdfDataStore {
    var attText: NSAttributedString? {get set}
    var pdfUrl: URL? {get set}
}

class ConvertToPdfInteractor: ConvertToPdfBusinessLogic, ConvertToPdfDataStore {
    var presenter: ConvertToPdfPresentationLogic?
    var attText: NSAttributedString?
    var pdfUrl: URL?
    
    
    // MARK: Do something

    func doSomething(request: ConvertToPdf.Something.Request) {

        let response = ConvertToPdf.Something.Response()
        presenter?.presentSomething(response: response)
    }
    
    
    func convertToPdf(callback: @escaping (()->())) {
        let tempDir = FileManager.default.temporaryDirectory
 
        pdfUrl = tempDir.appendingPathComponent("Meeting.pdf")
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595.2, height: 841.8))
        
        do {
            try renderer.writePDF(to: pdfUrl!, withActions: { context in
                context.beginPage()
                attText!.draw(in: CGRect(x: 40, y: 20, width: 515, height: 800))
                callback()
            })
        } catch {
            print(error)
        }
    }


}
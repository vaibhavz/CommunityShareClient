//
//  ReturnBikeController.swift
//  BikeShare
//
//  Created by Joyal Serrao on 26/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import UIKit

class ReturnBikeController: UIViewController {
    private var presenter =  ReturnBikePresenter()
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Title.returnBike
        presenter.attachView(self )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func enterForeground() {
        // Do stuff
        presenter.getLocationAfterEnble()
    }
    
    
    @IBAction func returnBikeAction(_ sender: Any) {
        presenter.returnBike()
    }
    
}

extension ReturnBikeController : ReturnBikeView {
    
    func userDetail(data: BikeRootModel) {
        self.lblName.text = data.name
    }
    
    func errorResponse() {
        
    }
    
    func returnBikeComplited() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func successfulCompletion(msg: String) {
        self.btnSubmit.isUserInteractionEnabled = true
        self.btnSubmit.setTitle("Return Bike", for: .normal)
        
        
        if !msg.isEmpty {
            self.alert(message: msg)
        }
    }
    
    func errorObtainLocation() {
        self.btnSubmit.isUserInteractionEnabled = false
        self.btnSubmit.setTitle("Turn On Location", for: .normal)
        self.createSettingsAlertController(title: "Location Off", message: "Please turn on Location")
    }
    
    
}



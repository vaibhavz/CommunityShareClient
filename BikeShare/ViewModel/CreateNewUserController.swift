//
//  CreateNewUserController.swift
//  BikeShare
//
//  Created by Joyal Serrao on 23/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import UIKit
import ColorSlider

class CreateNewUserController: UIViewController {
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPin: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var btnModifyPlace: UIButton!
    @IBOutlet weak var colorSlider: UIView!
    private let presentorCreatUser = CreatNewUserPresenter()
    private var location : Location?
    private var seletedColor :  String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = Title.joinToSystem
        presentorCreatUser.attachView(self)
        
        let slider = ColorSlider(orientation: .vertical, previewSide: .right)
        slider.frame =  CGRect(x: 0, y: 0, width:colorSlider.frame.size.width, height: 50)
        self.colorSlider.addSubview(slider)
        slider.addTarget(self, action:#selector(changedColor(_:)), for: .valueChanged)
        
        textFieldPin.delegate = self
        self.hideKeyboardWhenTappedAround()
        
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        seletedColor = slider.color.toHexString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func joinBtnAction(_ sender: Any) {
        presentorCreatUser.getUserData(name: textFieldName.text, color: seletedColor, pin: textFieldPin.text)
    }
}


extension CreateNewUserController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return range.location < 4
    }
}



extension CreateNewUserController : CreatNewUserView {
    
    func errorResponse() {
        self.alert(message: "Please Network Error")
    }
    
    func successfulCompletion(msg: String) {
        if (msg.isEmpty){
            self.navigationController?.popViewController(animated: true)
        }else{
            self.alert(message: msg)
        }
    }
    
    func validationError(msg: String) {
        self.alert(message: msg)
    }
    
    
    func errorObtainLocation() {
        self.createSettingsAlertController(title: "Location Off", message: "Please turn on Location")
    }
    
    func currentLocationName(name: String){
        self.textFieldLocation.text = name
        
    }
    
    
}




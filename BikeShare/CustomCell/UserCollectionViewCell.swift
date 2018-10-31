//
//  UserCollectionViewCell.swift
//  BikeShare
//
//  Created by Joyal Serrao on 22/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    var presenter = LocationPresenter()
    
    
    func updateView(data : BikeRootModel){
        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = bgView.frame.width/2
        lblTitle.text = data.name
        bgView.backgroundColor = UIColor(hexString: data.color)
        presenter.attachIntrector(self)
        presenter.currentDistanceCal(location: data.location)
    }
    
   
    
}

extension UserCollectionViewCell : LocationIntrector {
    

    func errorObtainLocation() {
        
    }
    func nearByFromCurrentLocation(distance:String){
        lblSubTitle.text =  distance
    }

}



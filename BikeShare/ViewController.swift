//
//  ViewController.swift
//  BikeShare
//
//  Created by Joyal Serrao on 20/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController {

    var presenter  : SearchNearByPresenter?
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let info = LocationInfo.init(latitude: 50.119504, longitude: 8.638137, radius: 500)
//        presenter = SearchNearByPresenter(info: info)
//        presenter?.attachView(self)
//        presenter?.nearByAllBikes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : NearByBikeView {
    func nearByBikes(bikeInfo: [BikeRootModel]) {
        
        print(bikeInfo)
        
        
    }    
    func failToFind() {
        
    }
    
 
}


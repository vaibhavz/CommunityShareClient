//
//  RentBikeController.swift
//  BikeShare
//
//  Created by Joyal Serrao on 25/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import UIKit
import GoogleMaps
class RentBikeController: UIViewController {
    
    @IBOutlet  weak private var lblName: UILabel!
    @IBOutlet  weak private var lblDistance: UILabel!
    @IBOutlet  weak private var colorOfBike: UIView!
    @IBOutlet weak private var bgMapView: UIView!
    @IBOutlet weak private var btnSubmit: UIButton!
    
    var presenter :  RentBikePresenter?
    var mapView: GMSMapView!
    private var selectedBike : BikeRootModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Title.rentBike
        self.btnSubmit.setTitle("Buy for Rent", for: .normal)
        presenter?.attachView(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buyRent(_ sender: Any) {
        presenter?.rentBike()
    }
    
    
    
}


extension RentBikeController : RentBikeView  {
    
    func rentBikeCurrentLocation(location: Location) {
        self.googleMapUI(current: location)
    }
    
    
    func nearByFromCurrentLocation(distance: String) {
        self.lblDistance.text = "Near By :" + distance
    }
    
    func userDetail(data: BikeRootModel) {
        selectedBike = data
        self.colorOfBike.backgroundColor = UIColor.init(hexString: data.color)
        self.lblName.text =  "Name :" + data.name
    }
    
    func successfulCompletion(msg: String) {
        
        if (msg.isEmpty){
            self.navigationController?.popViewController(animated: true)
        }else{
            self.alert(message: msg)
        }
    }
    
    func errorResponse() {
        
    }
    
    func errorObtainLocation(){
        
    }
    
    func alreadyRented() {
        
        self.alert(message: "Your already rented one buy, Please return it")
    }
    
    
    
    func googleMapUI(current:Location) {
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(current.latitude), longitude: CLLocationDegrees(current.longitude), zoom: 13.0)
        mapView = GMSMapView.map(withFrame: self.bgMapView.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isMyLocationEnabled = true
        self.bgMapView.addSubview(mapView)
        //   self.bgMapView.insertSubview(mapView, at: 0)
        
    }
    
    func drowPath(){
        let cameraPositionCoordinates = CLLocationCoordinate2D(latitude: 18.5203, longitude: 73.8567)
        let cameraPosition = GMSCameraPosition.camera(withTarget: cameraPositionCoordinates, zoom: 12)
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: cameraPosition)
        mapView.isMyLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(18.5203, 73.8567)
        marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)//CGPointMake(0.5, 0.5)
        marker.map = mapView
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2DMake(18.520, 73.856))
        path.add(CLLocationCoordinate2DMake(16.7, 73.8567))
        
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.map = mapView
        
        self.view = mapView
    }
    
}


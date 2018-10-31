//
//  LocationPresenter.swift
//  BikeShare
//
//  Created by Joyal Serrao on 23/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps



//CurrentLocation
protocol LocationIntrector : class  {
    
    func updateCurrentLocation(location: Location)
    func currentLocationName(name: String)
    func errorObtainLocation()
    func nearByFromCurrentLocation(distance:String)
}

extension LocationIntrector {
    func updateCurrentLocation(location: Location){}
    func currentLocationName(name: String){}
    func errorObtainLocation(){}
    func nearByFromCurrentLocation(distance:String){}

}


class LocationPresenter : NSObject {
    
    private var locationIntrector: LocationIntrector? // to communicte between Presentor
    override init() {}
    var locManager = CLLocationManager()

    func attachIntrector(_ intrector: LocationIntrector)  {
         locationIntrector = intrector
         currentLocation()
    }

    func currentLocation() {

        locManager.requestWhenInUseAuthorization()

        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {

            guard let currentLocation = locManager.location else {
                locationIntrector?.errorObtainLocation()
                return
            }
            let location = Location.init(lat: Float(currentLocation.coordinate.latitude), long: Float(currentLocation.coordinate.longitude))
          //  currentLocationView?.currentLocation(location: location)
            self.placeInfomation(location: location)
            self.locationIntrector?.updateCurrentLocation(location: location)
        } else {

            locationIntrector?.errorObtainLocation()
        }
    }


     func placeInfomation(location: Location) {
        let geocoder: GMSGeocoder = GMSGeocoder()
        let lat = CLLocationDegrees(location.latitude)
        let long = CLLocationDegrees(location.longitude)
        let cordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        geocoder.reverseGeocodeCoordinate(cordinate) { (gmsReverseGeocodeResponse, error) in
            if (gmsReverseGeocodeResponse != nil) {
                let gmsAddress: GMSAddress = (gmsReverseGeocodeResponse?.firstResult())!
                guard let cityName = gmsAddress.subLocality else {
                    self.locationIntrector?.errorObtainLocation()
                    return
                }
                let location = Location.init(lat: Float(gmsAddress.coordinate.latitude), long: Float(gmsAddress.coordinate.longitude))
               // self.currentLocationView?.currentLocationName(name: cityName, location: location)
                self.locationIntrector?.updateCurrentLocation(location: location)
                self.locationIntrector?.currentLocationName(name: cityName)
            } else {
                self.locationIntrector?.errorObtainLocation()
            }

        }
    }
    
     func currentDistanceCal(location:Location)  {
        guard let currentLocation = locManager.location else {
            self.locationIntrector?.errorObtainLocation()
            self.locationIntrector?.nearByFromCurrentLocation(distance: "")
        return
        }
        let lat =  CLLocationDegrees(location.latitude)
        let long =  CLLocationDegrees(location.longitude)
        let myBuddysLocation = CLLocation(latitude: lat, longitude: long)
        let distance = currentLocation.distance(from: myBuddysLocation) / 1000
        let formateResult = String(format: "%.2f km", distance)
        self.locationIntrector?.nearByFromCurrentLocation(distance: formateResult)
    }
    
    func  verifyLocationServicesEnabled(){
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            locationIntrector?.errorObtainLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                self.currentLocation()
            }
        } else {
            print("Location services are not enabled")
             locationIntrector?.errorObtainLocation()
        }
    }
    
    //&key=**************
  /// not used 
    func getPolylineFromCurrentLocation(destination: Location){
        
        guard let currentLocation = locManager.location else {
            locationIntrector?.errorObtainLocation()
            return
        }
        
        let lat =   currentLocation.coordinate.latitude
        let log =  currentLocation.coordinate.longitude

        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(lat),\(log)&destination=\(destination.latitude),\(destination.longitude)&key=AIzaSyBi0mPF9Lg04q46HrMsKRy3otqKC-eNpz8")
        let task = URLSession.shared.dataTask(with: url!) { (data:Data?, response:URLResponse?, error:Error?) in
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
                        print(url)
                        print(explanation)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

    

}

//extension LocationPresenter : CLLocationManagerDelegate {
//
//}


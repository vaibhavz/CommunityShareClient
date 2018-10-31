//
//  NearByBikeController.swift
//  BikeShare
//
//  Created by Joyal Serrao on 21/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import UIKit
import MapKit
class NearByBikeController: UIViewController {
    
    var presenter  : SearchNearByPresenter?
    private var listOfCycle : [BikeRootModel] = []
    private var seletedBike : BikeRootModel?
    @IBOutlet weak var btnReturn: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var hideCollectionView: NSLayoutConstraint!
    @IBOutlet weak var showCollectionView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Title.dashboard
        presenter = SearchNearByPresenter()
        presenter?.attachView(self)
        presenter?.allBikeInfo()
        mapView.delegate = self
        self.collectionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.allBikeInfo()
        self.btnReturn.isEnabled = UserDefaults.standard.isRented()
        
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
        presenter?.reflashLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            
            let controller = segue.destination as! RentBikeController
            controller.presenter = RentBikePresenter(data: seletedBike!)
            
        }
    }
    
    @IBAction func btnReturnBtnAction(_ sender: Any) {
        
        self.performSegue(withIdentifier: "return", sender: self)
        
    }
    @IBAction func addBikeBtnAction(_ sender: Any) {
        
        
    }
    @IBAction func segmentBtnAction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.presenter?.nearByAllBikes()
        case 1:
            self.presenter?.allBikeInfo()
        default: break
            
        }
        
    }
    
    
    
}







extension NearByBikeController : MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}


extension NearByBikeController : NearByBikeView {
    
    func errorObtainLocation(){
        self.createSettingsAlertController(title: "Location Off", message: "Please turn on Location")
    }
    
    
    func nearByBikes(bikeInfo: [BikeRootModel]) {
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        for info in bikeInfo {
            let coordinate2D = info.location
            let lat = coordinate2D.latitude
            let log = coordinate2D.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(log))
            annotation.title = info.name
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
            
        }
        listOfCycle = bikeInfo
        
        if (!listOfCycle.isEmpty) {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.hideCollectionView.isActive = false
                self?.showCollectionView.isActive = true}
        }
        
        self.collectionView.reloadData()
        
    }
    func failToFind() {
        
    }
    
    
}


extension NearByBikeController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfCycle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kUserCell", for: indexPath) as! UserCollectionViewCell
        cell.updateView(data: listOfCycle[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seletedBike = listOfCycle[indexPath.row]
        self.performSegue(withIdentifier: "detail", sender: self)
    }
    
}

extension NearByBikeController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth/3, height: collectionViewWidth/3)
    }
    
    
}




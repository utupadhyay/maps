//
//  ViewController.swift
//  maps
//
//  Created by Utkarsh Upadhyay on 08/10/17.
//  Copyright © 2017 Utkarsh Upadhyay. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps


class mapsViewController: UIViewController, CLLocationManagerDelegate {
    

    @IBOutlet weak var myView: UIView!
    var locationManger: CLLocationManager?
    var mapView: GMSMapView?
    var camera: GMSCameraPosition?
    var marker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger = CLLocationManager()
        mapView = GMSMapView()
        camera = GMSCameraPosition()
        self.locationManger?.delegate = self
        self.locationManger?.desiredAccuracy = 10;
        self.locationManger?.requestWhenInUseAuthorization()
        self.locationManger?.startUpdatingLocation()
        
    }
    
       override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let frame = CGRect(x: 10, y: 10, width: self.myView.frame.size.width - 100, height: self.myView.frame.size.width - 100)
        let label = UILabel(frame: frame)
        label.backgroundColor = UIColor.white
        label.text = "direction"
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: Selector(("directionTapped")))
        label.addGestureRecognizer(tap)
        
        mapView!.settings.consumesGesturesInView = false
        mapView!.addSubview(label)
        mapView!.bringSubview(toFront: label)
        
    }
    
 func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    
    
   
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManger?.stopUpdatingLocation()
    }
    
    
    func showCurrentLocationOnMap()
    {
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManger?.location?.coordinate.latitude)! , longitude: (self.locationManger?.location?.coordinate.longitude)!, zoom: 15)
        
        let frame = CGRect(x: 0, y: 0, width: self.myView.frame.size.width, height: self.myView.frame.size.height)
        let mapView = GMSMapView.map(withFrame: frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        marker?.position = camera.target
        marker?.snippet = "current location"
        marker?.appearAnimation = GMSMarkerAnimation.pop
        marker?.map = mapView
        self.myView?.addSubview(mapView)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


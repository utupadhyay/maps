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
import GooglePlaces


class mapsViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    
    @IBOutlet weak var myView: UIView!
    var locationManger: CLLocationManager?
    var mapView: GMSMapView?
    var camera: GMSCameraPosition?
    var marker: GMSMarker?
    // var rectangle = GMSPolyline()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger = CLLocationManager()
        mapView = GMSMapView()
        self.mapView?.settings.consumesGesturesInView = false
        mapView?.isMyLocationEnabled = true
        mapView?.settings.compassButton = true
        mapView?.isUserInteractionEnabled = true
        camera = GMSCameraPosition()
        self.locationManger?.delegate = self
        self.locationManger?.desiredAccuracy = 10;
        self.locationManger?.requestWhenInUseAuthorization()
        self.locationManger?.startUpdatingLocation()
        
        
        
        
        
    }
    
    
    //
    // func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    //
    //    let frame = CGRect(x: 10, y: 10, width: self.myView.frame.size.width - 100, height: self.myView.frame.size.width - 100)
    //    let label = UILabel(frame: frame)
    //    label.backgroundColor = UIColor.white
    //    label.text = "direction"
    //    label.textAlignment = .center
    //    label.layer.cornerRadius = 10
    //    label.clipsToBounds = true
    //    label.isUserInteractionEnabled = true
    //
    //    let tap = UITapGestureRecognizer(target: self, action: Selector(("directionTapped")))
    //    label.addGestureRecognizer(tap)
    //
    //    mapView.settings.consumesGesturesInView = false
    //    mapView.addSubview(label)
    //    mapView.bringSubview(toFront: label)
    //    print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    //
    //    }
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showCurrentLocationOnMap()
        self.locationManger?.stopUpdatingLocation()
    }
    
    
    func showCurrentLocationOnMap()
    {
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManger?.location?.coordinate.latitude)! , longitude: (self.locationManger?.location?.coordinate.longitude)!, zoom: 15)
        
        let frame = CGRect(x: 0, y: 0, width: self.myView.frame.size.width, height: self.myView.frame.size.height)
        let x = GMSMapView.map(withFrame: frame, camera: camera)
        x.delegate = self
        x.settings.myLocationButton = true
        x.isMyLocationEnabled = true
        marker?.position = camera.target
        marker?.snippet = "current location"
        marker?.appearAnimation = GMSMarkerAnimation.pop
        marker?.map = mapView
        self.myView?.addSubview(x)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        let origin = "20.018669571048509,73.856100164353848"
        let destination = "\(coordinate.latitude),\(coordinate.longitude)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyDUcTxWA-xxNbUx3lkaGfg9OG4Mzfnheh4"
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    
                    DispatchQueue.main.async {
                        let frame = CGRect(x: 0, y: 0, width: self.myView.frame.size.width, height: self.myView.frame.size.height)
                        let x = GMSMapView.map(withFrame: frame, camera: self.camera!)
                        x.clear()
                        
                        
                        OperationQueue.main.addOperation({
                            for route in routes
                            {
                                
                                let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                                let points = routeOverviewPolyline.object(forKey: "points")
                                let path = GMSPath.init(fromEncodedPath: points! as! String)
                                let polyline = GMSPolyline.init(path: path)
                                polyline.strokeWidth = 3
                                
                                let bounds = GMSCoordinateBounds(path: path!)
                                x.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                                
                                polyline.map = x
                                
                            }
                        })
                    }
                    
                    
                }catch let error as NSError{
                    print("error:\(error)")
                }
            }
        }).resume()
        
        
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


//
//  ViewController.swift
//  Places
//
//  Created by MAC on 2017-12-27.
//  Copyright © 2017 lcpunch. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var objectPlaces = Places()
    var lat = 0.0
    var lon = 0.0
    var name = ""
    
    @IBOutlet var map: MKMapView!
    
    var manager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
        
        if self.objectPlaces.activePlace == -1 {
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        } else if verifyRegionParams() {
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            self.map.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = name
            self.map.addAnnotation(annotation)
        }
        
        
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state != UIGestureRecognizerState.began {
            return
        }
        
        let touchPoint = gestureRecognizer.location(in: self.map)
        let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
        let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        var title = ""
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                
                print(error!)
            } else {
                
                if let placemark = placemarks?[0] {
                    
                    if placemark.subThoroughfare != nil {
                        title += "\(String(describing: placemark.subThoroughfare!)) "
                    }
                    
                    if placemark.thoroughfare != nil {
                        title += "\(String(describing: placemark.thoroughfare!))"
                    }
                    
                }
            }
            
            if title == "" {
                title = "Added \(NSDate())"
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinate
            annotation.title = title
            self.map.addAnnotation(annotation)
            self.objectPlaces.places.append(["name": title,
                                "lat": String(newCoordinate.latitude),
                                "lon": String(newCoordinate.longitude)])
            UserDefaults.standard.set(self.objectPlaces.places, forKey: "places")
        }
    }
    
    func verifyRegionParams() -> Bool {
        
        let activePlace = self.objectPlaces.activePlace
        let places = self.objectPlaces.places
        
        if activePlace == -1 {
            return false
        }
        
        if places.count <= activePlace {
            return false
        }
        
        if let name = places[activePlace]["name"] {
            self.name = name
        }
        
        if let lat = Double(places[activePlace]["lat"]!) {
            self.lat = lat
        }
                
        if let lon = Double(places[activePlace]["lon"]!) {
            self.lon = lon
        }
        
        return true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }

}


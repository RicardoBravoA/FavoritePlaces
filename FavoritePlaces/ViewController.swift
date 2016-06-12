//
//  ViewController.swift
//  FavoritePlaces
//
//  Created by Ricardo Bravo Acuña on 12/06/16.
//  Copyright © 2016 Ricardo Bravo Acuña. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if index == -1{
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }else{
            let latitude = NSString(string: places[index][lat]!).doubleValue
            let longitude = NSString(string: places[index][lon]!).doubleValue
            
            let latDelta:CLLocationDegrees = 0.01
            let lonDelta:CLLocationDegrees = 0.01
            let span = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let region = MKCoordinateRegionMake(coordinate, span)
            
            self.mapView.setRegion(region, animated: true)
            
            let annotation  = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = places[index][description]
            
            self.mapView.addAnnotation(annotation)
            
        }
        
        
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.gestureDetected(_:)))
        gesture.minimumPressDuration = 1
        mapView.addGestureRecognizer(gesture)
        
    }
    
    func gestureDetected(gestureRecognizer: UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.Recognized {
            let touchPoint = gestureRecognizer.locationInView(self.mapView)
            let newCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                var title = ""
                
                if let p = placemarks?.first {
                    
                    if p.thoroughfare != nil {
                        title +=  "\(p.thoroughfare!)"
                    }
                    
                    if p.subThoroughfare != nil {
                        title +=  "\(p.subThoroughfare!)"
                    }
                    
                }
                
                if title == "" {
                    title = "Punto añadido el \(NSDate())"
                }
                
                let annotation  = MKPointAnnotation()
                annotation.coordinate = newCoordinate
                annotation.title = title
                
                self.mapView.addAnnotation(annotation)
                
                places.append([desc: title, lat: "\(newCoordinate.latitude)", lon: "\(newCoordinate.longitude)"])
                
                preference.setValue(places, forKeyPath: userData)
                
            })
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
            
            let latDelta:CLLocationDegrees = 0.01
            let lonDelta:CLLocationDegrees = 0.01
            let span = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let region = MKCoordinateRegionMake(coordinate, span)
            
            self.mapView.setRegion(region, animated: true)
        }
    }


}


//
//  ViewController.swift
//  LastMap
//
//  Created by Mohamed Arafa on 10/17/19.
//  Copyright © 2019 Mohamed Arafa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var OT_MapView: MKMapView!
    
    let location: String? = "30.805081,30.995290"
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: CLLocationDistance = 1000
    var customCoordinate = CLLocationCoordinate2D(latitude: 30.805081, longitude: 30.995290)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //locationManager.allowsBackgroundLocationUpdates = true
        
        // Location
        fixLocation()
        
        configureLocationServices()
        centerMapOnCenterLocation()
        addCustomPlaceAnnotation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OT_MapView.delegate = self
        
    }
    
    
    //MARK: IBAction
    
    @IBAction func currentLocationBTNPressed(_ sender: UIButton) {
        
        centerMapOnMyLocation()
    }
    
    @IBAction func DistinationLocationBtnPressed(_ sender: UIButton) {
        
        centerMapOnCenterLocation()
    }
    
    @IBAction func DirectionBtnPressed(_ sender: UIButton) {
        
        makeADirection()
    }
    
    @IBAction func MapSegmentControllPressed(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            
            OT_MapView.mapType = .standard
            
        }else if sender.selectedSegmentIndex == 1{
            OT_MapView.mapType = .satellite
        }else{
            OT_MapView.mapType = .satelliteFlyover
        }
        
    }
    
}

extension ViewController{
    //"30.805081,30.995290"
    func fixLocation()  {
        
        guard let location = location, !location.isEmpty else { return }
        
        // to determination the space of the Comma in location string
        if location.contains(",") {
            let range: Range<String.Index> = location.range(of: ",")!
            let indexOfComma: Int = location.distance(from: location.startIndex, to: range.lowerBound)
            
            // to take the latitude and longitude value from location string
            let latitude = Double(location[0..<indexOfComma])!
            let longitude = Double(location[(indexOfComma + 1)..<(location.count)])!
            
            customCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
        } else {
            customCoordinate = CLLocationCoordinate2D(latitude: 30.805081, longitude: 30.9952908)
        }
    }
}


extension ViewController : MKMapViewDelegate{
    
    func centerMapOnMyLocation(){
        
        guard let myLocation = locationManager.location?.coordinate else { return }
        
        let coordinateRegion = MKCoordinateRegion(center: myLocation, latitudinalMeters: regionRadius , longitudinalMeters: regionRadius )
        
        OT_MapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnCenterLocation(){
        
        //        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: customCoordinate, latitudinalMeters: regionRadius , longitudinalMeters: regionRadius )
        
        OT_MapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addCustomPlaceAnnotation()  {
        
        let annotation = DroppablePin(coordinate: customCoordinate, identifire: "Custom", subtitle: " \(NSLocalizedString("there is Our Branch in", comment: "our branche location")) \("branch.name")  ", title: "\(NSLocalizedString("New Concept Center", comment: "our branch"))")
        
        OT_MapView.addAnnotation(annotation)
    }
    
}

extension ViewController : CLLocationManagerDelegate{
    
    func configureLocationServices()  {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    
}


//MARK: Make A Direction On mapView
extension ViewController{
    
    func makeADirection()  {
        
        guard let myLocation = locationManager.location?.coordinate else { return }
        
        let sourcePlaceMark = MKPlacemark(coordinate: myLocation)
        let destinationPlaceMark = MKPlacemark(coordinate: customCoordinate)
        
        let directionRequest = MKDirections.Request()
        //Source
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        //distination
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        //moving
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResonse = response else {
                if let error = error {
                    print("we have error getting directions==\(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResonse.routes[0]
            self.OT_MapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.OT_MapView.setRegion(MKCoordinateRegion(rect), animated: true)
            
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        renderer.lineWidth = 4.0
        return renderer
    }
    
}



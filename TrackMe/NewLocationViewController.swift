//
//  NewLocationViewController.swift
//  Capstone
//
//  Created by Joshua Bates on 7/5/16.
//  Copyright © 2016 Joshua Bates. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NewLocationViewController: UIViewController {
    
    var region: CLCircularRegion? = nil

    // MARK: - IBOutlets
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLongTouch()
        setUpMap()
        distanceTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func mapViewLongPress(sender: AnyObject) {
        let point = longPressRecognizer.locationInView(mapView)
        let touchCoordinate = mapView.convertPoint(point, toCoordinateFromView: mapView)
        
        mapSelectionPoint.coordinate = touchCoordinate
        mapView.removeAnnotation(mapSelectionPoint)
        mapView.addAnnotation(mapSelectionPoint)
    }
    
    @IBAction func addressGoButtonPressed(sender: AnyObject) {
        guard !addressTextField.text!.isEmpty else { return }
        guard let address = addressTextField.text else { return }
        geoCoder.cancelGeocode()
        geoCoder.geocodeAddressString(address) { (placemark, error) in
            if error != nil {
                print("GeoCoding error: \(error)")
            } else {
                guard let placemark = placemark, let first = placemark.first, let location = first.location else { return }
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let coordinates = location.coordinate
                let addressRegion = MKCoordinateRegionMake(coordinates, span)
                self.mapView.setRegion(addressRegion, animated: true)
                self.geoCoder.cancelGeocode()
                self.mapSelectionPoint.coordinate = coordinates
                self.mapView.removeAnnotation(self.mapSelectionPoint)
                self.mapView.addAnnotation(self.mapSelectionPoint)
            }
        }
    }
    
    @IBAction func saveLocationButtonPressed(sender: AnyObject) {
        if !(locationNameTextField.text?.isEmpty)! && !(distanceTextField.text?.isEmpty)! {
            guard let locationName = locationNameTextField.text, let distanceText = distanceTextField.text else { return }
            guard let distance = Double(distanceText) else { return }
            RegionController.createRegion(mapSelectionPoint.coordinate, radius: distance, name: locationName)
            
            // MARK: - Location Permissions
            guard let manager = (UIApplication.sharedApplication().delegate as? AppDelegate)?.manager else { return }
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                manager.requestAlwaysAuthorization()
                manager.startUpdatingLocation()
            } else if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
                manager.startUpdatingLocation()
            }
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        }
    }
    
    
    
    // MARK: - Constants 
    
    let geoCoder = CLGeocoder()
    
    // MARK: - Variables
    
    var mapSelectionPoint = MKPointAnnotation()
    var distanceCircleOverlay = MKCircle()
    
    // MARK: - Computed Properties
    
    var selectedPointCoordinates: CLLocationCoordinate2D {
        return mapSelectionPoint.coordinate
    }
    
    func setUpLongTouch() {
        longPressRecognizer.minimumPressDuration = 1.0
    }
    
}

extension NewLocationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        guard mapView.annotations.count >= 1 else { return }
        mapView.removeOverlay(distanceCircleOverlay)
        setUpDistanceCircleOverlay()
    }
}

extension NewLocationViewController: MKMapViewDelegate {
    func setUpMap() {
        mapView.delegate = self
        mapView.rotateEnabled = false
        
        if region != nil {
            guard let region = region else { return }
            mapSelectionPoint.coordinate = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
            mapView.removeAnnotation(mapSelectionPoint)
            mapView.addAnnotation(mapSelectionPoint)
            distanceTextField.text = String(region.radius)
            self.title = region.identifier
            locationNameTextField.text = region.identifier
            locationNameTextField.hidden = true
            setUpDistanceCircleOverlay()
            searchStackView.hidden = true
            
            
            let zoomRegion = MKCoordinateRegion(center: mapSelectionPoint.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(zoomRegion, animated: true)
            
        }
        // MARK: Need to set up initial region
        
    }
    
    func setUpDistanceCircleOverlay() {
        guard let distanceText = distanceTextField.text else { return }
        guard let distance = Double(distanceText) else { return }
        distanceCircleOverlay = MKCircle(centerCoordinate: mapSelectionPoint.coordinate, radius: distance) // Radius is in meters
        mapView.removeOverlay(distanceCircleOverlay)
        mapView.addOverlay(distanceCircleOverlay)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = AppearanceController.darkGreen.colorWithAlphaComponent(0.6)
            circleRenderer.fillColor = AppearanceController.darkGreen.colorWithAlphaComponent(0.2)
            circleRenderer.lineWidth = 3.0
            return circleRenderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

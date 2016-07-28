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
    
    // MARK: - IBOutlets
    
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    // MARK: - Properties
    
    private let geoCoder = CLGeocoder()
    
    var region: CLCircularRegion?
    
    private var mapSelectionPoint = MKPointAnnotation()
    private var distanceCircleOverlay = MKCircle()
    
    private var selectedPointCoordinates: CLLocationCoordinate2D {
        return mapSelectionPoint.coordinate
    }
    
    // MARK: - View Controller Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMap()
        setUpAppearance()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - IBActions
    
    @IBAction func mapViewLongPress(sender: AnyObject) {
        let point = longPressRecognizer.locationInView(mapView)
        let touchCoordinate = mapView.convertPoint(point, toCoordinateFromView: mapView)
        mapSelectionPoint.coordinate = touchCoordinate
        addAnnotation(mapSelectionPoint)
    }
    
    @IBAction func saveLocationButtonPressed(sender: AnyObject) {
        guard let locationName = locationNameTextField.text, let distanceText = distanceTextField.text where !locationName.isEmpty && !distanceText.isEmpty else { return }
        guard let distance = Double(distanceText) else { return }
        LocationController.createRegion(mapSelectionPoint.coordinate, radius: distance, name: locationName)
        LocationController.askForLocationPermissions()
        navigationController?.popViewControllerAnimated(true)
    }
    
}

// MARK: - Private functions

private extension NewLocationViewController {
    
    private func setUpMap() {
        guard let region = region else { return }
        mapSelectionPoint.coordinate = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
        addAnnotation(mapSelectionPoint)
        distanceTextField.text = String(region.radius)
        title = region.identifier
        locationNameTextField.text = region.identifier
        locationNameTextField.hidden = true
        addressTextField.hidden = true
        setUpDistanceCircleOverlay()
        let zoomRegion = MKCoordinateRegion(center: mapSelectionPoint.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    private func setUpDistanceCircleOverlay() {
        guard let distanceText = distanceTextField.text, distance = Double(distanceText) else { return }
        distanceCircleOverlay = MKCircle(centerCoordinate: mapSelectionPoint.coordinate, radius: distance) // Radius is in meters
        mapView.removeOverlay(distanceCircleOverlay)
        mapView.addOverlay(distanceCircleOverlay)
    }
    
    private func setUpAppearance() {
        view.backgroundColor = .offWhite
        view.tintColor = .darkGreen
        leftView.backgroundColor = .offWhite
        rightView.backgroundColor = .offWhite
    }
    
    private func geoCodeAddress(address: String) {
        LocationController.geoCodeAddress(address, geoCoder: geoCoder) { coordinate in
            guard let coordinate = coordinate else { return }
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let addressRegion = MKCoordinateRegionMake(coordinate, span)
            self.mapView.setRegion(addressRegion, animated: true)
            self.geoCoder.cancelGeocode()
            self.mapSelectionPoint.coordinate = coordinate
            self.addAnnotation(self.mapSelectionPoint)
        }
    }
    
    private func addAnnotation(annotation: MKPointAnnotation) {
        mapView.removeAnnotation(annotation)
        mapView.addAnnotation(annotation)
    }
}

// MARK: - TextField Delegate

extension NewLocationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard mapView.annotations.count >= 1 else { return }
        setUpDistanceCircleOverlay()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == locationNameTextField {
            distanceTextField.becomeFirstResponder()
            return true
        } else if textField == addressTextField {
            if let address = addressTextField.text where !address.isEmpty {
                geoCodeAddress(address)
            }
        }
        dismissKeyboard()
        return true
    }
}

// MARK: - MapViewDelegate

extension NewLocationViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.darkGreen.colorWithAlphaComponent(0.6)
            circleRenderer.fillColor = UIColor.darkGreen.colorWithAlphaComponent(0.2)
            circleRenderer.lineWidth = 3.0
            return circleRenderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
}

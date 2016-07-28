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
        mapView.removeAnnotation(mapSelectionPoint)
        mapView.addAnnotation(mapSelectionPoint)
    }
    
    @IBAction func saveLocationButtonPressed(sender: AnyObject) {
        guard let locationName = locationNameTextField.text, let distanceText = distanceTextField.text where !locationName.isEmpty && !distanceText.isEmpty else { return }
        guard let distance = Double(distanceText) else { return }
        RegionController.createRegion(mapSelectionPoint.coordinate, radius: distance, name: locationName)
        RegionController.askForLocationPermissions()
        navigationController?.popViewControllerAnimated(true)
    }
    
}

// MARK: - Private functions

private extension NewLocationViewController {
    
    private func setUpMap() {
        guard let region = region else { return }
        mapSelectionPoint.coordinate = CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude)
        mapView.removeAnnotation(mapSelectionPoint)
        mapView.addAnnotation(mapSelectionPoint)
        distanceTextField.text = String(region.radius)
        title = region.identifier
        locationNameTextField.text = region.identifier
        locationNameTextField.hidden = true
        addressTextField.hidden = true
        setUpDistanceCircleOverlay()
        let zoomRegion = MKCoordinateRegion(center: mapSelectionPoint.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    private func setUpAppearance() {
        view.backgroundColor = UIColor.offWhite
        view.tintColor = UIColor.darkGreen
        leftView.backgroundColor = UIColor.offWhite
        rightView.backgroundColor = UIColor.offWhite
    }
    
    private func setUpDistanceCircleOverlay() {
        guard let distanceText = distanceTextField.text else { return }
        guard let distance = Double(distanceText) else { return }
        distanceCircleOverlay = MKCircle(centerCoordinate: mapSelectionPoint.coordinate, radius: distance) // Radius is in meters
        mapView.removeOverlay(distanceCircleOverlay)
        mapView.addOverlay(distanceCircleOverlay)
    }
    
}

// MARK: - TextField Delegate

extension NewLocationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard mapView.annotations.count >= 1 else { return }
        mapView.removeOverlay(distanceCircleOverlay)
        setUpDistanceCircleOverlay()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == addressTextField {
            guard !addressTextField.text!.isEmpty else { return false }
            guard let address = addressTextField.text else { return false }
            geoCoder.cancelGeocode()
            geoCoder.geocodeAddressString(address) { placemark, error in
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
        self.dismissKeyboard()
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

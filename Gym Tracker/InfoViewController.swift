//
//  ViewController.swift
//  Gym Tracker
//
//  Created by Yi-Jui, Chiu on 7/13/17.
//  Copyright © 2017 AaronChiu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class InfoViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate {
    
    var lat : Double = 0.0
    var long : Double = 0.0
    
    @IBOutlet weak var googleMapContainer: GMSMapView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var daysTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    var locationManager = CLLocationManager()
    var autoCompleteController = GMSAutocompleteViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationTextField.addTarget(self, action: #selector(textFieldDidChange), for: .touchDown)
        
        
 
    }
    
    func textFieldDidChange(){
        print("touch location")
//        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
//    func createMap(_ lat : Double, _ long : Double){
//        print("lat: ", lat)
//        print("long: ", long)
//        
//        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
//        
//        self.googleMapContainer.camera = camera
//        
//        
//        self.googleMapContainer.delegate = self
//        self.googleMapContainer.isMyLocationEnabled = true
//        self.googleMapContainer.settings.myLocationButton = true
//
//    
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = self.googleMapContainer
//
//        
//        
//        
//        
//    }
    
    
    
    

    @IBAction func getLocationBtnPressed(_ sender: UIButton) {
        
            print(locationTextField.text!)

    }
    
    
    
//    func getJsonLAtLng(_ location : String){
//        
//        let myGroup = DispatchGroup()
//        myGroup.enter()
//        let locationWithoutSpace = location.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
//        
//        let address = "https://maps.googleapis.com/maps/api/geocode/json?&address=\(locationWithoutSpace)"
//        
//        let url = URL(string : address)
//        let task = URLSession.shared.dataTask(with: url!){ (data,response, error) in
//            if let content = data {
//                do{
//                    let myJSON = try JSONSerialization.jsonObject(with: content, options: []) as AnyObject
//                    if let lac = myJSON["results"]  {
//                        let array = (lac! as! NSArray).mutableCopy() as! NSMutableArray
//                        
//                        if let location = array[0] as? NSDictionary{
//                            if let aaa = location["geometry"]! as? NSDictionary {
//                                if let location = aaa["location"]! as? NSDictionary {
//                                    self.lat = location["lat"]! as! Double
//                                    self.long = location["lng"]! as! Double
//                                    myGroup.leave()
//                                    
//                                }
//                                
//                            }
//                        }
//                    }
//                }catch{                }
//            }
//        }
//        task.resume()
//        myGroup.notify(queue: .main) {
//            self.createMap(self.lat, self.long)
//        }
//    }
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location \(error)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("click current location")
        let location = locations.last

        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 12)
        self.googleMapContainer.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        marker.title = "Current location"
        marker.map = self.googleMapContainer
        
        
        
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googleMapContainer.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googleMapContainer.isMyLocationEnabled = true
        if(gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("resultQQQQQQQQ: ", place)
        
        locationTextField.text = place.formattedAddress
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 12.0)
        self.googleMapContainer.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        marker.title = place.formattedAddress
        marker.map = self.googleMapContainer
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error AutoComplete: \(error)")
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

}




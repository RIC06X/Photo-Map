//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

/* -- Comment -- */

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
    
    /* ---- TODO: Create mapView outlet*/
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoButton: UIButton!
    
    
    
    // Store picked image
    var pickedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView.delegate = self
        navigationController?.navigationBar.isHidden = true
        setInitialLocation()
        mapView.delegate = self
    }

    /* ------ TODO: Set initial location after launching app */
    func setInitialLocation(){
        let mapCenter = CLLocationCoordinate2D(latitude: 33.6450, longitude: -117.8443)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
        mapView.setRegion(region, animated: false)
    }
    
    
    /* ----- TODO: Instantiate UIImagePicker after camera button tapped */
    @IBAction func onTapCameraBtn(_ sender: Any) {
        selectPhoto()
    }
    
    
    /* ----- TODO: Override prepare (for segue) funcion to show Present LocationsViewController */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationViewController = segue.destination as! LocationsViewController
        locationViewController.delegate = self
    }
     
    
    /* ----- TODO: Retrieve coordinates from LocationsViewController   */
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        addPin(lat: CLLocationDegrees(truncating: latitude), lng: CLLocationDegrees(truncating: longitude))
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    /* ----- TODO: add pin to the map */
    func addPin(lat: CLLocationDegrees, lng: CLLocationDegrees){
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        annotation.coordinate = locationCoordinate
        annotation.title = String(describing: lat)
        
        mapView.addAnnotation(annotation)
    }
    
    /* ----- TODO: Customize mapview to add custom map notations */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }

        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        // Add the image you stored from the image picker
        imageView.image = pickedImage

        return annotationView
    }
  
    
    // Instantiate Image Picker and set delegate to this view controller
    func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        // Present camera, if available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            imagePicker.sourceType = .camera
            
            // Present photo library
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            imagePicker.sourceType = .photoLibrary
            // Present imagePicker source type (either camera or library)
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // Get the image captured by the UIImagePickerController
        let _ = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
        let editedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage
        
        // Do something with the images (based on your use case)
        pickedImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        }
        
    }

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

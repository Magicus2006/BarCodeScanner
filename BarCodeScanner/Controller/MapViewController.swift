//
//  MapViewController.swift
//  BarCodeScanner
//
//  Created by Дмитрий Кондратьев on 10.04.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let initialLocation = CLLocation(latitude: 52.723598, longitude: 41.4423062)
        mapView.centerToLocate(initialLocation)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension MKMapView {
    func centerToLocate(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion( center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
        
    }
}

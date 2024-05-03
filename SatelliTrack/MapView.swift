//
//  MapView.swift
//  SatelliTrack
//
//  Created by Hugo Pereira on 02/05/2024.
//

// TODO: Add the user location annotation
// TODO: Add a button to center the map on the user location
// TODO: Add the satellite name to the annotation
// TODO: Stop removing all annotations and only update the existing ones
// TODO: Add a search bar to filter the satellites by name

import SwiftUI
import MapKit

// Custom annotation
let CIRCLE_DIAMETER: CGFloat = 10
let CIRCLE_COLOR = UIColor.systemRed
let CIRCLE_BORDER_COLOR = UIColor.white
let CIRCLE_BORDER_WIDTH: CGFloat = 2

/// Map view to display the satellites
struct MapView: UIViewRepresentable {
    
    var satellites: [Satellite]
    
    private let CUPERTINO_LATITUDE = 37.3229978
    private let CUPERTINO_LONGITUDE = -122.0321823
    private let ALTITUDE = 35000000.0
    private let REFRESH_FREQUENCY = 2.0

    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    /// Update the map view with the new annotations, camera settings and refresh frequency
    /// - Parameters:
    ///   - uiView: the map view
    ///   - context: context
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        TimerStorage.removeTimer()
        
        let cupertinoCoordinate = CLLocationCoordinate2D(latitude: CUPERTINO_LATITUDE, longitude: CUPERTINO_LONGITUDE)
        let span = MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 90)
        let region = MKCoordinateRegion(center: cupertinoCoordinate, span: span)
        
        // Register the custom annotation view
        uiView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        uiView.setRegion(region, animated: true)
        uiView.mapType = .satelliteFlyover // or .hybridFlyover

        let camera = MKMapCamera()
        camera.centerCoordinate = cupertinoCoordinate
        camera.altitude = ALTITUDE //min: 1000000000
        camera.pitch = 0
        camera.heading = 0
        uiView.setCamera(camera, animated: true)
        
        // Add the annotations and refresh them every REFRESH_FREQUENCY seconds
        updateAnnotations(uiView: uiView)
        let timer_reference = Timer.scheduledTimer(withTimeInterval: REFRESH_FREQUENCY, repeats: true) { _ in
            updateAnnotations(uiView: uiView)
        }
        TimerStorage.addTimer(timer: timer_reference)
        
    }
    
    /// Update the annotations on the map view
    /// - Parameter uiView: the map view
    func updateAnnotations(uiView: MKMapView) {
        uiView.removeAnnotations(uiView.annotations)
        for satellite in satellites {
            guard let coordinate = TLEParser.extractCoordinate(from: satellite) else { return }
            uiView.addAnnotation(CustomAnnotation(coordinate: coordinate, name: satellite.name))
        }
    }
    
    /// Create a new annotation
    /// - Parameters:
    ///   - coordinate: annotation coordinate
    ///   - title: annotation title
    /// - Returns: the annotation
    func createAnnotation(at coordinate: CLLocationCoordinate2D, titled title: String) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        return annotation
    }
}

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var name: String
    
    init(coordinate: CLLocationCoordinate2D, name: String){
        self.coordinate = coordinate
        self.name = name
    }
}

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            self.image = UIImage.circle(diameter: CIRCLE_DIAMETER, color: CIRCLE_COLOR, borderColor: CIRCLE_BORDER_COLOR, borderWidth: CIRCLE_BORDER_WIDTH)
        }
    }
}

extension UIImage {
    static func circle(diameter: CGFloat, color: UIColor, borderColor: UIColor = .white, borderWidth: CGFloat = 0) -> UIImage {
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        // Fill circle with the specified color
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        // Draw border if borderWidth is greater than 0
        if borderWidth > 0 {
            context.setStrokeColor(borderColor.cgColor)
            context.setLineWidth(borderWidth)
            let borderRect = CGRect(x: borderWidth / 2, y: borderWidth / 2, width: diameter - borderWidth, height: diameter - borderWidth)
            context.strokeEllipse(in: borderRect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

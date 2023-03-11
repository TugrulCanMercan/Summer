//
//  LocationManager.swift
//  LoginAndSignModule
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 8.01.2023.
//

import Foundation
import CoreLocation
import MapKit


public enum LocationCustomError: Error {
    case LocationPlacesesError
    case ReversePlaceMarkError
}

public class LocationManger: NSObject, ObservableObject {
    public static let shared = LocationManger()
    @Published public private(set) var errorText: String = ""
    @Published public private(set) var currentLocation: CLLocation?
    @Published public private(set) var pickedLocation: CLLocation?
    @Published public private(set) var pickedPlacemark: CLPlacemark?
    
    private let manager = CLLocationManager()
    public let mapView = MKMapView()
    
    public override init() {
        super.init()
        getUserLocation()
    }
    
    func getUserLocation() {
        manager.delegate = self
        mapView.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.requestLocation()
    }
    
    func handleErrorFunc() {
        errorText = "Hay aksi konum bilgilerinizi Paylaşmaya İzin vermediniz"
    }
    
    public func fetchPlaces(searchValue: String) async throws -> [CLPlacemark] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchValue.lowercased()
        do {
            let response = try await MKLocalSearch(request: request).start()
                
            return response.mapItems.compactMap({ item -> CLPlacemark in
                return item.placemark
            })
        } catch  {
            throw LocationCustomError.LocationPlacesesError
        }
        

//        MKLocalSearch(request: request).start { searchResponse, error in
//            DispatchQueue.main.async {
//                self.fetchedPlaces = searchResponse?.mapItems.compactMap({ item -> CLPlacemark? in
//                    return item.placemark
//                })
//            }
//        }
    }
    
    public func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    public func currentLocationGetReuqest(){
        manager.requestLocation()
    }
    
    public func addDraggablePin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        Task {
            do {
                let place = try await reverseLocationCoordinate(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                annotation.title = place?.name
                await mapView.addAnnotation(annotation)
            } catch  {
    //            Error Handle edilecek
            }
        }
    }
    
    public func updatePlacemark(location: CLLocation) {
        Task {
            do {
                guard let place = try await reverseLocationCoordinate(location: location) else {return}
                await MainActor.run(body: {
                    self.pickedPlacemark = place
                    guard let pointAnnotation = mapView.annotations.last as? MKPointAnnotation else { return }
                    pointAnnotation.title = place.name
                    UIView.animate(withDuration: 0.3) {
                        pointAnnotation.coordinate = location.coordinate
                    }
                })
            } catch LocationCustomError.ReversePlaceMarkError{
                errorText = "ReversePlaceMarkError Yer işareti Hatası"
            }
        }
    }

    
    func reverseLocationCoordinate(location: CLLocation) async throws -> CLPlacemark? {
        do {
            let place = try await CLGeocoder().reverseGeocodeLocation(location).first
            return place

        } catch {
            throw LocationCustomError.ReversePlaceMarkError
        }
        
    }
    
    public func clearAllPickedPlacemarkPickedLocation() {
        pickedLocation = nil
        pickedPlacemark = nil
    }
    public func clearAllLocation() {
        pickedLocation = nil
        pickedPlacemark = nil
        currentLocation = nil
    }
/// Haritada annotationları kaldırır
    public func mapviewRemoveAllNotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    public func currentLocation(currentCoordinate: CLLocation) {
        UIView.animate(withDuration: 0.3) {
            self.mapView.region = .init(center: currentCoordinate.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        }
        
    }
    
}

//  Delegate ve Datasource Extensions
extension LocationManger: CLLocationManagerDelegate, MKMapViewDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentlocation = locations.last else {return}
        self.currentLocation = currentlocation
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }

    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        case .denied:
            handleErrorFunc()
        case .authorizedAlways:
            manager.requestLocation()
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .restricted: break
            
        @unknown default: break
            
        }
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PIN")
        marker.isDraggable = true
        marker.canShowCallout = false
        
        return marker
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else {return}
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlacemark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
        
    }
}

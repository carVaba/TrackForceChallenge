import CoreLocation

protocol LocationServiceProtocol {
    func requestUserLocation(completion: @escaping (Result<LocationCoordinate, LocationUserLocationError>) ->Void )
}

// Adapter pattern LocationServiceProtocol + DefaultLocationService
final class DefaultLocationService: NSObject, LocationServiceProtocol {
    private lazy var locationManager = CLLocationManager()
    private var completionHandler: ((Result<LocationCoordinate, LocationUserLocationError>) -> Void)?
    
    override init() {
        super.init()
        // Behavioral pattern by using delegates 
        locationManager.delegate = self
    }
    
    func requestUserLocation(completion: @escaping (Result<LocationCoordinate, LocationUserLocationError>) -> Void) {
        
        self.completionHandler = completion
        
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                completion(.failure(.restricted))
            case .denied:
                completion(.failure(.permissionDenied))
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
            @unknown default:
                completion(.failure(.unknow))
        }
    }
}

extension DefaultLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let coordinate = LocationCoordinate(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude)
            completionHandler?(.success(coordinate))
        } else {
            completionHandler?(.failure(.locationUnavailable))
        }
        completionHandler = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        completionHandler?(.failure(.locationUnavailable))
        completionHandler = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let acceptedStatus: [CLAuthorizationStatus] = [.authorizedWhenInUse, .authorizedAlways]
        if acceptedStatus.contains(CLLocationManager.authorizationStatus()) {
            locationManager.requestLocation()
        }
    }
}

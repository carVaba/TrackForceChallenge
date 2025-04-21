enum LocationUserLocationError: Error {
    case permissionDenied
    case locationUnavailable
    case restricted
    case unknow
    
    var message: String {
        switch self {
            case .permissionDenied:
                return "Please enable location permissions in Settings to allow the app to fetch your current location."
            case .locationUnavailable:
                return "We couldn't get your current location. Please try again later."
            case .unknow, .restricted:
                return "Something went wrong while trying to access your location."
        }
    }
    
    var title: String? {
        switch self {
            case .permissionDenied:
                return "Location Service Denied"
            case .locationUnavailable, .restricted:
                return "Location Not Available"
            case .unknow:
                return nil
        }
    }
}


// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'firebase_service.dart';
import 'dart:math';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  Position? _currentPosition;
  String? _currentCity;
  final FirebaseService _firebaseService = FirebaseService();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  Position? get currentPosition => _currentPosition;
  double? get latitude => _currentPosition?.latitude;
  double? get longitude => _currentPosition?.longitude;
  String? get currentCity => _currentCity;

  // ============ LOCATION INITIALIZATION ============

  /// Initialize location and request permissions
  Future<bool> initLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      // Get location
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _getLocationCity(_currentPosition!.latitude, _currentPosition!.longitude);

      // Update location in Firebase
      if (_firebaseService.isUserAuthenticated()) {
        await _firebaseService.updateUserLocation(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      }


      return true;
    } catch (e) {
      print('Location error: $e');
      return false;
    }
  }

  // ============ CITY/AREA DETECTION ============
  Future<void> _getLocationCity(double lat, double long) async {
    try{
      List<Placemark> placemark = await placemarkFromCoordinates(lat, long);

      if (placemark.isNotEmpty){
        final location = placemark.first;
        
        _currentCity = _getCityName(location);
      }
    } catch (e) {
      print('Error getting city from coordinates: $e');
      _currentCity = null;
    }
  }

  String _getCityName(Placemark location) {
    final fullLocation = <String>[];

    if (location.locality != null && location.locality!.isNotEmpty) {
      fullLocation.add(location.locality!);
    }
    if (location.administrativeArea != null && location.administrativeArea!.isNotEmpty) {
      fullLocation.add(location.administrativeArea!);
    }
    if (location.country != null && location.country!.isNotEmpty) {
      fullLocation.add(location.country!);
    }
    
    return fullLocation.isNotEmpty ? fullLocation.join(', ') : 'Unknown Location';
  }

    Future<String?> getCityFromCoordinates(double lat, double long) async {
    try {
      // Return "Unknown Location" if coordinates are 0,0
      if (lat == 0.0 && long == 0.0) {
        return null;
      }
      
      List<Placemark> location = await placemarkFromCoordinates(lat, long);
      if (location.isNotEmpty) {
        return _getCityName(location.first);
      }
    } catch (e) {
      print('Error getting city: $e');
    }
    return null;
  }

  // ============ LOCATION UPDATES ============

  /// Start listening to location updates (every 100m movement)
  Future<void> startLocationUpdates() async {
    try {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) async {
        _currentPosition = position;
        if (_firebaseService.isUserAuthenticated()) {
          await _firebaseService.updateUserLocation(
            position.latitude,
            position.longitude,
          );
        }
      });
    } catch (e) {
      print('Location stream error: $e');
    }
  }

  // ============ DISTANCE CALCULATIONS ============

  /// Calculate distance between two coordinates in kilometers
  /// Returns double.infinity if coordinates are invalid (0,0)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    if (lat1 == 0 || lon1 == 0 || lat2 == 0 || lon2 == 0) {
      return double.infinity;
    }

    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) *
            cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  /// Calculate distance from current position to a point
  /// Returns double.infinity if current position not set or coordinates invalid
  double? distanceFromCurrent(double lat, double lon) {
    if (_currentPosition == null) return null;
    return calculateDistance(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lat,
      lon,
    );
  }

  // ============ PERMISSION CHECKS ============

  /// Check if location permissions are granted
  Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  // ============ UTILITY METHODS ============

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}
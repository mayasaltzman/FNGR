import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:test_milestone/user_profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }


Future<void> _initLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 1️⃣ Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // You can show a dialog or a snackbar to tell the user to enable location
    print('❌ Location services are disabled.');
    return;
  }

  // 2️⃣ Check permission status
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('❌ Location permission denied.');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('❌ Location permissions are permanently denied.');
    return;
  }

  // 3️⃣ Finally, get the location
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  setState(() => _currentPosition = position);
  print('✅ Got location: ${position.latitude}, ${position.longitude}');
}

  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
  //  if lat and long dont exsit return null
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) {
      return double.infinity;
    }
    const p = 0.017453292519943295;
    final a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
        (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Scaffold(
        
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: Text("FNGR",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryFixed)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final currentLat = _currentPosition!.latitude;
          final currentLng = _currentPosition!.longitude;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final name = data['name'] ?? 'Unknown';
              final age = data['age'];
              final lat = data.containsKey('lat') ? data['lat'] as double? : null;
              final lng = data.containsKey('long') ? data['long'] as double? : null;
              final photo = data['photoURL'] ?? '';

              double? distance;
              if (lat != null && lng != null && _currentPosition != null) {
                final currentLat = _currentPosition!.latitude;
                final currentLng = _currentPosition!.longitude;
                distance = _distanceKm(currentLat, currentLng, lat, lng);
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserProfilePage()),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Theme.of(context).colorScheme.secondaryFixed,
                  elevation: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            photo,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.person, size: 50)                          
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryFixed)),
                                
                      if (age != null)
                        Text('Age: $age',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixed)),
                      if (distance != null && distance.isFinite)
                        Text('${distance.toStringAsFixed(1)} km away',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryFixed)),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },

          );
        },
      ),
    );
  }
}

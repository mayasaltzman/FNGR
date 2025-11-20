import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import '../../services/location_service.dart';
import '../profile/user_profile_page.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: Text("FNGR",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryFixed)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService.getAllUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs.where((doc) => doc.id != _firebaseService.currentUserId).toList();
          if (docs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: .75,
              crossAxisSpacing: 3,
              mainAxisSpacing: 10,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final uid = doc.id;
              //if the uid matches current user id, remove it from the list
              if (uid == _firebaseService.currentUserId) {
                return const SizedBox.shrink();
                
              }
    
              final name = data['name'] ?? 'Unknown';
              final age = data['age'];
              // final lat = data.containsKey('lat') ? data['lat'] as double? : null;
              // final lng = data.containsKey('long') ? data['long'] as double? : null;
              final photo = data['photoURL'] ?? '';
        
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfilePage(userId: uid)),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primaryFixed,
                                ),
                              ),
                            ),
                            if (age != null)
                              Text(
                                '$age',
                                style: TextStyle(
                                  
                                  color: Theme.of(context).colorScheme.primaryFixed,
                                ),
                              ),
                          ],
                        ),
                      ),  
                      // if (distance != null && distance.isFinite)
                      //   Text('${distance.toStringAsFixed(1)} km away',
                      //       style: TextStyle(
                      //           color: Theme.of(context)
                      //               .colorScheme
                      //               .primaryFixed)),
                      // const SizedBox(height: 8),
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

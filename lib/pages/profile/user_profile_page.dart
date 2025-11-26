import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import '../../services/location_service.dart';
import './widgets/profile_view_widgets.dart';

//styles for the page
abstract class ProfileStyles {
  //styles for boxes that store profile info
  static BoxDecoration boxDecoration = BoxDecoration(
      color: const Color(0xFFFFF0E6),
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(
        color: const Color(0xFFFF9B55),
        width: 1,
      ));

  //styles for boxes that are individual items in sexual preferences and interests
  static BoxDecoration itemBoxDecoration = BoxDecoration(
      color: const Color(0xFFF9E7F2),
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(
        color: const Color(0xFFAA4E85),
        width: 1,
      ));

  //text styles for headings in boxes
  static TextStyle boxHeader = const TextStyle(
      fontWeight: FontWeight.bold, color: Color(0xFFFF9B55), fontSize: 16);

  //text styles for text in boxes
  static TextStyle boxText = const TextStyle(
      fontWeight: FontWeight.normal, color: Color(0xFFAA4E85), fontSize: 16);

  static const containerWidth = 375.0;

  static const boxPadding = EdgeInsets.all(8.0);
}

class BuildUserProfilePage extends StatefulWidget {
  final String userId;

  const BuildUserProfilePage({super.key, required this.userId});

  @override
  State<BuildUserProfilePage> createState() => _BuildUserProfilePageState();
}

class _BuildUserProfilePageState extends State<BuildUserProfilePage> {
  //to display loading state until data loads
  bool _isLoading = true;
  late final LocationService _locationService;
  late FirebaseService _firebaseService;
  late String userId;

  //get data from firestore
  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    _locationService = LocationService();
    userId = widget.userId ?? _firebaseService.currentUserId!;
    _ensureLocationReady();
  }

  Future<void> _ensureLocationReady() async {
    if (_locationService.currentPosition == null) {
      await _locationService.initLocation();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUserProfile = userId == _firebaseService.currentUserId;
    return FutureBuilder<DocumentSnapshot>(
      future: _firebaseService.getUserProfile(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('User not found'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        print(data);

        double distance = double.infinity;
        final lat = data['lat'] as double? ?? 0.0;
        final lng = data['long'] as double? ?? 0.0;

        if (lat != 0.0 &&
            lng != 0.0 &&
            _locationService.latitude != null &&
            _locationService.longitude != null) {
          distance = _locationService.calculateDistance(
              _locationService.latitude!,
              _locationService.longitude!,
              lat,
              lng);
        }
        return FutureBuilder<String?>(
          future: _locationService.getCityFromCoordinates(lat, lng),
          builder: (context, citySnapshot) {
            final city = citySnapshot.data;

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  spacing: 20,
                  children: [
                    HeaderElements(
                      name: data['name'] ?? 'Unknown',
                      age: data['age']?.toString() ?? 'N/A',
                      isUser: isUserProfile,
                      userId: userId,
                      photoURL: data['photoURL'] ?? '',
                    ),
                    ProfileImage(
                        imageUrl: data['photoURL'] ?? '',
                        profileImages: data['profileImages'] ?? []),
                    AboutMe(bio: data['bio'] ?? ''),
                    KeyInfo(
                      lookingFor: data['expectations'] ?? 'Unknown',
                      relationshipStyle:
                          data['relationship_style'] ?? 'Unknown',
                      height: data['height'] ?? 'Unknown',
                      distance: distance.isFinite ? distance : null,
                      location: city ?? 'Unknown',
                      sexuality: data['sexuality'] ?? ['Unknown'],
                      genderIdentity: data['gender'] ?? ['Unknown'],
                      pronouns: data['pronouns'] ?? ['Unknown'],
                      relationshipStatus:
                          data['relationship_status'] ?? 'Unknown',
                      genderExpression: data['expression'] ?? ['Unknown'],
                    ),
                    FieldsBox(
                        items: data['sexual_pref'] ?? [], label: "Preferences"),
                    FieldsBox(
                        items: data['interests'] ?? [], label: "Interests"),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  //to display loading state until data loads
  // bool _isLoading = true;
  // late final LocationService _locationService;
  late FirebaseService _firebaseService;
  late String userId;

  // //get data from firestore
  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    userId = widget.userId ?? _firebaseService.currentUserId!;
  }

  @override
  Widget build(BuildContext context) {
    final isUserProfile = userId == _firebaseService.currentUserId;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: BackButton(
              color: Theme.of(context)
                  .colorScheme
                  .secondaryFixed), //need to make this actually do something and give it color change for press
          centerTitle: true,
          title: Text(
            'FNGR',
            style:
                TextStyle(color: Theme.of(context).colorScheme.secondaryFixed),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: isUserProfile
                    ? DefaultTabController(
                        length: 2,
                        child: Column(children: [
                          Container(
                            color: Theme.of(context).colorScheme.tertiaryFixed,
                            child: TabBar(
                                dividerColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                unselectedLabelColor: Colors.black,
                                labelColor:
                                    Theme.of(context).colorScheme.primaryFixed,
                                indicatorColor:
                                    Theme.of(context).colorScheme.primaryFixed,
                                tabs: [Tab(text: "Edit"), Tab(text: "View")]),
                          ),
                          Expanded(
                              child: TabBarView(children: [
                            Text("test"),
                            SingleChildScrollView(
                                child: Column(children: [
                              BuildUserProfilePage(userId: userId)
                            ]))
                          ]))
                        ]),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                            child: Column(children: [
                        BuildUserProfilePage(userId: userId)
                      ]))))
          ],
        ));
  }
}

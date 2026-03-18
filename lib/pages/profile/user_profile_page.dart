import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import '../../services/location_service.dart';
import './widgets/profile_view_widgets.dart';
import './update_profile_page.dart';
import './styles/user_profile_styles.dart';
import '../chat/message_page.dart';

class BuildUserProfilePage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> data;
  final bool isUserProfile;
  final double distance;
  final String? city;

  const BuildUserProfilePage(
      {super.key,
      required this.userId,
      required this.data,
      required this.isUserProfile,
      required this.distance,
      required this.city});

  @override
  State<BuildUserProfilePage> createState() => _BuildUserProfilePageState();
}

class _BuildUserProfilePageState extends State<BuildUserProfilePage> {
  //get data from firestore
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          spacing: 20,
          children: [
            HeaderElements(
              name: widget.data['name'] ?? 'Unknown',
              age: widget.data['age']?.toString() ?? 'N/A',
              isUser: widget.isUserProfile,
              userId: widget.userId,
              photoURL: widget.data['photoURL'] ?? '',
            ),
            ProfileImage(
              imageUrl: widget.data['photoURL'] ?? '',
              profileImages: widget.data['profileImages'] ?? [],
            ),
            AboutMe(bio: widget.data['bio'] ?? ''),
            KeyInfo(
              lookingFor: widget.data['expectations'] ?? 'Unknown',
              relationshipStyle: widget.data['relationship_style'] ?? 'Unknown',
              height: widget.data['height'] ?? 'Unknown',
              age: widget.data['age'] ?? 'Unknown',
              distance: widget.distance.isFinite ? widget.distance : null,
              location: widget.city ?? 'Unknown',
              sexuality: widget.data['sexuality'] ?? ['Unknown'],
              genderIdentity: widget.data['gender'] ?? ['Unknown'],
              pronouns: widget.data['pronouns'] ?? ['Unknown'],
              relationshipStatus:
                  widget.data['relationship_status'] ?? 'Unknown',
              genderExpression: widget.data['expression'] ?? ['Unknown'],
            ),
            FieldsBox(
              items: widget.data['sexual_pref'] ?? [],
              label: "Preferences",
            ),
            FieldsBox(
              items: widget.data['interests'] ?? [],
              label: "Interests",
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('User not found')),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

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
            lng,
          );
        }

        return FutureBuilder<String?>(
          future: _locationService.getCityFromCoordinates(lat, lng),
          builder: (context, citySnapshot) {
            final city = citySnapshot.data;

            return DefaultTabController(
              length: isUserProfile ? 2 : 1,
              child: Builder(
                builder: (context) {
                  final tabController = DefaultTabController.of(context);
                  return Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    appBar: AppBar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      leading: BackButton(
                        color: Theme.of(context).colorScheme.secondaryFixed,
                      ),
                      centerTitle: true,
                      title: AnimatedBuilder(
                        animation: tabController,
                        builder: (_, __) {
                          if (!isUserProfile) {
                            return Text(
                              '${data['name']} ${data['age']}' ?? 'Profile',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryFixed,
                              ),
                            );
                          }
                          return Text(
                            tabController.index == 0
                                ? 'Edit Profile'
                                : '${data['name']} ${data['age']}',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.secondaryFixed,
                            ),
                          );
                        },
                      ),
                      actions: !isUserProfile
                          ? [
                              IconButton(
                                icon: Icon(
                                  Icons.messenger,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryFixed,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MessagePage(
                                        recipientUid: userId,
                                        recipientName: data['name'],
                                        recipientImage: data['photoURL'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ]
                          : null,
                      bottom: isUserProfile
                          ? TabBar(
                              tabs: [
                                Tab(text: "Edit"),
                                Tab(text: "View"),
                              ],
                            )
                          : null,
                    ),
                    body: TabBarView(
                      children: isUserProfile
                          ? [
                              UpdateProfilePage(
                                userId: userId,
                                bio: data['bio'] ?? '',
                                rStatus: data['relationship_status'] ?? '',
                                rStyle: data['relationship_style'] ?? '',
                                lookingFor: data['expectations'] ?? '',
                                sexuality: data['sexuality'] ?? [],
                                gender: data['gender'] ?? [],
                                pronouns: data['pronouns'] ?? [],
                                presentation: data['expression'] ?? [],
                                interests: data['interests'] ?? [],
                                preferences: data['sexual_pref'] ?? [],
                                name: data['name'] ?? '',
                                age: data['age'] ?? '',
                                height: data['height'] ?? '',
                              ),
                              BuildUserProfilePage(
                                userId: userId,
                                data: data,
                                isUserProfile: isUserProfile,
                                distance: distance,
                                city: city,
                              ),
                            ]
                          : [
                              BuildUserProfilePage(
                                userId: userId,
                                data: data,
                                isUserProfile: isUserProfile,
                                distance: distance,
                                city: city,
                              ),
                            ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

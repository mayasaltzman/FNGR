import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import '../../services/location_service.dart';
import '../chat/message_page.dart';

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

class HeaderElements extends StatelessWidget {
  final String name;
  final String age;
  final bool isUser;
  final String userId;
  final String photoURL;

  const HeaderElements({
    super.key,
    required this.name,
    required this.age,
    required this.isUser,
    required this.userId,
    required this.photoURL,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Container(
            width: ProfileStyles.containerWidth,
            padding: ProfileStyles.boxPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name and age on the left
                Flexible(
                  child: Text(
                    '${name}${(name.isNotEmpty && age != 'N/A' ? ', ' : '')} ${age != 'N/A' ? age : ''}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),

                // Message button on the right with icon
                if (!isUser)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagePage(
                            recipientUid: userId,
                            recipientName: name,
                            recipientImage: photoURL,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text("Message"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor:
                          Theme.of(context).colorScheme.secondaryFixed,
                      elevation: 3,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
              ],
            )),
      ],
    );
  }
}

//image box
class ProfileImage extends StatefulWidget {
  final String? imageUrl;
  final List<dynamic>? profileImages;

  const ProfileImage({super.key, this.imageUrl, this.profileImages});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final PageController _pageController = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.profileImages ?? [];
    final hasCarousel = images.isNotEmpty;

    return Container(
      height: 500,
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      clipBehavior: Clip.hardEdge,
      child: hasCarousel
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      height: 4,
                      width: 25,
                      color: _index == i
                          ? Theme.of(context).colorScheme.tertiaryFixed
                          : Theme.of(context).colorScheme.tertiary,
                    );
                  }),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _index = i),
                    children: images.map((img) {
                      return Image.network(
                        img,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.person, size: 100)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
          : _buildSingleImageOrFallback(),
    );
  }

  Widget _buildSingleImageOrFallback() {
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.person, size: 100)),
      );
    } else {
      return const Center(child: Icon(Icons.person, size: 100));
    }
  }
}

class AboutMe extends StatelessWidget {
  final String bio;
  const AboutMe({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    //doesn't render until data is loaded
    return bio != ""
        ? Container(
            width: ProfileStyles.containerWidth,
            decoration: ProfileStyles.boxDecoration,
            padding: ProfileStyles.boxPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("About Me", style: ProfileStyles.boxHeader),
                Text(bio, style: ProfileStyles.boxText)
              ],
            ),
          )
        : const SizedBox(height: 0);
  }
}

//key info box
class KeyInfo extends StatelessWidget {
  final String lookingFor;
  final String relationshipStyle;
  final String height;
  final double? distance;
  final String? location;
  final List<dynamic> sexuality;
  final List<dynamic> genderIdentity;
  final List<dynamic> pronouns;
  final String relationshipStatus;
  final List<dynamic> genderExpression;

  const KeyInfo(
      {super.key,
      required this.lookingFor,
      required this.relationshipStyle,
      required this.height,
      required this.distance,
      required this.location,
      required this.sexuality,
      required this.genderIdentity,
      required this.pronouns,
      required this.relationshipStatus,
      required this.genderExpression});

  @override
  Widget build(BuildContext context) {
    //list of fields in key info
    final List<Map<String, dynamic>> fields = [
      {
        'label': 'Distance',
        'value': distance != null
            ? '${distance!.toStringAsFixed(1)} km away'
            : 'Unknown',
        'icon': Icons.location_on_outlined
      },
      {'label': 'Location', 'value': location, 'icon': Icons.home_outlined},
      {
        'label': 'Sexuality',
        'value': sexuality.join(', '),
        'icon': Icons.circle_outlined
      },
      {
        'label': 'Pronouns',
        'value': pronouns.join(', '),
        'icon': Icons.chat_bubble_outline
      },
      {'label': 'Height', 'value': height, 'icon': Icons.height},
      {'label': 'Looking For', 'value': lookingFor, 'icon': Icons.search},
      {
        'label': 'Relationship Style',
        'value': relationshipStyle,
        'icon': Icons.handshake
      },
      {
        'label': 'Relationship Status',
        'value': relationshipStatus,
        'icon': Icons.star_outline_sharp
      },
      {
        'label': 'Gender Expression',
        'value': genderExpression.join(', '),
        'icon': Icons.person_2_outlined
      },
    ];

    final fieldsFiltered = fields.where((f) {
      final v = f['value'];
      return v != 'Unknown' && v.toString().isNotEmpty;
    }).toList();

    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      padding: ProfileStyles.boxPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Key Info",
              style: ProfileStyles.boxHeader,
            ),
          ),
          const SizedBox(height: 8),
          // List of key info rows with dividers
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(), // let parent scroll
            shrinkWrap: true, // important so it fits inside the column
            itemCount: fieldsFiltered.length,
            separatorBuilder: (context, index) => const Divider(
              height: 20,
              thickness: 2,
              color: Color(0xFFD461A6),
            ),
            itemBuilder: (context, index) {
              final field = fieldsFiltered[index];

              // skip empty fields
              if (field['value'] == 'Unknown' ||
                  field['value'].toString().isEmpty) {
                return const SizedBox.shrink();
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Text(field['label'] ?? '', style: ProfileStyles.boxText),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      Icon(field['icon'], color: Color(0xFFD461A6), size: 20),
                      Flexible(
                        child: Text(
                          field['value'],
                          style: ProfileStyles.boxText,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

//sexual preferences box
class Preferences extends StatelessWidget {
  final List<dynamic> preferences;

  const Preferences({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    if (preferences.isEmpty) return const SizedBox();
    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      padding: ProfileStyles.boxPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Column(
              spacing: 5,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sexual Preferences",
                    style: ProfileStyles.boxHeader,
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...preferences.map((p) => Container(
                          alignment: Alignment.center,
                          width: 75,
                          decoration: ProfileStyles.itemBoxDecoration,
                          child: Text(p, style: ProfileStyles.boxText)))
                    ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//sexual preferences box
class Interests extends StatelessWidget {
  final List<dynamic> interests;

  const Interests({super.key, required this.interests});

  @override
  Widget build(BuildContext context) {
    if (interests.isEmpty) return const SizedBox();
    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      padding: ProfileStyles.boxPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Interests",
                    style: ProfileStyles.boxHeader,
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...interests.map((i) => Container(
                          alignment: Alignment.center,
                          width: 75,
                          decoration: ProfileStyles.itemBoxDecoration,
                          child: Text(i, style: ProfileStyles.boxText)))
                    ]),
              ],
            ),
          )
        ],
      ),
    );
  }
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
                    Preferences(preferences: data['sexual_pref'] ?? []),
                    Interests(interests: data['interests'] ?? []),
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

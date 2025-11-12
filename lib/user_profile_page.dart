import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//styles for the page
abstract class ProfileStyles {
  static BoxDecoration boxDecoration = BoxDecoration(
      color: const Color(0xFFFFF0E6),
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(
        color: const Color(0xFFFF9B55),
        width: 1,
      ));

  static const containerWidth = 375.0;

  static const boxPadding = EdgeInsets.all(8.0);
}

//image box
class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    //doesn't render until data is loaded
    return Container(
      height: 500,
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text("Beautiful photos of women here"),
          ) // render nothing if no bio
        ],
      ),
    );
  }
}

class AboutMe extends StatefulWidget {
  final String bio;
  const AboutMe({super.key, required this.bio});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

//about me box
class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    //doesn't render until data is loaded
    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Column(
              children: [
                Text("About Me", style: Theme.of(context).textTheme.bodyMedium),
                Text(widget.bio, style: Theme.of(context).textTheme.bodySmall)
              ],
            ),
          ) // render nothing if no bio
        ],
      ),
    );
  }
}

//key info box
class KeyInfo extends StatefulWidget {
  final String lookingFor;
  final String relationshipStyle;
  final String height;
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
      required this.sexuality,
      required this.genderIdentity,
      required this.pronouns,
      required this.relationshipStatus,
      required this.genderExpression});

  @override
  State<KeyInfo> createState() => _KeyInfoState();
}

class _KeyInfoState extends State<KeyInfo> {
  @override
  Widget build(BuildContext context) {
    //list of fields in key info
    final List<Map<String, dynamic>> fields = [
      {'label': 'Distance', 'value': 'Distance soon'},
      {'label': 'Location', 'value': 'Location soon'},
      {
        'label': 'Sexuality',
        'value': widget.sexuality.join(', '),
      },
      {
        'label': 'Pronouns',
        'value': widget.pronouns.join(', '),
      },
      {
        'label': 'Height',
        'value': widget.height,
      },
      {
        'label': 'Looking For',
        'value': widget.lookingFor,
      },
      {
        'label': 'Relationship Style',
        'value': widget.relationshipStyle,
      },
      {
        'label': 'Relationship Status',
        'value': widget.relationshipStatus,
      },
      {
        'label': 'Gender Expression',
        'value': widget.genderExpression.join(', '),
      },
    ];

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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
          // List of key info rows with dividers
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(), // let parent scroll
            shrinkWrap: true, // important so it fits inside the column
            itemCount: fields.length,
            separatorBuilder: (context, index) => const Divider(
              height: 20,
              thickness: 1,
              color: const Color(0xFFD461A6),
            ),
            itemBuilder: (context, index) {
              final field = fields[index];

              // skip empty fields
              if (field['value'] == null || field['value'].toString().isEmpty) {
                return const SizedBox.shrink();
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(field['label'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Flexible(
                    child: Text(
                      field['value'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
class Preferences extends StatefulWidget {
  final List<dynamic> preferences;

  const Preferences({super.key, required this.preferences});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  @override
  Widget build(BuildContext context) {
    //need to update the container to have conditional rendering if the info isn't there
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
                    "Sexual Preferences",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...widget.preferences.map((p) => Container( decoration: ProfileStyles.boxDecoration,child: Text(p)))
                    ]),
              ],
            ),
          ) // render nothing if no bio
        ],
      ),
    );
  }
}

//sexual preferences box
class Interests extends StatefulWidget {
  final List<dynamic> interests;

  const Interests({super.key, required this.interests});

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  @override
  Widget build(BuildContext context) {
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [...widget.interests.map((i) => Text(i))]),
              ],
            ),
          ) // render nothing if no bio
        ],
      ),
    );
  }
}

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  //to display loading state until data loads
  bool _isLoading = true;
  //instance of firebase
  final firestoreInstance = FirebaseFirestore.instance;
  DocumentSnapshot? snapshot; //Define snapshot

  //get data from firestore
  void _getData() async {
    final data = await firestoreInstance
        .collection("users")
        .doc(
            '1a4dZXRtA80tkguo1REw') //needs to be passed as ID based on user that was clicked this is just for testing
        .get(); //get the data
    snapshot = data;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData(); //loads data as soon as page opens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading:
            const BackButton(), //need to make this actually do something and give it color change for press
        actions: [TextButton(onPressed: () {}, child: const Text("Message"))],
      ),
      body: SingleChildScrollView(
          child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      spacing: 20,
                      children: [
                        snapshot!['name'] != null && snapshot!['age'] != null
                            ? SizedBox(
                                child: Text(
                                    "${snapshot!['name']}- ${snapshot!['age']}",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge))
                            : const SizedBox(),
                        const ProfileImage(),
                        snapshot!['bio'] != null
                            ? AboutMe(bio: snapshot!['bio'])
                            : const SizedBox(),
                        KeyInfo(
                            lookingFor: snapshot!['expectations'],
                            relationshipStyle: snapshot!['relationship_style'],
                            height: snapshot!['height'],
                            sexuality: snapshot!['sexuality'],
                            genderIdentity: snapshot!['gender'],
                            pronouns: snapshot!['pronouns'],
                            relationshipStatus:
                                snapshot!['relationship_status'],
                            genderExpression: snapshot!['expression']),
                        Preferences(
                          preferences: snapshot!['sexual_pref'],
                        ),
                        Interests(interests: snapshot!['interests'])
                      ],
                    ))),
    );
  }
}

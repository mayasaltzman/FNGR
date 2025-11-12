import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//styles for the page
abstract class ProfileStyles {
  static BoxDecoration boxDecoration = BoxDecoration(
      border: Border.all(
    color: Colors.black,
    width: 1,
  ));

  static const containerWidth = 375.0;
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
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 500,
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
  //sexuality, pronouns, height, looking for, relationship style

  @override
  Widget build(BuildContext context) {
    //need to update the container to have conditional rendering if the info isn't there
    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Column(
              children: [
                Text("Key Info", style: Theme.of(context).textTheme.bodyMedium),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Sexuality"),
                      ...widget.sexuality.map((s) => Text(s))
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Pronouns"),
                      ...widget.pronouns.map((p) => Text(p))
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Height"),
                      Text(widget.height,
                          style: Theme.of(context).textTheme.bodySmall),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Looking For"),
                    Text(widget.lookingFor,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Relationship Style"),
                    Text(widget.relationshipStyle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Relationship Status"),
                    Text(widget.relationshipStatus,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Gender Expression"),
                      ...widget.genderExpression.map((ge) => Text(ge))
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Column(
              children: [
                Text("Sexual Preferences",
                    style: Theme.of(context).textTheme.bodyMedium),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [...widget.preferences.map((p) => Text(p))]),
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
    //need to update the container to have conditional rendering if the info isn't there
    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Column(
              children: [
                Text("Interests",
                    style: Theme.of(context).textTheme.bodyMedium),
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
                                    "${snapshot!['name']}, ${snapshot!['age']}",
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

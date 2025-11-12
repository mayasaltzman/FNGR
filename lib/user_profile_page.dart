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

class ProfileInfo extends StatefulWidget {
  final String bio;
  const ProfileInfo({super.key, required this.bio});
  // const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

// //about me box
class _ProfileInfoState extends State<ProfileInfo> {
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
class KeyInfo extends StatelessWidget {
  const KeyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Key Info")],
      ),
    );
  }
}

//preferences box
class Preferences extends StatelessWidget {
  const Preferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Preferences")],
      ),
    );
  }
}

//interests box
class Interests extends StatelessWidget {
  const Interests({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Interests")],
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
      body: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  spacing: 20,
                  children: [
                    snapshot!['name'] != null && snapshot!['age'] != null
                        ? SizedBox(
                            child: Text(
                                "${snapshot!['name']}, ${snapshot!['age']}"))
                        : const SizedBox(),
                    snapshot!['bio'] != null
                        ? ProfileInfo(bio: snapshot!['bio'])
                        : const SizedBox()
                    // KeyInfo(),
                    // Preferences(),
                    // Interests()
                  ],
                )),
    );
  }
}

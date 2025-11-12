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

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

//about me box
class _AboutMeState extends State<AboutMe> {
  //instance of firebase
  final firestoreInstance = FirebaseFirestore.instance;
  late DocumentSnapshot snapshot; //Define snapshot

  //get data from firestore
  void _getData() async {
    final data = await firestoreInstance
        .collection("users")
        .doc(
            '1a4dZXRtA80tkguo1REw') //needs to be passed as ID based on user that was clicked this is just for testing
        .get(); //get the data
    snapshot = data;
    print(snapshot['age']);
  }

  @override
  void initState() {
    super.initState();
    _getData(); //loads data as soon as page opens
  }

  final String aboutText =
      "testing text until db connection"; //will replace with stuff from db

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ProfileStyles.containerWidth,
      decoration: ProfileStyles.boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("About Me", style: Theme.of(context).textTheme.bodyMedium),
          Text(aboutText, style: Theme.of(context).textTheme.bodySmall)
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
  @override
  void initState() {
    super.initState();
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
      body: const Center(
          child: Column(
        spacing: 20,
        children: [
          Text("Name, Age"),
          AboutMe(),
          KeyInfo(),
          Preferences(),
          Interests()
        ],
      )),
    );
  }
}

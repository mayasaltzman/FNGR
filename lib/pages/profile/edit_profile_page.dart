import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';

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

  static const containerWidth = 375.0;

  static const boxPadding = EdgeInsets.all(8.0);
}

class UserView extends StatelessWidget {
  final String name;
  final String age;

  const UserView({super.key, required this.name, required this.age});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: ProfileStyles.containerWidth,
            decoration: ProfileStyles.boxDecoration,
            padding: ProfileStyles.boxPadding,
            alignment: Alignment.center,
            height: 150,
            child: Row(
              children: [
                Text(name),
                Text(age),
                TextButton(onPressed: () {}, child: Text("Edit Profile"))
              ],
            )));
  }
}

class EditProfilePage extends StatefulWidget {
  final String userId;

  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late FirebaseService _firebaseService;
  late String userId;

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
    userId = widget.userId; //?? _firebaseService.currentUserId!;
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
        body: FutureBuilder<DocumentSnapshot>(
          future: _firebaseService.getUserProfile(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('User not found'));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  spacing: 20,
                  children: [UserView(name: data['name'], age: data['age'])],
                ),
              ),
            );
          },
        ));
  }
}

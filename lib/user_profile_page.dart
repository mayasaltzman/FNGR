import 'package:flutter/material.dart';

//about me box
class AboutMe extends StatelessWidget {
  final String aboutText = "testing text until db connection";

  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("About Me"),
        Text(aboutText)
      ],
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
        appBar: AppBar(
          title: const Text('Nearby Users'),
          centerTitle: true,
        ),
        body: const Column(
          children: [
             AboutMe()
          ],
        ),
    );
  }
}

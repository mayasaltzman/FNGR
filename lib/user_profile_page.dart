import 'package:flutter/material.dart';

//about me box
class AboutMe extends StatelessWidget {
  final String aboutText = "testing text until db connection";

  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const Text("About Me"), Text(aboutText)],
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
      appBar: AppBar(
        title: const Text('Nearby Users'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
        children: [
          AboutMe(),
        ],
      )),
    );
  }
}

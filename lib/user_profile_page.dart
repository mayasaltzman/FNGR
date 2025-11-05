import 'package:flutter/material.dart';

//about me box
class AboutMe extends StatelessWidget {
  final String aboutText = "testing text until db connection";

  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("About Me", style: Theme.of(context).textTheme.bodyMedium), Text(aboutText, style: Theme.of(context).textTheme.bodySmall)],
      ),
    );
  }
}

class KeyInfo extends StatelessWidget {
  const KeyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Key Info")],
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
      ),
      body: const Center(
          child: Column(
          children: [
            Text("Name, Age"),
            SizedBox(height: 20),
            AboutMe(),
            SizedBox(height: 20),
            KeyInfo(),
          ],
      )),
    );
  }
}

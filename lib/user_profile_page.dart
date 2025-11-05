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
        leading: const BackButton(), //need to make this actually do something and give it color change for press
        actions: [
          TextButton(onPressed: (){}, child: const Text("Message"))
        ],
      ),
      body: const Center(
          child: Column(
          spacing: 20,
          children: [
            Text("Name, Age"),
            AboutMe(),
            KeyInfo(),
          ],
      )),
    );
  }
}

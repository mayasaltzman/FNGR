import 'package:flutter/material.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}


class _CreateProfilePageState extends State<CreateProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text("Create Profile"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: const BackButton(), //need to make this actually do something and give it color change for press
      ),
      // body: const Center(
      //     child: Column(
      //     spacing: 20,
      //     children: [
      //       Text("Name, Age"),
      //       AboutMe(),
      //       KeyInfo(),
      //       Preferences(),
      //       Interests()
      //     ],
      // )),
    );
  }
}
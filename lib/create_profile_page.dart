import 'package:flutter/material.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  //state for managing form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //store name entered
  String _name = "";

  @override
  Widget build(BuildContext context) {
    return (SizedBox(
      width: 375,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text("Name"),
            SizedBox(
                width: 200,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                ))
          ])
        ],
      ),
    ));
    //   Scaffold(
    //     body: Center(
    //       child: Column(
    //         children: [
    //           const Text("Name"),
    //           TextFormField(
    //             decoration: const InputDecoration(labelText: "Name"),
    //           )
    //         ],
    //       ),
    //     ),
    //   )
    // );
  }
}

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
          leading:
              const BackButton(), //need to make this actually do something and give it color change for press
        ),
        body: const ProfileForm());
  }
}

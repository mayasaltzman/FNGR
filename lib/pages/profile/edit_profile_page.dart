import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text("FNGR",
            style:
                TextStyle(color: Theme.of(context).colorScheme.secondaryFixed)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}

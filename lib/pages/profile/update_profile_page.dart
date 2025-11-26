import 'package:flutter/material.dart';
import './widgets/text_input_widgets.dart';

class UpdateProfilePage extends StatefulWidget {
  final String bio;

  const UpdateProfilePage({super.key, required this.bio});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextInputFieldLong(controller: _bioController, bio: widget.bio),
      TextButton(onPressed: (){}, child: Text("Save"))
    ]);
  }
}

import 'package:flutter/material.dart';
import './widgets/text_input_widgets.dart';
import './widgets/single_select_widget.dart';

class UpdateProfilePage extends StatefulWidget {
  final String bio;
  final String rStatus;
  final String rStyle;
  final String lookingFor;

  const UpdateProfilePage({super.key, required this.bio, required this.rStatus, required this.rStyle, required this.lookingFor});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _bioController = TextEditingController();
  String? _relationshipStyle;
  String? _relationshipStatus;
  String? _lookingFor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(spacing: 15, children: [
      SizedBox(height: 10),
      TextInputFieldLong(controller: _bioController, bio: widget.bio),
      SingleSelectDropDown(
        value: _relationshipStyle,
        label: "Relationship Style",
        onChanged: (newVal) {
          setState(() {
            _relationshipStyle = newVal;
          });
        },
        hintText: widget.rStyle,
      ),
       SingleSelectDropDown(
        value: _relationshipStatus,
        label: "Relationship Status",
        onChanged: (newVal) {
          setState(() {
            _relationshipStatus = newVal;
          });
        },
        hintText: widget.rStatus,
      ),
       SingleSelectDropDown(
        value: _lookingFor,
        label: "Looking For",
        onChanged: (newVal) {
          setState(() {
            _lookingFor = newVal;
          });
        },
        hintText: widget.lookingFor,
      ),
      TextButton(
          onPressed: () {},
          child: Text("Save"),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondaryFixed,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          )),
          
    ]);
  }
}

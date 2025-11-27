import 'package:flutter/material.dart';
import './widgets/text_input_widgets.dart';
import './widgets/single_select_widget.dart';
import './widgets/multi_select_widget.dart';
import '../../services/firebase_service.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class UpdateProfilePage extends StatefulWidget {
  final String bio;
  final String rStatus;
  final String rStyle;
  final String lookingFor;

  const UpdateProfilePage(
      {super.key,
      required this.bio,
      required this.rStatus,
      required this.rStyle,
      required this.lookingFor});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late FirebaseService _firebaseService;

  final TextEditingController _bioController = TextEditingController();
  final MultiSelectController<String> sexualityController =
      MultiSelectController<String>();
  final MultiSelectController<String> genderController =
      MultiSelectController<String>();
  final MultiSelectController<String> pronounController =
      MultiSelectController<String>();
  final MultiSelectController<String> sexualPrefController =
      MultiSelectController<String>();
  final MultiSelectController<String> genderPresentationController =
      MultiSelectController<String>();
  final MultiSelectController<String> interestsController =
      MultiSelectController<String>();
  String? _relationshipStyle;
  String? _relationshipStatus;
  String? _lookingFor;

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
  }

  Future<void> _submitUpdates() async {
    // final data = {
    //   'name': _nameController.text.trim(),
    //   'age': _ageController.text.trim(),
    //   'height': _heightController.text.trim(),
    //   'bio': _bioController.text.trim(),
    //   'sexuality':
    //       sexualityController.selectedItems.map((e) => e.value).toList(),
    //   'gender': genderController.selectedItems.map((e) => e.value).toList(),
    //   'pronouns': pronounController.selectedItems.map((e) => e.value).toList(),
    //   'relationship_status': _relationshipStatus ?? '',
    //   'relationship_style': _relationshipStyle ?? '',
    //   'expectations': _lookingFor ?? '',
    //   'expression': genderPresentationController.selectedItems
    //       .map((e) => e.value)
    //       .toList(),
    //   'interests':
    //       interestsController.selectedItems.map((e) => e.value).toList(),
    //   'sexual_pref':
    //       sexualPrefController.selectedItems.map((e) => e.value).toList(),
    // 'profileImages': imageUrls,
    // 'photoURL': imageUrls.first, // Primary profile photo
    //};

    //await _firebaseService.updateUserProfile(data: data);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(spacing: 15, children: [
              TextInputFieldLong(controller: _bioController, bio: widget.bio),
              MultiSelectDropdown(
                  controller: sexualityController, labelText: "Sexuality"),
              MultiSelectDropdown(
                  controller: genderController, labelText: "Gender Identity"),
              MultiSelectDropdown(
                  controller: pronounController, labelText: "Pronouns"),
              MultiSelectDropdown(
                  controller: sexualPrefController,
                  labelText: "Sexual Preferences"),
              MultiSelectDropdown(
                  controller: genderPresentationController,
                  labelText: "Gender Presentation"),
              MultiSelectDropdown(
                  controller: interestsController, labelText: "Interests"),
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
              Container(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text("Save"),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.secondaryFixed,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              )
            ])));
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import './widgets/text_input_widgets.dart';
import './widgets/single_select_widget.dart';
import './widgets/multi_select_widget.dart';
import '../../services/firebase_service.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import './widgets/image_button_widget.dart';

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
  final _picker = ImagePicker();

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
  final List<File?> _selectedImages = List.filled(5, null);
  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
  }

  @override
  void dispose() {
    _bioController.dispose();
    sexualityController.dispose();
    genderController.dispose();
    pronounController.dispose();
    sexualPrefController.dispose();
    genderPresentationController.dispose();
    interestsController.dispose();
    super.dispose();
  }

  //eventually will move this so it can be reused as same function in create and update profile
  Future<void> _pickImage(int index) async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );
      if (pickedImage == null) return;
      final imageFile = File(pickedImage.path);

      final sizeInMB = await imageFile.length() / (1024 * 1024);
      if (sizeInMB > 10) {
        if (mounted) {
          _showSnackBar('Image size should not exceed 10 MB.');
        }
        return;
      }
      setState(() {
        _selectedImages[index] = imageFile;
      });
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error picking image: $e');
      }
    }
  }

  //eventually will be moved so can be used across app
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
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
              Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ImageButton(
                          image: _selectedImages[0], width: 200, height: 400, onTap: () => _pickImage(0)),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            ImageButton(image: _selectedImages[1], width: 80, height: 190, onTap: () => _pickImage(1)),
                            const SizedBox(height: 10),
                            ImageButton(image: _selectedImages[2], width: 80, height: 190, onTap: () => _pickImage(2)),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            ImageButton(image: _selectedImages[3], width: 80, height: 190, onTap: () => _pickImage(3)),
                            const SizedBox(height: 10),
                            ImageButton(image: _selectedImages[4], width: 80, height: 190, onTap: () => _pickImage(4)),
                          ],
                        ),
                      ]),
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

import 'dart:io';
import 'package:flutter/material.dart';
import './widgets/text_input_widgets.dart';
import './widgets/single_select_widget.dart';
import './widgets/multi_select_widget.dart';
import '../../services/firebase_service.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import './widgets/image_button_widget.dart';
import './edit_profile_page.dart';
import '../../main.dart';

//MAYA STILL FINISHING THIS

class UpdateProfilePage extends StatefulWidget {
  final String userId;
  final String bio;
  final String rStatus;
  final String rStyle;
  final String lookingFor;
  final List<dynamic> sexuality;
  final List<dynamic> gender;
  final List<dynamic> pronouns;
  final List<dynamic> presentation;
  final List<dynamic> interests;
  final List<dynamic> preferences;
  final String name;
  final String age;
  final String height;

  const UpdateProfilePage(
      {super.key,
      required this.userId,
      required this.bio,
      required this.rStatus,
      required this.rStyle,
      required this.lookingFor,
      required this.sexuality,
      required this.gender,
      required this.pronouns,
      required this.presentation,
      required this.interests,
      required this.preferences,
      required this.name,
      required this.age,
      required this.height});

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

    //pre populate multi select drop downs
    preSelectItems(sexualityController, widget.sexuality);
    preSelectItems(genderController, widget.gender);
    preSelectItems(pronounController, widget.pronouns);
    preSelectItems(sexualPrefController, widget.preferences);
    preSelectItems(genderPresentationController, widget.presentation);
    preSelectItems(interestsController, widget.interests);
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

  //I cant find a better way to do this without the loop right now but this will due for M03
  void preSelectItems(
      MultiSelectController<String> controller, List<dynamic> dropDownType) {
    List<DropdownItem<String>> dropdownItems = dropDownType.map((dynamic item) {
      return DropdownItem(label: item.toString(), value: item.toString());
    }).toList();

    controller.setItems(dropdownItems);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var value in dropDownType) {
        controller.selectWhere(
          (item) => item.label == value.toString(),
        );
      }
    });
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
    final data = {
      'name': widget.name.trim(),
      'age': widget.age.trim(),
      'height': widget.height.trim(),
      'bio': _bioController.text.trim().isEmpty
          ? widget.bio
          : _bioController.text.trim(),
      'sexuality': sexualityController.selectedItems.isEmpty
          ? widget.sexuality
          : sexualityController.selectedItems.map((e) => e.value).toList(),
      'gender': genderController.selectedItems.isEmpty
          ? widget.gender
          : genderController.selectedItems.map((e) => e.value).toList(),
      'pronouns': pronounController.selectedItems.isEmpty
          ? widget.pronouns
          : pronounController.selectedItems.map((e) => e.value).toList(),
      'relationship_status': _relationshipStatus ?? widget.rStatus,
      'relationship_style': _relationshipStyle ?? widget.rStyle,
      'expectations': _lookingFor ?? widget.lookingFor,
      'expression': genderPresentationController.selectedItems.isEmpty
          ? widget.presentation
          : genderPresentationController.selectedItems
              .map((e) => e.value)
              .toList(),
      'interests': interestsController.selectedItems.isEmpty
          ? widget.interests
          : interestsController.selectedItems.map((e) => e.value).toList(),
      'sexual_pref': sexualPrefController.selectedItems.isEmpty
          ? widget.preferences
          : sexualPrefController.selectedItems.map((e) => e.value).toList(),
      //'profileImages': imageUrls,
      //'photoURL': imageUrls.first, // Primary profile photo
    };

    await _firebaseService.updateUserProfile(data: data);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => NavMenu(selectedIndex: 2)),
          (route) => false);
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) =>  EditProfilePage(userId: widget.userId)),
    // );
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
                        image: _selectedImages[0],
                        width: 200,
                        height: 400,
                        onTap: () => _pickImage(0)),
                    const SizedBox(width: 5),
                    Column(
                      children: [
                        ImageButton(
                            image: _selectedImages[1],
                            width: 80,
                            height: 190,
                            onTap: () => _pickImage(1)),
                        const SizedBox(height: 10),
                        ImageButton(
                            image: _selectedImages[2],
                            width: 80,
                            height: 190,
                            onTap: () => _pickImage(2)),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Column(
                      children: [
                        ImageButton(
                            image: _selectedImages[3],
                            width: 80,
                            height: 190,
                            onTap: () => _pickImage(3)),
                        const SizedBox(height: 10),
                        ImageButton(
                            image: _selectedImages[4],
                            width: 80,
                            height: 190,
                            onTap: () => _pickImage(4)),
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
                  onPressed: _submitUpdates,
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

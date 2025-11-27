import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import '../../main.dart';
import './widgets/multi_select_widget.dart';
import './widgets/single_select_widget.dart';
import './widgets/text_input_widgets.dart';
import './widgets/image_button_widget.dart';
import '../../services/firebase_service.dart';
import '../../services/storage_service.dart';

//styles for profile page
abstract class ProfileStyles {
  static const formWidth = 375.0;
  static const textInputWidth = 250.0;

  static TextStyle inputHeader = const TextStyle(
      fontWeight: FontWeight.bold, color: Color(0xFFAA4E85), fontSize: 18);

  static final ButtonStyle button = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFD461A6),
    fixedSize: const Size(110, 50),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
}
//custom image button widget to get images from user

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});
  

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  //state for managing form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  //conditions to set which process of profile creation the user is on
  bool keyInfo = true;
  bool additionalInfo = false;
  bool isLoading = false;

  //text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  //controllers for managing multiselect dropdowns
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

  //call ffire
  final FirebaseService _firebaseService = FirebaseService();
  final StorageService _storageService = StorageService();

  String? _relationshipStatus;
  String? _relationshipStyle;
  String? _lookingFor;

  //need to figure out how to add to this from the seperate image picker thing
  final List<File?> _selectedImages = List.filled(5, null);
    
  // Upload progress tracking
  double _uploadProgress = 0.0;
  int _currentImageUploading = 0;
  int _totalImages = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _bioController.dispose();
    sexualityController.dispose();
    genderController.dispose();
    pronounController.dispose();
    sexualPrefController.dispose();
    genderPresentationController.dispose();
    interestsController.dispose();
    super.dispose();
  }
  
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

  bool _validateKeyInfo() {
    // if (_selectedImages.every((img) => img == null)) {
    //   _showSnackBar('Please add at least one photo');
    //   return false;
    // }
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your name');
      return false;
    }
    if (_ageController.text.trim().isEmpty) {
      _showSnackBar('Please enter your age');
      return false;
    }
    return true;
  }

  void _updateFormStep() {
    if (!additionalInfo && !_validateKeyInfo()) {
      return;
    }
    setState(() {
      additionalInfo = !additionalInfo;
      keyInfo = !keyInfo;
    });
  }

  Future<void> _submitForm() async {
    if (!_validateKeyInfo()) return;
    setState(() {
      isLoading = true;
    });
    
    try {
      final userId = _firebaseService.currentUserId;
      if (userId == null) {
        throw Exception('No user logged in');
      }

      final imagesToUpload = _selectedImages.whereType<File>().toList();
      _totalImages = imagesToUpload.length;
      List<String> imageUrls = [];

      if (imagesToUpload.isNotEmpty) {
        imageUrls = await _storageService.uploadMultipleProfileImages(
            imageFiles: imagesToUpload,
        userId: userId,
      );
      }

      final data = {
        'name': _nameController.text.trim(),
        'age': _ageController.text.trim(),
        'height': _heightController.text.trim(),
        'bio': _bioController.text.trim(),
        'sexuality': sexualityController.selectedItems.map((e) => e.value).toList(),
        'gender': genderController.selectedItems.map((e) => e.value).toList(),
        'pronouns': pronounController.selectedItems.map((e) => e.value).toList(),
        'relationship_status': _relationshipStatus ?? '',
        'relationship_style': _relationshipStyle ?? '',
        'expectations': _lookingFor ?? '',
        'expression': genderPresentationController.selectedItems.map((e) => e.value).toList(),
        'interests': interestsController.selectedItems.map((e) => e.value).toList(),
        'sexual_pref': sexualPrefController.selectedItems.map((e) => e.value).toList(),
        'profileImages': imageUrls ?? [],
        'photoURL': imageUrls.isNotEmpty ? imageUrls.first : '', 
      };

      await _firebaseService.updateUserProfile(data: data);
      //reroute to home at first page of nav menu
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const NavMenu()),
            (route) => false
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error submitting profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (SizedBox(
        width: ProfileStyles.formWidth,
        child: Form(
            key: _formKey,
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (keyInfo) ...[
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
                  TextInputField(
                      controller: _nameController,
                      labelText: "Name",
                      textType: "Name"),
                  TextInputField(
                      controller: _ageController,
                      labelText: "Age",
                      textType: "Age"),
                  TextInputFieldLong(controller: _bioController),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: _updateFormStep,
                        style: ProfileStyles.button,
                        child: const Text("Next")),
                  )
                ],

                if (additionalInfo) ...[
                  TextInputField(
                      controller: _heightController,
                      labelText: "Height",
                      textType: "Height"),
                  MultiSelectDropdown(
                      controller: sexualityController, labelText: "Sexuality"),
                  MultiSelectDropdown(
                      controller: genderController,
                      labelText: "Gender Identity"),
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
                    value: _relationshipStatus,
                    label: "Relationship Status",
                    onChanged: (newVal) {
                      setState(() {
                        _relationshipStatus = newVal;
                      });
                    },
                  ),
                  SingleSelectDropDown(
                    value: _relationshipStyle,
                    label: "Relationship Style",
                    onChanged: (newVal) {
                      setState(() {
                        _relationshipStyle = newVal;
                      });
                    },
                  ),
                  SingleSelectDropDown(
                    value: _lookingFor,
                    label: "Looking For",
                    onChanged: (newVal) {
                      setState(() {
                        _lookingFor = newVal;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: _updateFormStep,
                            style: ProfileStyles.button,
                            child: const Text("Previous")),
                        ElevatedButton(
                            onPressed: _submitForm,
                            style: ProfileStyles.button,
                            child: const Text("Finish"))
                      ]),
                ]
              ],
            ))));
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
          title: Text("Create Profile",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryFixed)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: BackButton(
            color: Theme.of(context).colorScheme.secondaryFixed,
          ),
        ),
        body: const Center(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              ProfileForm(),
              SizedBox(height: 30)
            ],
          )),
        ));
  }
}
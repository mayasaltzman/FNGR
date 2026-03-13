import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_milestone/pages/profile/widgets/multi_select_widget.dart';
import '../../main.dart';
import './widgets/single_select_widget.dart';
import './widgets/text_input_widgets.dart';
import './widgets/image_button_widget.dart';
import '../../services/firebase_service.dart';
import '../../services/storage_service.dart';
import './select_page.dart';
import './create_profile_steps/profile_intro_page.dart';
import './create_profile_steps/profile_sexuality_page.dart';
import './create_profile_steps/profile_photo_page.dart';
import './create_profile_steps/profile_bio_page.dart';
import './create_profile_steps/profile_additional_page.dart';
import './create_profile_steps/profile_save_page.dart';

/* CURRENT TO DO
1 - reorganize this form shit cause I hate it
3 - have the multi selects keep the same from page to page 
4 - get shit to properly save and think about how I want to reorganize the db */

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

/*
class ProfileForm extends StatefulWidget {
  final int formState;
  const ProfileForm({super.key, required this.formState});

  @override
  State<ProfileForm> createState() => _ProfileFormState();

  //adding parameters that will have state of form like what page,
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
        'sexuality':
            sexualityController.selectedItems.map((e) => e.value).toList(),
        'gender': genderController.selectedItems.map((e) => e.value).toList(),
        'pronouns':
            pronounController.selectedItems.map((e) => e.value).toList(),
        'relationship_status': _relationshipStatus ?? '',
        'relationship_style': _relationshipStyle ?? '',
        'expectations': _lookingFor ?? '',
        'expression': genderPresentationController.selectedItems
            .map((e) => e.value)
            .toList(),
        'interests':
            interestsController.selectedItems.map((e) => e.value).toList(),
        'sexual_pref':
            sexualPrefController.selectedItems.map((e) => e.value).toList(),
        'profileImages': imageUrls ?? [],
        'photoURL': imageUrls.isNotEmpty ? imageUrls.first : '',
      };

      await _firebaseService.updateUserProfile(data: data);
      //reroute to home at first page of nav menu
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => NavMenu()),
            (route) => false);
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

}
*/

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  //create param here to track the selected fields
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
            style:
                TextStyle(color: Theme.of(context).colorScheme.secondaryFixed)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: BackButton(
          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: ProfileIntroPage())
          //ProfileIntroPage()
          //split here into two forms and render info depending on which state var
          /*
              SizedBox(height: 5),
              ProfileForm(formState: 0), //pass the param from create profile from selected fields here too and then pass that to the widget
              SizedBox(height: 30)
              */
        ],
      ),
    );
  }
}

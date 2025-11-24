import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:image_picker/image_picker.dart';
import '../../main.dart';
import './widgets/multi_select_widget.dart';
import './widgets/single_select_widget.dart';
import './widgets/text_input_widgets.dart';
import '../../services/firebase_service.dart';

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
class ImageButton extends StatefulWidget {
  final File? image;
  final double width;
  final double height;

  const ImageButton(
      {super.key,
      required this.image,
      required this.width,
      required this.height});

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  final _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.image;
  }

  //method for image picking
  //NEED TO CONVERT IMAGE TO STRING FORMAT BUT IM NOT SURE WHAT FORMAT TO USE TBH
  //also right now when you go to next of the form and then back the images don't save
  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;

    final imageFile = File(pickedImage.path);

    setState(() {
      _selectedImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: widget.width,
        height: widget.height,
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primaryFixed,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : const Center(child: Icon(Icons.add, color: Colors.white)),
            ),
          ),
        ),
      ),
    ]);
  }
}

//widget for key info form
class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  //state for managing form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //conditions to set which process of profile creation the user is on
  bool keyInfo = true;
  bool additionalInfo = false;

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

  String? _relationshipStatus;
  String? _relationshipStyle;
  String? _lookingFor;

  //need to figure out how to add to this from the seperate image picker thing
  final List<File> _images = [];

  File? _image1, _image2, _image3, _image4, _image5;

  //for conditional rendering of steps of the form
  void _updateFormStep() {
    setState(() {
      additionalInfo = !additionalInfo;
      keyInfo = !keyInfo;
    });
  }
  
  void _submitForm() async {
    final data  = {
      'name': _nameController.text,
      'age': _ageController.text,
      'height': _heightController.text,
      'sexuality':
          sexualityController.selectedItems.map((e) => e.value).toList(),
      'gender': genderController.selectedItems.map((e) => e.value).toList(),
      'pronouns': pronounController.selectedItems.map((e) => e.value).toList(),
      'relationship_status': _relationshipStatus,
      'relationship_style': _relationshipStyle,
      'expectations': _lookingFor,
      'expression': genderPresentationController.selectedItems
          .map((e) => e.value)
          .toList(),
      'interests':
          interestsController.selectedItems.map((e) => e.value).toList(),
      'sexual_pref':
          sexualPrefController.selectedItems.map((e) => e.value).toList(),
      'bio': _bioController.text
    };
    await _firebaseService.updateUserProfile(data: data);
    //reroute to home at first page of nav menu
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const NavMenu()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (SizedBox(
        width: ProfileStyles.formWidth,
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (keyInfo) ...[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ImageButton(image: _image1, width: 200, height: 400),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            ImageButton(image: _image2, width: 80, height: 190),
                            const SizedBox(height: 10),
                            ImageButton(image: _image3, width: 80, height: 190),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children: [
                            ImageButton(image: _image4, width: 80, height: 190),
                            const SizedBox(height: 10),
                            ImageButton(image: _image5, width: 80, height: 190),
                          ],
                        ),
                      ]),
                  const SizedBox(height: 15),
                  TextInputField(
                      controller: _nameController,
                      labelText: "Name",
                      textType: "Name"),
                  const SizedBox(height: 15),
                  TextInputField(
                      controller: _ageController,
                      labelText: "Age",
                      textType: "Age"),
                  const SizedBox(height: 15),
                  TextInputFieldLong(controller: _bioController),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: _updateFormStep,
                        style: ProfileStyles.button,
                        child: const Text("Next")),
                  )
                ],

                //ADDITIONAL INFO FORM CONTENTS HERE
                if (additionalInfo) ...[
                  const SizedBox(height: 15),
                  TextInputField(
                      controller: _heightController,
                      labelText: "Height",
                      textType: "Height"),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: sexualityController, labelText: "Sexuality"),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: genderController,
                      labelText: "Gender Identity"),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: pronounController, labelText: "Pronouns"),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: sexualPrefController,
                      labelText: "Sexual Preferences"),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: genderPresentationController,
                      labelText: "Gender Presentation"),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: interestsController, labelText: "Interests"),
                  const SizedBox(height: 15),
                  SingleSelectDropDown(
                    value: _relationshipStatus,
                    label: "Relationship Status",
                    onChanged: (newVal) {
                      setState(() {
                        _relationshipStatus = newVal;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
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
                  const SizedBox(height: 20),
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

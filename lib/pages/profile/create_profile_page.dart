import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

//styles for profile page
abstract class ProfileStyles {
  static const formWidth = 375.0;
  static const textInputWidth = 250.0;

  static TextStyle inputHeader = const TextStyle(
      fontWeight: FontWeight.bold, color: Color(0xFFAA4E85), fontSize: 16);
}

//custom text input field for our form
class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final String textType;

  const TextInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        width: 100,
        child: Text(textType, style: ProfileStyles.inputHeader),
      ),
      SizedBox(
          width: ProfileStyles.textInputWidth,
          height: 50,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Color(0xFFAA4E85), fontSize: 16),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color(0xFFFFA96C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide:
                      const BorderSide(color: Color(0xFFFFA96C), width: 2),
                ),
                filled: true,
                fillColor: const Color(0xFFFFF0E6),
                labelText: labelText,
                labelStyle:
                    const TextStyle(color: Color(0xFFAA4E85), fontSize: 16)),
            validator: validator,
          ))
    ]);
  }
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
  final _picker = ImagePicker(); //create instance of image picker
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.image;
  }

  //method for image picking
  //NEED TO CONVERT IMAGE TO STRING FORMAT BUT IM NOT SURE WHAT FORMAT TO USE TBH
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
          child: FloatingActionButton(
            onPressed: () => _pickImage(),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(color: Color(0xFFAA4E85))),
            child: _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    width: double.infinity, //this stretch out the image lol Im so confused 
                    height: double.infinity,
                    fit: BoxFit.fill,
                  )
                : const Icon(Icons.add),
          )),
    ]);
  }
}

//custom multiselect dropdown widget
class MultiSelectDropdown extends StatelessWidget {
  final MultiSelectController<String> controller;
  final String labelText;
  final List<DropdownItem<String>> items;

  const MultiSelectDropdown({
    super.key,
    required this.controller,
    required this.labelText,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        width: 100,
        child: Text(labelText, style: ProfileStyles.inputHeader),
      ),
      SizedBox(
          width: ProfileStyles.textInputWidth,
          child: MultiDropdown(
            items: items, //need to add scrollable
            controller: controller,
          ))
    ]);
  }
}

//custom single dropdown widget
class SingleSelectDropDown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String label;
  final ValueChanged<String?> onChanged;

  const SingleSelectDropDown({
    super.key,
    required this.value,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: ProfileStyles.inputHeader),
        ),
        SizedBox(
          width: ProfileStyles.textInputWidth,
          child: DropdownButton<String>(
            hint: const Text("Select"),
            value: value,
            items: items
                .map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            onChanged: onChanged,
            dropdownColor: const Color(0xFFFFF0E6),
            style: const TextStyle(color: Color(0xFFAA4E85), fontSize: 16),
          ),
        ),
      ],
    );
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

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

  //instance of firebase
  final firestoreInstance = FirebaseFirestore.instance;

  //store info entered in form
  late String _name;
  late String
      _age; //this will have to be made integer idk probs convert before submit
  late String _height;
  late List<String> _sexuality;
  late List<String> _genderIdentity;
  late List<String> _pronouns;
  String? _relationshipStatus;
  String? _relationshipStyle;
  late List<String> _sexualPref;
  late List<String> _genderPresentation;
  late List<String> _interests;
  String? _lookingFor;
  String? _bio;

  //need to figure out how to add to this from the seperate image picker thing
  final List<File> _images = [];

  File? _image1, _image2, _image3, _image4, _image5;

  //for conditional rendering of steps of the form
  void _updateFormStep() {
    _formKey.currentState!.save(); //gets values from text form
    setState(() {
      additionalInfo = !additionalInfo;
      keyInfo = !keyInfo;
    });
  }

  //handles form submission
  void _submitForm() async {
    _formKey.currentState!.save();
    //get values from multiselect drop down and convert them to type list
    _name = _nameController.text;
    _age = _ageController.text;
    _height = _heightController.text;
    _sexuality = sexualityController.selectedItems.map((e) => e.value).toList();
    _genderIdentity =
        genderController.selectedItems.map((e) => e.value).toList();
    _pronouns = pronounController.selectedItems.map((e) => e.value).toList();
    _sexualPref =
        sexualPrefController.selectedItems.map((e) => e.value).toList();
    _genderPresentation =
        genderPresentationController.selectedItems.map((e) => e.value).toList();
    _interests = interestsController.selectedItems.map((e) => e.value).toList();

    //insert to database
    await firestoreInstance.collection('users').add({
      'name': _name,
      'age': _age,
      'height': _height,
      'sexuality': _sexuality,
      'gender': _genderIdentity,
      'pronouns': _pronouns,
      'relationship_status': _relationshipStatus,
      'relationship_style': _relationshipStyle,
      'expectations': _lookingFor,
      'expression': _genderPresentation,
      'interests': _interests,
      'sexual_pref': _sexualPref,
      'bio': _bio //,
      // 'photoURL': _images
    });
  }

  @override
  Widget build(BuildContext context) {
    //list of sexualities fields drop down memebers we can add more LOL
    var sexualities = [
      DropdownItem(label: 'Aromantic', value: "Aromantic"),
      DropdownItem(label: 'Asexual', value: "Asexual"),
      DropdownItem(label: 'Bisexual', value: "Bisexual"),
      DropdownItem(label: 'Demisexual', value: "Demisexual"),
      DropdownItem(label: 'Gay', value: "Gay"),
      DropdownItem(label: 'Lesbian', value: "Lesbian"),
      DropdownItem(label: 'Other', value: "Other"),
      DropdownItem(label: 'Pansexual', value: "Pansexual"),
      DropdownItem(label: 'Polysexual', value: "Polysexual"),
      DropdownItem(label: 'Queer', value: "Queer"),
      DropdownItem(label: 'Sapphic', value: "Sapphic")
    ];

    //gender identity values for drop down again we can add more not to get canceled but im lazy
    var genders = [
      DropdownItem(label: 'Agender', value: "Agender"),
      DropdownItem(label: 'Bigender', value: "Bigender"),
      DropdownItem(label: 'Genderfluid', value: "Genderfluid"),
      DropdownItem(label: 'Genderqueer', value: "Genderqueer"),
      DropdownItem(label: 'Intersex', value: "Intersex"),
      DropdownItem(label: 'Non-binary', value: "Non-binary"),
      DropdownItem(label: 'Pangender', value: "Pangender"),
      DropdownItem(label: 'Transgender', value: "Transgender"),
      DropdownItem(label: 'Trans Man', value: "Trans Man"),
      DropdownItem(label: 'Trans Woman', value: "Trans Woman"),
      DropdownItem(label: 'Trans Masculine', value: "Trans Masculine"),
      DropdownItem(label: 'Trans Feminine', value: "Trans Feminine"),
      DropdownItem(label: 'Two-Spirit', value: "Two-Spirit"),
      DropdownItem(label: 'Woman', value: "Woman")
    ];

    //pronouns ALSO NEED MORE BUT IM BUSY
    var pronouns = [
      DropdownItem(label: 'she/her', value: "she/her"),
      DropdownItem(label: 'they/them', value: "they/them"),
      DropdownItem(label: 'he/him', value: "he/him"),
      DropdownItem(label: 'ze/zir', value: "ze/zir"),
      DropdownItem(label: 'fae/faer', value: "fae/faer"),
      DropdownItem(label: 'ae/aer', value: "ae/aer"),
      DropdownItem(label: 'xe/xem', value: "xe/xem"),
      DropdownItem(label: 'it/its', value: "it/its"),
      DropdownItem(label: 'ask me', value: "ask me"),
    ];

    //relationship status for drop down
    List<String> relationshipStatuses = [
      'single',
      'open relationship',
      'in a relationship',
    ];

    //relationship style for drop down
    List<String> relationshipStyles = [
      'monogamous',
      'polyamorous',
      'ethical non monagamy',
      'relationship anarachy',
      'swinging',
      'exploring'
    ];

    //what your looking for types for drop down
    List<String> expectations = [
      'hookups',
      'long term relationship',
      'short term relationship',
      'casual dating',
      'figuring it out'
    ];

    //sexual preferences for drop down
    var sexualPrefs = [
      DropdownItem(label: 'top', value: "top"),
      DropdownItem(label: 'bottom', value: "bottom"),
      DropdownItem(label: 'switch', value: "switch"),
    ];

    //gender presentations for drop down
    var genderPresentations = [
      DropdownItem(label: 'androgynous', value: "androgynous"),
      DropdownItem(label: 'alien', value: "alien"),
      DropdownItem(label: 'chapstick', value: "chapstick"),
      DropdownItem(label: 'femme', value: "femme"),
      DropdownItem(label: 'futch', value: "futch"),
      DropdownItem(label: 'butch', value: "butch"),
      DropdownItem(label: 'lipstick', value: "lipstick"),
      DropdownItem(label: 'masc', value: "masc"),
      DropdownItem(label: 'stud', value: "stud"),
      DropdownItem(label: 'stemme', value: "stemme"),
    ];

    //interests for drop down
    var interestOptions = [
      DropdownItem(label: 'reading', value: "reading"),
      DropdownItem(label: 'outdoors', value: "outdoors"),
      DropdownItem(label: 'cooking', value: "cooking"),
      DropdownItem(label: 'emo femmes', value: "emo femmes"),
    ];

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
                  Text("About me", style: ProfileStyles.inputHeader),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          //add validator
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                          style: const TextStyle(
                              color: Color(0xFFAA4E85), fontSize: 16),
                          decoration: InputDecoration(
                            labelText: "Tell us about yourself!",
                            labelStyle: const TextStyle(
                                color: Color(0xFFAA4E85), fontSize: 16),
                            filled: true,
                            fillColor: const Color(0xFFFFF0E6),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFFFFA96C)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFFFA96C), width: 2),
                            ),
                          ),

                          onSaved: (value) => _bio = value!,
                        ))
                  ]),
                  const SizedBox(height: 20),

                  //button to navigate to next part of the form
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                        onPressed: _updateFormStep,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            fixedSize: const Size(100, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
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
                      controller: sexualityController,
                      labelText: "Sexuality",
                      items: sexualities),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: genderController,
                      labelText: "Gender Identity",
                      items: genders),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: pronounController,
                      labelText: "Pronouns",
                      items: pronouns),
                  const SizedBox(height: 15),
                  SingleSelectDropDown(
                    value: _relationshipStatus,
                    label: "Relationship Status",
                    items: relationshipStatuses,
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
                    items: relationshipStyles,
                    onChanged: (newVal) {
                      setState(() {
                        _relationshipStyle = newVal;
                      });
                    },
                  ),
                  SingleSelectDropDown(
                    value: _lookingFor,
                    label: "Looking For",
                    items: expectations,
                    onChanged: (newVal) {
                      setState(() {
                        _lookingFor = newVal;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: sexualPrefController,
                      labelText: "Sexual Preferences",
                      items: sexualPrefs),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: genderPresentationController,
                      labelText: "Gender Presentation",
                      items: genderPresentations),
                  const SizedBox(height: 15),
                  MultiSelectDropdown(
                      controller: interestsController,
                      labelText: "Interests",
                      items: interestOptions),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: _updateFormStep,
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                fixedSize: const Size(110, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            child: const Text("Previous")),
                        ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                fixedSize: const Size(100, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              ProfileForm(),
            ],
          ),
        ));
  }
}

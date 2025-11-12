import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

//styles for profile page
abstract class ProfileStyles {
  static const formWidth = 375.0;
  static const textInputWidth = 250.0;
}

//custom text input field for our form currently unused
class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;

  const TextInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }
}

class ImageButton extends StatefulWidget {
  final File? image;
  final double width;
  final double height;
  final int imageIndex;

  const ImageButton(
      {super.key,
      required this.image,
      required this.width,
      required this.height,
      required this.imageIndex});

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  final _picker = ImagePicker(); //create instance of image picker

  //method for image picking
  //NEED TO CONVERT IMAGE TO STRING FORMAT BUT IM NOT SURE WHAT FORMAT TO USE TBH
  void _pickImage(int imageNum) async {
    final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery); //pick image from gallery

    //check that image was actually picked
    //would love to get rid of this conditional logic :)))
    if (pickedImage != null) {
      setState(() {
        //if (widget.imageIndex == 1) {
        // widget.image = File(pickedImage.path); //convert from xfile to image fromat
        // _images.add(_image1!);
        // } else if (widget.imageIndex  == 2) {
        //   _image2 = File(pickedImage.path);
        //   _images.add(_image2!);
        // } else if (widget.imageIndex == 3) {
        //   _image3 = File(pickedImage.path);
        //   _images.add(_image3!);
        // } else if (widget.imageIndex  == 4) {
        //   _image4 = File(pickedImage.path);
        //   _images.add(_image4!);
        // } else if (imageNum == 5) {
        //   _image5 = File(pickedImage.path);
        //   _images.add(_image5!);
        // }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          width: widget.width,
          height: widget.height,
          child: widget.image != null
              ? Image.file(widget.image!)
              : FloatingActionButton(
                  onPressed: () => _pickImage(widget.imageIndex),
                  child: const Icon(Icons.add))),
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

  //final TextEditingController _nameController = TextEditingController();

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
  final List<File> _images = [];

  File? _image1, _image2, _image3, _image4, _image5;
  final _picker = ImagePicker(); //create instance of image picker

  // //method for image picking
  // //NEED TO CONVERT IMAGE TO STRING FORMAT BUT IM NOT SURE WHAT FORMAT TO USE TBH
  // void _pickImage(int imageNum) async {
  //   final pickedImage = await _picker.pickImage(
  //       source: ImageSource.gallery); //pick image from gallery

  //   //check that image was actually picked
  //   //would love to get rid of this conditional logic :)))
  //   if (pickedImage != null) {
  //     setState(() {
  //       if (imageNum == 1) {
  //         _image1 = File(pickedImage.path); //convert from xfile to image fromat
  //         _images.add(_image1!);
  //       } else if (imageNum == 2) {
  //         _image2 = File(pickedImage.path);
  //         _images.add(_image2!);
  //       } else if (imageNum == 3) {
  //         _image3 = File(pickedImage.path);
  //         _images.add(_image3!);
  //       } else if (imageNum == 4) {
  //         _image4 = File(pickedImage.path);
  //         _images.add(_image4!);
  //       } else if (imageNum == 5) {
  //         _image5 = File(pickedImage.path);
  //         _images.add(_image5!);
  //       }
  //     });
  //   }
  // }

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
      DropdownItem(label: 'Two-Spirit', value: "Two-Spirit"),
      DropdownItem(label: 'Woman', value: "Woman")
    ];

    //pronouns ALSO NEED MORE BUT IM BUSY
    var pronouns = [
      DropdownItem(label: 'she/her', value: "she/her"),
      DropdownItem(label: 'they/them', value: "they/them"),
      DropdownItem(label: 'he/him', value: "he/him"),
      DropdownItem(label: 'ze/zir', value: "ze/zir"),
    ];

    //relationship status for drop down
    List<String> relationshipStatuses = [
      'single',
      'open relationship',
      'in a relationship'
    ];

    //relationship style for drop down
    List<String> relationshipStyles = [
      'monogamous',
      'polyamorous',
    ];

    //what your looking for types for drop down
    List<String> expectations = [
      'hookups',
      'long term relationship',
      'short term relationship'
    ];

    //sexual preferences for drop down
    var sexualPrefs = [
      DropdownItem(label: 'top', value: "top"),
      DropdownItem(label: 'bottom', value: "bottom"),
      DropdownItem(label: 'switch', value: "switch"),
    ];

    //gender presentations for drop down
    var genderPresentations = [
      DropdownItem(label: 'masc', value: "masc"),
      DropdownItem(label: 'femme', value: "femme"),
      DropdownItem(label: 'androgynous', value: "androgynous"),
    ];

    //interests for drop down
    var interestOptions = [
      DropdownItem(label: 'reading', value: "reading"),
      DropdownItem(label: 'outdoors', value: "outdoors"),
      DropdownItem(label: 'cooking', value: "cooking"),
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
                        ImageButton(
                            image: _image1,
                            width: 200,
                            height: 400,
                            imageIndex: 1),
                        Column(
                          children: [
                            ImageButton(
                                image: _image2,
                                width: 80,
                                height: 190,
                                imageIndex: 2),
                            ImageButton(
                                image: _image3,
                                width: 80,
                                height: 190,
                                imageIndex: 3),
                          ],
                        ),
                        Column(
                          children: [
                            ImageButton(
                                image: _image4,
                                width: 80,
                                height: 190,
                                imageIndex: 4),
                            ImageButton(
                                image: _image5,
                                width: 80,
                                height: 190,
                                imageIndex: 5),
                          ],
                        ),
                      ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Name"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: TextFormField(
                          //add validator
                          decoration: const InputDecoration(labelText: "Name"),
                          onSaved: (value) => _name = value!,
                        ))
                  ]),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Age"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: TextFormField(
                          //hope to change this to date picker for birth day eventually
                          decoration: const InputDecoration(labelText: "Age"),
                          onSaved: (value) => _age = value!,
                        ))
                  ]),
                  const SizedBox(height: 15),
                  const Text("About me"),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          //add validator
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                          decoration: const InputDecoration(
                              labelText: "Tell us about yourself!",
                              border: OutlineInputBorder()),
                          onSaved: (value) => _bio = value!,
                        ))
                  ]),
                  const SizedBox(height: 20),
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
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Height"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: TextFormField(
                          decoration:
                              const InputDecoration(labelText: "Height"),
                          onSaved: (value) => _height = value!,
                        ))
                  ]),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Sexuality"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: MultiDropdown(
                          items: sexualities, //need to add scrollable
                          controller: sexualityController,
                        ))
                  ]),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Gender Identity"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: MultiDropdown(
                          items: genders, //need to add scrollable
                          controller: genderController,
                        ))
                  ]),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Pronouns"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: MultiDropdown(
                          items: pronouns, //need to add scrollable
                          controller: pronounController,
                        ))
                  ]),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Relationship Status"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: DropdownButton(
                            hint: const Text("Select"),
                            value: _relationshipStatus,
                            items: relationshipStatuses.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _relationshipStatus = newVal!;
                              });
                            }))
                  ]),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Relationship Style"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: DropdownButton(
                            hint: const Text("Select"),
                            value: _relationshipStyle,
                            items: relationshipStyles.map((style) {
                              return DropdownMenuItem(
                                value: style,
                                child: Text(style),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _relationshipStyle = newVal!;
                              });
                            }))
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Looking For"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: DropdownButton(
                            hint: const Text("Select"),
                            value: _lookingFor,
                            items: expectations.map((exp) {
                              return DropdownMenuItem(
                                value: exp,
                                child: Text(exp),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                _lookingFor = newVal!;
                              });
                            }))
                  ]),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Sexual Preferences"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: MultiDropdown(
                          items: sexualPrefs, //need to add scrollable
                          controller: sexualPrefController,
                        ))
                  ]),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Gender Presentation"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: MultiDropdown(
                          items: genderPresentations, //need to add scrollable
                          controller: genderPresentationController,
                        ))
                  ]),
                  const SizedBox(height: 15),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Interests"),
                    ),
                    SizedBox(
                        width: ProfileStyles.textInputWidth,
                        child: MultiDropdown(
                          items: interestOptions, //need to add scrollable
                          controller: interestsController,
                        ))
                  ]),
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
                            child: const Text(
                                "Finish")) //will handle form submit THIS ONE DEPENDS ON PREV FORM ID ,
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
          ), //need to make this actually do something and give it color change for press
        ),
        body: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileForm(),
            ],
          ),
        ));
  }
}

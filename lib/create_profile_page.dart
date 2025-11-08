import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//styles for profile page
abstract class ProfileStyles {
  static const formWidth = 375.0;
  static const textInputWidth = 250.0;
}

//widget for key info form
class KeyInfoForm extends StatefulWidget {
  const KeyInfoForm({super.key});

  @override
  State<KeyInfoForm> createState() => _KeyInfoFormState();
}

class _KeyInfoFormState extends State<KeyInfoForm> {
  //state for managing form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //conditions to set which process of profile creation the user is on
  bool keyInfo = true;
  bool additionalInfo = false;

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

  //for conditional rendering of steps of the form
  void _updateFormStep(){
    setState(() {
      additionalInfo = true;
      keyInfo = false;
    });
  }

  //handles form submission
  void _submitForm() async {
    _formKey.currentState!.save(); //gets values from text form
    //get values from multiselect drop down and convert them to type list
    _sexuality = sexualityController.selectedItems.map((e) => e.value).toList();
    _genderIdentity =
        genderController.selectedItems.map((e) => e.value).toList();
    _pronouns = pronounController.selectedItems.map((e) => e.value).toList();

    //insert to database
    await firestoreInstance.collection('users').add({
      'name': _name,
      'age': _age,
      'height': _height,
      'sexuality': _sexuality,
      'gender': _genderIdentity,
      'pronouns': _pronouns,
      'relationship_status': _relationshipStatus,
      'relationship_style': _relationshipStyle
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
                          child: const Text("Next")) //will handle form submit,
                      )
                ],
                //ADDITIONAL INFO FORM CONTENTS HERE
                if (additionalInfo) ...[
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(
                      width: 100,
                      child: Text("Relationship Style"),
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
                  Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              fixedSize: const Size(100, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text(
                              "Finish")) //will handle form submit THIS ONE DEPENDS ON PREV FORM ID ,
                      )
                ]
              ],
            ))));
  }
}


//IDEA ALERT!!!
/*
Current structure of the page is not how I actually want profile creation cause its not Sexy
instead we do it like we prompt user for name and age with one form
then another for pics
then we ask key info questions
then bio and additional info questions
this is a good jumping off point
*/
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
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Key Info",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  textAlign: TextAlign.left),
              const KeyInfoForm(),
            ],
          ),
        ));
  }
}

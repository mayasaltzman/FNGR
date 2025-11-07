import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//styles for profile page
abstract class ProfileStyles {
  static const formWidth = 375.0;
  static const textInputWidth = 250.0;

  static BoxDecoration boxDecoration = BoxDecoration(
      color: const Color(0xFFFF9B55),
      border: Border.all(
        color: const Color(0xFFFFF0E6),
        width: 1,
      ));
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  //state for managing form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //controllers for managing multiselect dropdowns
  final MultiSelectController<String> sexualityController =
      MultiSelectController<String>();
  final MultiSelectController<String> genderController =
      MultiSelectController<String>();
  final MultiSelectController<String> pronounController =
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
      'pronouns': _pronouns
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
    var relationship_status = [
      DropdownItem(label: 'single', value: "single"),
      DropdownItem(label: 'open relationship', value: "open relationship"),
      DropdownItem(label: 'in a relationship', value: "in a relationship"),
    ];

    //relationship style for drop down
    var relationship_style = [
      DropdownItem(label: 'monogamous', value: "monogamous"),
      DropdownItem(label: 'polyamorous', value: "polyamorous")
    ];

    return (SizedBox(
        width: ProfileStyles.formWidth,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      decoration: const InputDecoration(labelText: "Height"),
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
              // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              //   const Text("Relationship Status"),
              //   SizedBox(
              //       width: ProfileStyles.textInputWidth,
              //       child: MultiDropdown(
              //         items: relationship_status, //need to add scrollable
              //       ))
              // ]),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              //   const Text("Relationship Style"),
              //   SizedBox(
              //       width: ProfileStyles.textInputWidth,
              //       child: MultiDropdown(
              //         items: relationship_style, //need to add scrollable
              //       ))
              // ]),
              ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Next")) //will handle form submit
            ],
          ),
        )));
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
          title: const Text("Create Profile"),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading:
              const BackButton(), //need to make this actually do something and give it color change for press
        ),
        body: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Key Info",
                  style: TextStyle(color: Color(0xFFFF9B55)),
                  textAlign: TextAlign.left),
              ProfileForm()
            ],
          ),
        ));
  }
}

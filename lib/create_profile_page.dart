import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

//styles for profile page
abstract class ProfileStyles {
  static const formWidth = 375.0;
  static const textInputWidth = 250.0;
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  //state for managing form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //store name entered
  String _name = "";
  String _age =
      ""; //this will have to be made integer idk probs convert before submit

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

    return (SizedBox(
      width: ProfileStyles.formWidth,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text("Name"),
            SizedBox(
                width: ProfileStyles.textInputWidth,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                ))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text("Age"),
            SizedBox(
                width: ProfileStyles.textInputWidth,
                child: TextFormField(
                  //hope to change this to date picker for birth day eventually
                  decoration: const InputDecoration(labelText: "Age"),
                ))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text("Height"),
            SizedBox(
                width: ProfileStyles.textInputWidth,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Height"),
                ))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text("Sexuality"),
            SizedBox(
                width: ProfileStyles.textInputWidth,
                child: MultiDropdown(
                  items: sexualities, //need to add scrollable
                ))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            const Text("Gender"),
            SizedBox(
                width: ProfileStyles.textInputWidth,
                child: MultiDropdown(
                  items: genders, //need to add scrollable
                ))
          ])
        ],
      ),
    ));

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
          title: const Text("Create Profile"),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading:
              const BackButton(), //need to make this actually do something and give it color change for press
        ),
        body: const ProfileForm());
  }
}

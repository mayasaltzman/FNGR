import 'package:flutter/material.dart';
import '../widgets/text_input_widgets.dart';
import 'dart:io';
import './profile_sexuality_page.dart';
import './styles/create_profile_styles.dart';

class ProfileIntroPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  ProfileIntroPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Padding(
          padding: EdgeInsets.all(ProfileStyles.formPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: ProfileStyles.spacing,
            children: [
              Text("Weclome! Why don't you introduce yourself 😊",
                  style: ProfileStyles.pageHeader(context)),
              TextInputField(
                  controller: _nameController,
                  labelText: "Enter your name",
                  textType: "What is your name?"),
              TextInputFieldBirthday(),
              TextInputField(
                  controller: _locationController,
                  labelText: "Enter your location",
                  textType: "Where are you from?"),
              Spacer(),
              Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileSexualityPage()),
                        );
                      },
                      label: Text("Next"),
                      icon: Icon(Icons.arrow_forward_ios),
                      iconAlignment: IconAlignment.end,
                      style: ProfileStyles.nextButton(context)))
            ],
          ),
        ));
  }
}

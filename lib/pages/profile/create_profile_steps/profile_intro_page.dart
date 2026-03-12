import 'package:flutter/material.dart';
import '../widgets/text_input_widgets.dart';

//make elements on this page mandatory for an account when doing backend
//the rest of elements on other pages can be skippable
class ProfileIntroPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  ProfileIntroPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          Text("Weclome! Why don't you introduce yourself 😊:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAA4E85),
                  fontSize: 25)),
          TextInputField(
              controller: _nameController,
              labelText: "Name",
              textType: "Your first name"),
          TextInputFieldBirthday(),
          TextInputField(
              controller: _locationController,
              labelText: "Location",
              textType: "Where are you from?"),
          Spacer(),
          Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                  onPressed: () {},
                  label: Text("Next"),
                  icon: Icon(Icons.arrow_forward_ios),
                  iconAlignment: IconAlignment.end,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAA4E85),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  )))
        ],
      ),
    );
  }
}

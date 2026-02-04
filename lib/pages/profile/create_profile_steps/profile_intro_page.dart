import 'package:flutter/material.dart';
import '../widgets/text_input_widgets.dart';

class ProfileIntroPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

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
          Text("Weclome! Why don't you introduce yourself",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAA4E85),
                  fontSize: 25)),
          TextInputField(
              controller: _nameController,
              labelText: "Name",
              textType: "Your first name"),
          TextInputFieldBirthday(),
          Spacer(),
          Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward_ios),
              ))
        ],
      ),
    );
  }
}

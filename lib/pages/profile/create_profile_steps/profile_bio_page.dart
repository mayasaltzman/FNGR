import 'package:flutter/material.dart';
import '../widgets/text_input_widgets.dart';

//make elements on this page mandatory for an account when doing backend
//the rest of elements on other pages can be skippable
class ProfileBioPage extends StatelessWidget {
  final TextEditingController _bioController = TextEditingController();

  ProfileBioPage({
    super.key,
  });

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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 30,
          children: [
            Text("Add a quick description about yourself:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAA4E85),
                    fontSize: 25)),
            TextInputFieldLong(controller: _bioController),
            Spacer(),
            Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                    onPressed: () {},
                    label: Text("Skip"),
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
      ),
    );
  }
}

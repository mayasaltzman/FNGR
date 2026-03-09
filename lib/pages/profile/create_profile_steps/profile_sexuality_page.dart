import 'package:flutter/material.dart';

class ProfileSexualityPage extends StatelessWidget {
  ProfileSexualityPage({
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
              Text("Lets get a bit more information to help build your profile!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAA4E85),
                      fontSize: 25)),
            ]));
  }
}

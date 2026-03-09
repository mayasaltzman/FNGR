import 'package:flutter/material.dart';

//make elements on this page mandatory for an account when doing backend
//the rest of elements on other pages can be skippable
class ProfilePhotoPage extends StatelessWidget {
  ProfilePhotoPage({
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
          Text("Add some photos for people to get a sense of who you are:",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAA4E85),
                  fontSize: 25)),
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
    );
  }
}

import 'package:flutter/material.dart';

//make elements on this page mandatory for an account when doing backend
//the rest of elements on other pages can be skippable
class ProfileSavePage extends StatelessWidget {
  ProfileSavePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          Text("Insert FNGR Logo/Animation Here",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAA4E85),
                  fontSize: 25),
              textAlign: TextAlign.center),
          Text("Your all good to go! Happy FNGRing!",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAA4E85),
                  fontSize: 25),
              textAlign: TextAlign.center),
          ElevatedButton(
              onPressed: () {},
              child: Text("Save", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFAA4E85),
                foregroundColor: Colors.white,
                fixedSize: const Size(150, 50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              )),
          Text("You can update this info later",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAA4E85),
                  fontSize: 15),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

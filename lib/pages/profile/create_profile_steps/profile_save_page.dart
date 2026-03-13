import 'package:flutter/material.dart';
import './profile_save_page.dart';
import './styles/create_profile_styles.dart';

class ProfileSavePage extends StatelessWidget {
  ProfileSavePage({
    super.key,
  });

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
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(ProfileStyles.formPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              Text("Insert FNGR Logo/Animation Here",
                  style: ProfileStyles.pageHeader(context),
                  textAlign: TextAlign.center),
              Text("Your all good to go! Happy FNGRing!",
                  style: ProfileStyles.pageHeader(context),
                  textAlign: TextAlign.center),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileSavePage()),
                    );
                  },
                  child: Text("Save", style: TextStyle(fontSize: 20)),
                  style: ProfileStyles.saveButton(context)),
              Text("You can update this info later",
                  style: ProfileStyles.subText(context),
                  textAlign: TextAlign.center),
            ],
          ),
        ));
  }
}

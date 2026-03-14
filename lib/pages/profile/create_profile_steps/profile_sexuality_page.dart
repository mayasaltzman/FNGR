import 'package:flutter/material.dart';
import '../widgets/multi_select_menu_widget.dart';
import './profile_bio_page.dart';
import './styles/create_profile_styles.dart';

class ProfileSexualityPage extends StatelessWidget {
  ProfileSexualityPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> fieldTypes = ['Sexuality', 'Gender Identity', 'Pronouns'];
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
          padding: EdgeInsets.all(ProfileStyles.formPadding),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 30,
              children: [
                Text(
                    "Lets get a bit more information to help build your profile!",
                    style: ProfileStyles.pageHeader(context)),
                MultiSelect(fieldTypes: fieldTypes),
                Spacer(),
                Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileBioPage()),
                        );
                      },
                      label: Text("Skip"),
                      icon: Icon(Icons.arrow_forward_ios),
                      iconAlignment: IconAlignment.end,
                      style: ProfileStyles.nextButton(context),
                    ))
              ])),
    );
  }
}

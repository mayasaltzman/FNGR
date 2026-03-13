import 'package:flutter/material.dart';
import '../widgets/text_input_widgets.dart';
import './profile_photo_page.dart';
import './styles/create_profile_styles.dart';

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
        padding: EdgeInsets.all(ProfileStyles.formPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: ProfileStyles.spacing,
          children: [
            Text("Add a quick description about yourself:",
                style: ProfileStyles.pageHeader(context)),
            TextInputFieldLong(controller: _bioController),
            Spacer(),
            Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePhotoPage()),
                      );
                    },
                    label: Text("Skip"),
                    icon: Icon(Icons.arrow_forward_ios),
                    iconAlignment: IconAlignment.end,
                    style: ProfileStyles.nextButton(context)))
          ],
        ),
      ),
    );
  }
}

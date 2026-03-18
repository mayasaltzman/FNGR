import 'package:flutter/material.dart';
import 'package:test_milestone/pages/auth/login_page.dart';
import '../../services/firebase_service.dart';
import '../../main.dart';
import 'package:flutter/cupertino.dart';

//styles for the page
abstract class SettingsStyles {
  static ButtonStyle settingsButton(BuildContext context) {
    return ElevatedButton.styleFrom(
      fixedSize: const Size(500, 50),
      side: BorderSide.none,
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0.0,
    );
  }

  static Icon styledIcon(BuildContext context){
    return Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.primaryFixed,
        size: 24,
      );
  }


  static TextStyle buttonText(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primaryFixed, fontSize: 16);
  }

}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  bool isLoading = false;
  bool _allowNotifs = true;
  bool _allowLocation = true;

  Future<void> _signOut() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _firebaseService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      _showSnackBar('Logout failed: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: BackButton(
          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
        centerTitle: true,
        title: Text("Settings",
            style:
                TextStyle(color: Theme.of(context).colorScheme.secondaryFixed)),
      ),
      body: SingleChildScrollView(
        child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: SettingsStyles.settingsButton(context),
                    onPressed: isLoading
                        ? null
                        : () {
                            _showSnackBar(
                                "Please press the toggle to alter notification settings");
                          },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            "Allow notifications",
                            style: SettingsStyles.buttonText(context),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.6,
                          child: CupertinoSwitch(
                            value: _allowNotifs,
                            onChanged: (bool newValue) {
                              setState(() {
                                _allowNotifs = newValue;
                              });
                            },
                            activeTrackColor:
                                Theme.of(context).colorScheme.primaryFixed,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  ElevatedButton(
                    style: SettingsStyles.settingsButton(context),
                    onPressed: isLoading
                        ? null
                        : () {
                            _showSnackBar(
                                "Please press the toggle to alter location settings");
                          },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            "Allow location access",
                            style: SettingsStyles.buttonText(context),
                          ),
                        ),
                        Transform.scale(
                          scale: 0.6,
                          child: CupertinoSwitch(
                            value: _allowLocation,
                            onChanged: (bool newValue) {
                              setState(() {
                                _allowLocation = newValue;
                              });
                            },
                            activeTrackColor:
                                Theme.of(context).colorScheme.primaryFixed,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  ElevatedButton(
                    style: SettingsStyles.settingsButton(context),
                    onPressed: isLoading
                        ? null
                        : () {
                            print("Insert filters page nav here");
                          },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Row(children: [
                        Text(
                          "Edit Preferences",
                          style: SettingsStyles.buttonText(context),
                        ),
                        Spacer(),
                        SettingsStyles.styledIcon(context),
                      ]),
                    ),
                  ),
                  ElevatedButton(
                    style: SettingsStyles.settingsButton(context),
                    onPressed: isLoading
                        ? null
                        : () {
                            print("Verify profile function appears");
                          },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Row(children: [
                        Text(
                          "Verify Profile",
                          style: SettingsStyles.buttonText(context),
                        ),
                        Spacer(),
                        SettingsStyles.styledIcon(context),
                      ]),
                    ),
                  ),
                  ElevatedButton(
                    style: SettingsStyles.settingsButton(context),
                    onPressed: isLoading
                        ? null
                        : () {
                            print("Insert delete account functionality");
                          },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Row(children: [
                        Text(
                          "Delete FNGR account",
                          style: SettingsStyles.buttonText(context),
                        ),
                        Spacer(),
                        SettingsStyles.styledIcon(context),
                      ]),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  _signOut();
                                },
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Theme.of(context).colorScheme.secondaryFixed),
                          ), style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondary)))
                ],
              ),
            )),
      ),
    );
  }
}

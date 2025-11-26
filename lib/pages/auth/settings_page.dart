import 'package:flutter/material.dart';
import 'package:test_milestone/pages/auth/login_page.dart';
import '../../services/firebase_service.dart';
import '../../main.dart';
import 'package:flutter/cupertino.dart';
import '../../main.dart'; // Import Login Page

//styles for the page
abstract class ProfileStyles {
  //styles for setting buttons
  static ButtonStyle get settingsButton => ElevatedButton.styleFrom(
      fixedSize: const Size(500, 50),
      side: BorderSide.none,
      backgroundColor: const Color(0xFFFFE0CA),
      elevation: 0.0,
    );
  
  //styles for icons on buttons
  static Icon styledIcon() => const Icon(
      Icons.arrow_forward_ios,
      color: Color(0xFFD461A6),
      size: 24,
    );

  //style for text on buttons
  static TextStyle get boxHeader => const TextStyle(
      fontWeight: FontWeight.bold, color: Color(0xFFFF9B55), fontSize: 16);
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
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(45.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "Settings",
                    style: ProfileStyles.boxHeader.copyWith(
                      fontSize: 40 / MediaQuery.of(context).textScaleFactor,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                
                Divider(
                  thickness: 4,
                  color: ProfileStyles.boxHeader.color,
                  height: 40,
                ),


                ElevatedButton(
                  style: ProfileStyles.settingsButton,
                  onPressed: isLoading ? null : () {
                    _showSnackBar("Please press the toggle to alter notification settings");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Row (
                      children: [
                        Expanded(
                          child: Text(
                            "Allow notifications",
                            style: ProfileStyles.boxHeader,
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
                            activeColor:Color(0xFFD461A6),
                          ),
                        ),
                      ]
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ProfileStyles.settingsButton,
                  onPressed: isLoading ? null : () {
                    _showSnackBar("Please press the toggle to alter location settings");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Row (
                      children: [
                        Expanded(
                          child: Text(
                            "Allow location access",
                            style: ProfileStyles.boxHeader,
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
                            activeColor:Color(0xFFD461A6),
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                                
                ElevatedButton(
                  style: ProfileStyles.settingsButton,
                  onPressed: isLoading ? null : () {
                    print("Insert filters page nav here");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Row (
                      children: [
                        Text(
                          "Edit Preferences",
                          style: ProfileStyles.boxHeader,
                        ),
                        Spacer(),
                        ProfileStyles.styledIcon(),
                      ]
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ProfileStyles.settingsButton,
                  onPressed: isLoading ? null : () {
                    print("Verify profile function appears");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Row (
                      children: [
                        Text(
                          "Verify Profile",
                          style: ProfileStyles.boxHeader,
                        ),
                        Spacer(),
                        ProfileStyles.styledIcon(),
                      ]
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ProfileStyles.settingsButton,
                  onPressed: isLoading ? null : () {
                    print("Insert delete account functionality");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Row (
                      children: [
                        Text(
                          "Delete FNGR account",
                          style: ProfileStyles.boxHeader,
                        ),
                        Spacer(),
                        ProfileStyles.styledIcon(),
                      ]
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(top: 380, right: 190),
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () {
                      _signOut();
                    },
                    child: Text(
                      "Logout",
                      style: ProfileStyles.boxHeader,
                    ),
                  ),
                ),

                const SizedBox(height: 35),
                Text(
                  "Settings",
                  style: ProfileStyles.boxHeader.copyWith(
                    fontSize: 40 / MediaQuery.of(context).textScaleFactor,
                    color: const Color(0xFFFFFFFF),
                  ),
                ),
                
                Divider(
                  thickness: 4,
                  color: ProfileStyles.boxHeader.color,
                  height: 40,
                ),
                
                ElevatedButton(
                  onPressed: isLoading ? null : () {
                    print("great");
                  },
                  
                  style: TextButton.styleFrom(
                    fixedSize: Size(500, 50),
                    side: BorderSide.none,
                    backgroundColor: Color(0xFFFFE0CA),
                    elevation: 0.0,
                  ),
                  
                  child: Text(
                    "Edit Profile",
                    style: ProfileStyles.boxHeader,
                  ),
                ),

                const SizedBox(height: 640),
                ElevatedButton(
                  onPressed: isLoading ? null : () {
                    _signOut();
                  },
                  child: Text(
                    "Logout",
                    style: ProfileStyles.boxHeader,
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:test_milestone/pages/auth/login_page.dart';
import '../../services/firebase_service.dart';
import '../../main.dart'; // Import Login Page

//styles for the page
abstract class ProfileStyles {
  //styles for boxes
  static BoxDecoration boxDecoration = BoxDecoration(
      color: const Color(0xFFFFF0E6),
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(
        color: const Color(0xFFFF9B55),
        width: 1,
      ));

  //text styles for headings in boxes
  static TextStyle boxHeader = const TextStyle(
      fontWeight: FontWeight.bold, color: Color(0xFFFF9B55), fontSize: 44);

  //text styles for text in boxes
  static TextStyle boxText = const TextStyle(
      fontWeight: FontWeight.normal, color: Color(0xFFAA4E85), fontSize: 16);

  static const containerWidth = 375.0;

  static const boxPadding = EdgeInsets.all(8.0);
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  //final TextEditingController _emailController = TextEditingController();
  //final TextEditingController _passwordController  = TextEditingController();
  bool isLoading = false;

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
    //_emailController.dispose();
    //_passwordController.dispose();
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
                const SizedBox(height: 35),
                Text(
                  "Settings",
                  style: ProfileStyles.boxHeader.copyWith(
                    fontSize: 26 / MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                Divider(
                  thickness: 3,
                  color: Theme.of(context).colorScheme.secondary,
                  height: 40,
                ),
                
                const SizedBox(height: 640),
                ElevatedButton(
                  onPressed: isLoading ? null : () {
                    _signOut();
                  },
                  child: Text(
                    "Logout",
                    style: ProfileStyles.boxText,
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

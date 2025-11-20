import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../pages/profile/create_profile_page.dart';

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
      fontWeight: FontWeight.bold, color: Color(0xFFFF9B55), fontSize: 16);

  //text styles for text in boxes
  static TextStyle boxText = const TextStyle(
      fontWeight: FontWeight.normal, color: Color(0xFFAA4E85), fontSize: 16);

  static const containerWidth = 375.0;

  static const boxPadding = EdgeInsets.all(8.0);
}

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final FirebaseService firebaseService = FirebaseService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();
  bool isLoading = false;


  Future<void> createUserAccount() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }
    if (_passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters long');
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {

      final userCredential = await firebaseService.createAccount(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential == null) {
        throw Exception('User credential is null');
      }

      await firebaseService.createUserProfile(
        uid: userCredential.user!.uid, 
        email: _emailController.text.trim(),
        );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const CreateProfilePage()),
        );
      }
    } catch (e) {
      _showSnackBar('Account creation failed: $e');
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Create FNGR Account", 
                style: ProfileStyles.boxHeader,
              ),
              
              const SizedBox(height: 30),
              Container(      
                decoration: ProfileStyles.boxDecoration,
                padding: ProfileStyles.boxPadding,
                width: ProfileStyles.containerWidth,         
                child: TextField(
                  controller: _emailController,
                  style: ProfileStyles.boxText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Enter your email',
                    labelStyle: ProfileStyles.boxText,
                  ),
                ), 
              ),

              const SizedBox(height: 10),
              Container(
                decoration: ProfileStyles.boxDecoration,
                padding: ProfileStyles.boxPadding,
                width: ProfileStyles.containerWidth,
                child: TextField(
                  controller: _passwordController,
                  style: ProfileStyles.boxText,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Enter your password',
                    labelStyle: ProfileStyles.boxText,
                  ), 
                ),
              ),
              
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : () {
                  createUserAccount();
                },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        "Create Account",
                        style: ProfileStyles.boxText,
                      ),
              ),
            ],
          )
        )
      ),
    );
  }
}

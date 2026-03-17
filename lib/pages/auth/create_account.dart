import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_milestone/pages/auth/login_page.dart';
import '../../services/firebase_service.dart';
import '../../pages/profile/create_profile_page.dart';

//styles for the page
abstract class LogInStyles {
  static BoxDecoration boxDecoration(BuildContext context) {
    return BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryFixed,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryFixed,
          width: 1,
        ));
  }

  static ButtonStyle buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondaryFixed,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
    );
  }

  static TextStyle boxHeader(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 50);
  }

  static TextStyle instructionText(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.normal,
        color: Theme.of(context).colorScheme.primaryFixed,
        fontSize: 16);
  }

  static TextStyle buttonText(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.secondaryFixed,
        fontSize: 16);
  }

  static TextStyle linkText(BuildContext context) {
    return TextStyle(
      decoration: TextDecoration.underline,
      decorationColor: Theme.of(context).colorScheme.primaryFixed,
      color: Theme.of(context).colorScheme.primaryFixed,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  }

  static const containerWidth = 375.0;

  static const boxPadding = EdgeInsets.symmetric(vertical: 1, horizontal: 8);
}

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final FirebaseService firebaseService = FirebaseService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;

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

  void _confirmPassword() {
    if (_confirmPasswordController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      _showSnackBar('Please ensure both password fields match');
      return;
    }
    createUserAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Text('Create Account',
                  style: LogInStyles.boxHeader(context),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 320, top: 40),
              child: Text(
                'Email',
                style: LogInStyles.instructionText(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Container(
                decoration: LogInStyles.boxDecoration(context),
                padding: LogInStyles.boxPadding,
                width: LogInStyles.containerWidth,
                child: TextField(
                  controller: _emailController,
                  style: LogInStyles.instructionText(context),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your email',
                    hintStyle: LogInStyles.instructionText(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 290, top: 10),
              child: Text(
                'Password',
                style: LogInStyles.instructionText(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Container(
                decoration: LogInStyles.boxDecoration(context),
                padding: LogInStyles.boxPadding,
                width: LogInStyles.containerWidth,
                child: TextField(
                  controller: _passwordController,
                  style: LogInStyles.instructionText(context),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Enter your password',
                    labelStyle: LogInStyles.instructionText(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 225, top: 10),
              child: Text(
                'Confirm password',
                style: LogInStyles.instructionText(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Container(
                decoration: LogInStyles.boxDecoration(context),
                padding: LogInStyles.boxPadding,
                width: LogInStyles.containerWidth,
                child: TextField(
                  controller: _confirmPasswordController,
                  style: LogInStyles.instructionText(context),
                  obscureText: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Re-enter password',
                    labelStyle: LogInStyles.instructionText(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.secondary,
                    checkColor: Theme.of(context).colorScheme.secondaryFixed,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primaryFixed),
                  ),
                  Text(
                    'Remember Me',
                    style: LogInStyles.instructionText(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                padding: LogInStyles.boxPadding,
                width: LogInStyles.containerWidth,
                child: ElevatedButton(
                  style: LogInStyles.buttonStyle(context),
                  onPressed: isLoading
                      ? null
                      : () {
                          _confirmPassword();
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Sign Up',
                          style: LogInStyles.buttonText(context),
                        ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).colorScheme.primaryFixed,
                      thickness: 0.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Already have an account?',
                      style: LogInStyles.instructionText(context),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).colorScheme.primaryFixed,
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                padding: LogInStyles.boxPadding,
                width: LogInStyles.containerWidth,
                child: ElevatedButton(
                  style: LogInStyles.buttonStyle(context),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  },
                  child: Text(
                    'Login',
                    style: LogInStyles.buttonText(context),
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}

import 'package:flutter/material.dart';
import 'package:test_milestone/pages/profile/create_profile_steps/profile_additional_page.dart';
import '../../pages/auth/create_account.dart';
import '../../services/firebase_service.dart';
import '../../main.dart'; // Import NavMenu
import './styles/auth_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool rememberMe = false;

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await _firebaseService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => NavMenu()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      _showSnackBar('Login failed: $e');
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Semantics(
                  label: "Finger",
                  hint: "Finger login page",
                  header: true,
                  child: Text(
                    'FNGR',
                    style: LogInStyles.boxHeader(context),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(right: 320, top: 40),
                child: Semantics(
                    label: "Email",
                    child: Text(
                      'Email',
                      style: LogInStyles.instructionText(context),
                    ))),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Container(
                  decoration: LogInStyles.boxDecoration(context),
                  padding: LogInStyles.boxPadding,
                  width: LogInStyles.containerWidth,
                  child: Semantics(
                    textField: true,
                    isRequired: true,
                    label: 'Enter your email',
                    child: TextField(
                      controller: _emailController,
                      style: LogInStyles.instructionText(context),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your email',
                        hintStyle: LogInStyles.instructionText(context),
                      ),
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 290, top: 10),
              child: Semantics(
                label: "Password",
                child: Text(
                  'Password',
                  style: LogInStyles.instructionText(context),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Container(
                decoration: LogInStyles.boxDecoration(context),
                padding: LogInStyles.boxPadding,
                width: LogInStyles.containerWidth,
                child: Semantics(
                    textField: true,
                    isRequired: true,
                    child: TextField(
                      controller: _passwordController,
                      style: LogInStyles.instructionText(context),
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your password',
                        hintStyle: LogInStyles.instructionText(context),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Row(
                children: [
                  Semantics(
                    label: "Remember me",
                    hint: "Double tap to remember on next login",
                    checked: rememberMe,
                    child: Checkbox(
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
                  ),
                  Semantics(
                      excludeSemantics: true,
                      child: Text(
                        'Remember Me',
                        style: LogInStyles.instructionText(context),
                      )),
                  //this does not have functionality yet so didnt add semantics
                  TextButton(
                    onPressed: () {
                      print('Clicked! - go to change password backend');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 80),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: LogInStyles.linkText(context),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                  padding: LogInStyles.boxPadding,
                  width: LogInStyles.containerWidth,
                  child: Semantics(
                    label: "Login",
                    button: true,
                    child: ElevatedButton(
                      style: LogInStyles.buttonStyle(context),
                      onPressed: isLoading
                          ? null
                          : () {
                              _signIn();
                            },
                      child: Text(
                        'Login',
                        style: LogInStyles.buttonText(context),
                      ),
                    ),
                  )),
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
                    child: Semantics(
                      label: "Don't have an account?",
                      child: Text(
                        "Don't have an account?",
                        style: LogInStyles.instructionText(context),
                      ),
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
                  child: Semantics(
                    label: "Sign up",
                    button: true,
                    child: ElevatedButton(
                      style: LogInStyles.buttonStyle(context),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateAccount()));
                      },
                      child: Text(
                        'Sign Up',
                        style: LogInStyles.buttonText(context),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

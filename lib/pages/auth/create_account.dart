import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_milestone/pages/auth/login_page.dart';
import '../../services/firebase_service.dart';
import '../../pages/profile/create_profile_page.dart';

//styles for the page
abstract class ProfileStyles {
  //styles for boxes
  static BoxDecoration get boxDecoration => BoxDecoration(
    color: const Color.fromARGB(255, 255, 255, 255),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: const Color.fromARGB(255, 214, 212, 210),
      width: 1, 
    ));
    
  static ButtonStyle get buttonStyle => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFD461A6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: const BorderSide(
        color: Color.fromARGB(255, 214, 212, 210),
        width: 1,
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 14),
  );

  //text styles for headings in boxes
  static TextStyle get boxHeader => const TextStyle(
    fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255), fontSize: 30);

  //text styles for text above boxes
  static TextStyle get instructionText => const TextStyle(
    fontWeight: FontWeight.normal, color: Color(0xFF9F497D), fontSize: 16);

  static TextStyle get boxText => const TextStyle(
    fontWeight: FontWeight.w200, color: Color(0xFF1F1F1F), fontSize: 16);
  
  static TextStyle get buttonText => const TextStyle(
    fontWeight: FontWeight.w900, color: Color.fromARGB(255, 255, 255, 255), fontSize: 16);

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
  final TextEditingController _passwordController  = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0CA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(  
              padding: const EdgeInsets.only(top: 200),          
              child: Text(
                'Create FNGR Account', 
                style: ProfileStyles.boxHeader,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(right: 320, top: 40),              
              child: Text(
                'Email',
                style: ProfileStyles.instructionText,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Container(      
                decoration: ProfileStyles.boxDecoration,
                padding: ProfileStyles.boxPadding,
                width: ProfileStyles.containerWidth,         
                child: TextField(
                  controller: _emailController,
                  style: ProfileStyles.boxText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your email',
                    hintStyle: ProfileStyles.boxText,
                  ),
                ), 
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 290, top: 10),              
              child: Text(
                'Password',
                style: ProfileStyles.instructionText,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Container(
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
            ),

//add confirm password here?

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
                    activeColor: const Color(0xFFD461A6),
                    checkColor: Colors.white,
                  ),
                  const Text(
                    'Remember Me',
                    style: TextStyle(fontSize: 16, color: Color(0xFF1F1F1F), fontWeight: FontWeight.w200), 
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                padding: ProfileStyles.boxPadding,
                width: ProfileStyles.containerWidth,
                child: ElevatedButton(
                  style: ProfileStyles.buttonStyle,
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
                          'Sign Up',
                          style: ProfileStyles.buttonText,
                        ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),  
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Already have an account?',
                      style: TextStyle(color: Color(0xFF1F1F1F), fontWeight: FontWeight.w200),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.black,
                      thickness: 0.5,
                    ),
                  ),
                ],
              ),
            ), 

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                padding: ProfileStyles.boxPadding,
                width: ProfileStyles.containerWidth,
                child: ElevatedButton(
                  style: ProfileStyles.buttonStyle,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  child: Text(
                    'Login', 
                    style: ProfileStyles.buttonText,
                  ),
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}

import 'package:flutter/material.dart';
import '../../pages/auth/create_account.dart';
import '../../services/firebase_service.dart';
import '../../main.dart'; // Import NavMenu

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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController  = TextEditingController();
  bool isLoading = false;

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
        password:_passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavMenu()),
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Login to FNGR", 
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
                  _signIn();
              },
                child: Text(
                  "Login",
                  style: ProfileStyles.boxText,
                ),
              ),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccount()));
              },
                child: Text(
                  "Create account", 
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

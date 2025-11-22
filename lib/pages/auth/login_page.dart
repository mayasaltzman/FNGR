import 'package:flutter/material.dart';
import '../../pages/auth/create_account.dart';
import '../../services/firebase_service.dart';
import '../../main.dart'; // Import NavMenu

//styles for the page
abstract class ProfileStyles {
  //styles for boxes
  static BoxDecoration get boxDecoration => BoxDecoration(
    color: const Color.fromARGB(255, 255, 255, 255),
    borderRadius: BorderRadius.circular(15.0),
    border: Border.all(
      color: const Color.fromARGB(255, 214, 212, 210),
      width: 1, 
    ));

  //text styles for headings in boxes
  static TextStyle get boxHeader => const TextStyle(
    fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255), fontSize: 40);

  //text styles for text in boxes
  static TextStyle get instructionText => const TextStyle(
    fontWeight: FontWeight.normal, color: Color(0xFFAA4E85), fontSize: 16);

  static TextStyle get boxText => const TextStyle(
    fontWeight: FontWeight.w200, color: Color.fromARGB(255, 123, 123, 123), fontSize: 16);

  static const containerWidth = 375.0;

  static const boxPadding = EdgeInsets.symmetric(vertical: 1, horizontal: 4);
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
      backgroundColor: const Color.fromARGB(255, 253, 214, 186),
      //body: Center(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding( 
                padding: const EdgeInsets.only(top: 200),             
                child: Text(
                  "Login to FNGR", 
                  style: ProfileStyles.boxHeader,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 320.0, top: 50),              
                child: Text(
                  "Email",
                  style: ProfileStyles.instructionText,
                ),
              ),
                        
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 5),
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
                padding: const EdgeInsets.only(right: 290.0, top: 20),              
                child: Text(
                  "Password",
                  style: ProfileStyles.instructionText,
                ),
              ),

              Padding( 
                padding: const EdgeInsets.only(left: 10.0, top: 5),             
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
                      hintText: 'Enter your password',
                      hintStyle: ProfileStyles.boxText,
                    ),
                  ), 
                ),
              ),

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
          ),
        ),
      );
    //);
  }
}

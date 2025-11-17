import 'package:flutter/material.dart';
import 'package:test_milestone/pages/auth/create_account.dart';
import '../../services/firebase_service.dart';
import '../../main.dart'; // Import NavMenu
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
              const Text(
                "Login page baddies", 
                style: TextStyle(color: Colors.pink),
              ),
              
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                style: TextStyle(color:Colors.pink),
                decoration: InputDecoration(
                  labelText: 'Enter your username (email)',
                  labelStyle: TextStyle(color:Colors.pink),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                ),
              ), 
              
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                style: TextStyle(color:Colors.pink),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter your password',
                  labelStyle: TextStyle(color:Colors.pink),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                ),
              ), 
              
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : () {
                  _signIn();
              },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.pink),
                ),
              ),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccount()));
              },
                child: const Text(
                  "Create account", 
                  style: TextStyle(color: Colors.pink),
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}

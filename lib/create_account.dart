import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final FirebaseAuth fireAuth = FirebaseAuth.instance;
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  
  @override
  void initState() {
    super.initState();
  }

  Future<void> createUserAccount() async {
    try {
      UserCredential user = await fireAuth.createUserWithEmailAndPassword(
        email: username.text.trim(),
        password: password.text.trim(),
      );
      print("Registered as ${user.user?.email}");
    }on FirebaseAuthException catch (e) {
      print("Registration failed: ${e.code} - ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 300),
            const Text(
              "Create account baddies", 
              style: TextStyle(color: Colors.pink),
            ),
            
            const SizedBox(height: 30),
            TextField(
              controller: username,
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
              controller: password,
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
              onPressed: () {
                createUserAccount();
            },
              child: const Text(
                "Create Account",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        )
      ),
    );
  }
}

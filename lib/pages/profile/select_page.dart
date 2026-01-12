import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';

class SelectPage extends StatefulWidget {
  final String fieldType;
  const SelectPage({super.key, required this.fieldType});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  late FirebaseService _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          title: Text("Create Profile",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryFixed)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: BackButton(
            color: Theme.of(context).colorScheme.secondaryFixed,
          ),
        ),
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: _firebaseService.getProfileDropDownFields(widget.fieldType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var documentSnapshot = snapshot.data!.docs[index];

                Map<String, dynamic> data = documentSnapshot.data();

                return ListTile(
                  title: Text(data['label']),
                );
              },
            );
          },
        ));
  }
}

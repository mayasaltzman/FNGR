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
          title: Text(widget.fieldType,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondaryFixed)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading: BackButton(
            color: Theme.of(context).colorScheme.secondaryFixed,
          ),
        ),
        body: Column(children: [
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _firebaseService.getProfileDropDownFields(widget.fieldType),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                spacing: 10.0,
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: snapshot.data == null
                        ? []
                        : snapshot.data!.docs.map((documentSnapshot) {
                            final data = documentSnapshot.data();
                            return ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  side: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryFixed)),
                              child: Text(data['label'],
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryFixed)),
                            );
                          }).toList(),
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50)),
                      child: Text("Save")),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50)),
                      child: Text("Reset"))
                ],
              );
            },
          )
        ]));
  }
}

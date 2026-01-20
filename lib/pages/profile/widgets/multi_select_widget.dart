import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../profile/select_page.dart';
import '../../../services/firebase_service.dart';

class MultiSelect extends StatefulWidget {
  const MultiSelect({super.key});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, String> test = {
    'Sexuality': 'Lesbian, Queer',
    'Gender Identity': 'Woman'
  };

  //function taken from flutter docs
  Future<void> _navigateAndDisplaySelection(
      BuildContext context, String fieldType) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<String>(
          builder: (context) => SelectPage(fieldType: fieldType)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _firebaseService.getProfileFieldTypes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primaryFixed));
          } else {
            return Column(
              spacing: 15,
              children: snapshot.data == null
                  ? []
                  : snapshot.data!.docs.map((documentSnapshot) {
                      final data = documentSnapshot.data();
                      return ElevatedButton.icon(
                          icon: Icon(Icons.arrow_forward_ios,
                              color:
                                  Theme.of(context).colorScheme.primaryFixed),
                          label: Text(
                            test[data['field_type']] ?? data['field_type'],
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.primaryFixed),
                          ),
                          iconAlignment: IconAlignment.end,
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryFixed)),
                          onPressed: () {
                            _navigateAndDisplaySelection(
                                context, data['field_type']);
                          });
                    }).toList(),
            );
          }
        });
  }
}

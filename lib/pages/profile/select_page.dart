import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_milestone/pages/profile/create_profile_page.dart';
import '../../services/firebase_service.dart';

class SelectPage extends StatefulWidget {
  final String fieldType;
  const SelectPage({super.key, required this.fieldType});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  late FirebaseService _firebaseService;
  Set<String> selectedFields = {};
  Set<String> selectedLabels = {};
  final Map<String, ValueNotifier<bool>> _pressedNotifiers = {};
  String selectedString = "";

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();
  }

  ValueNotifier<bool> _getNotifier(String id) {
    return _pressedNotifiers.putIfAbsent(
      id, //need to put label here somehow
      () => ValueNotifier<bool>(false),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future:
                    _firebaseService.getProfileDropDownFields(widget.fieldType),
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
                                final id = documentSnapshot.id;
                                final label = data['label'];
                                final notifier = _getNotifier(id);

                                return ValueListenableBuilder<bool>(
                                    valueListenable: notifier,
                                    builder: (context, isPressed, child) {
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: isPressed
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primaryFixed
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryFixed)),
                                        child: Text(data['label'],
                                            style: TextStyle(
                                                color: isPressed
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .secondaryFixed
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primaryFixed)),
                                        onPressed: () {
                                          notifier.value = !notifier.value;
                                          if (!notifier.value) {
                                            selectedFields.remove(id);
                                            selectedLabels.remove(label);
                                          } else {
                                            selectedFields.add(id);
                                            selectedLabels.add(label);
                                          }
                                        },
                                      );
                                    });
                              }).toList(),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            selectedString = selectedLabels
                                .toString()
                                .replaceAll('{', '')
                                .replaceAll('}', '');
                            print(selectedString);

                            if (mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => CreateProfilePage()),
                                  (route) => false);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryFixed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                          child: const Text("Save")),
                      ElevatedButton(
                          onPressed: () {
                            for (final notifier in _pressedNotifiers.values) {
                              notifier.value = false;
                            }
                            selectedFields.clear();
                            selectedLabels.clear();
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                          child: Text("Reset",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryFixed)))
                    ],
                  );
                },
              )
            ])));
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_milestone/pages/profile/create_profile_page.dart';
import '../../services/firebase_service.dart';

class SelectPage extends StatefulWidget {
  final String fieldType;
  final Set<String> selectedFields;
  final Set<String> selectedLabels;
  const SelectPage(
      {super.key,
      required this.fieldType,
      required this.selectedFields,
      required this.selectedLabels});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  late FirebaseService _firebaseService;
  final Map<String, ValueNotifier<bool>> _pressedNotifiers = {};
  String selectedString = "";

  @override
  void initState() {
    super.initState();
    _firebaseService = FirebaseService();

    for (final field in widget.selectedFields) {
      _pressedNotifiers[field] = ValueNotifier<bool>(true);
    }
  }

  @override
  void dispose() {
    for (final notifier in _pressedNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  ValueNotifier<bool> _getNotifier(String id) {
    return _pressedNotifiers.putIfAbsent(
      id,
      () => ValueNotifier<bool>(false),
    );
  }

  Future showDialogBox(BuildContext context, String type) {
    String helpText = "";
    String title = "";

    if (type == "Sexuality") {
      title = "What is Sexuality";
      helpText =
          "Sexuality or sexual orientation is ones identity in relation to the genders they are typically attracted to or not attracted to.";
    } else if (type == "Gender Identity") {
      title = "What is Gender Identity";
      helpText =
          "Gender identity is the personal sense of one's own gender and is one's internal and individual sense of their gender.";
    } else if (type == "Pronouns") {
      title = "What are Pronouns";
      helpText =
          "Pronouns are how one refer to themself and other people. Pronouns can be related to gender identity and expression.";
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.primaryFixed)),
          content: SizedBox(
            height: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(helpText,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryFixed)),
              ],
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text('Close',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryFixed)),
            ),
          ],
        );
      },
    );
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
                  return Expanded(
                      child: Column(
                    spacing: 10.0,
                    children: [
                      TextButton(
                        onPressed: () {
                          showDialogBox(context, widget.fieldType);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primaryFixed,
                          textStyle: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 15),
                        ),
                        child: Text("What Does ${widget.fieldType} Mean"),
                      ),
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
                                            widget.selectedFields.remove(id);
                                            widget.selectedLabels.remove(label);
                                          } else {
                                            widget.selectedFields.add(id);
                                            widget.selectedLabels.add(label);
                                          }
                                        },
                                      );
                                    });
                              }).toList(),
                      ),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            selectedString = widget.selectedLabels
                                .toString()
                                .replaceAll('{', '')
                                .replaceAll('}', '');

                            Navigator.pop(context, (
                              selectedString,
                              widget.selectedFields,
                              widget.selectedLabels
                            ));
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
                            widget.selectedFields.clear();
                            widget.selectedLabels.clear();
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
                  ));
                },
              )
            ])));
  }
}

import 'package:flutter/material.dart';

//styles for profile page
abstract class ProfileStyles {
  static const formWidth = 375.0;
  static const textInputWidth = 250.0;

  static TextStyle inputHeader = const TextStyle(
      fontWeight: FontWeight.bold, color: Color(0xFFAA4E85), fontSize: 18);

  static final ButtonStyle button = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFD461A6),
    fixedSize: const Size(110, 50),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
}

class SingleSelectDropDown extends StatelessWidget {
  final String? value;
  final String label;
  final ValueChanged<String?> onChanged;

  const SingleSelectDropDown({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    late List<String> items;

    if (label == "Relationship Status") {
      items = [
        'single',
        'open relationship',
        'in a relationship',
      ];
    } else if (label == "Relationship Style") {
      items = [
        'monogamous',
        'polyamorous',
        'ethical non monagamy',
        'relationship anarchy',
        'swinging',
        'exploring'
      ];
    } else if (label == "Looking For") {
      items = [
        'hookups',
        'long term relationship',
        'short term relationship',
        'casual dating',
        'figuring it out'
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            child: Text(
          label,
          style: ProfileStyles.inputHeader,
        )),
        const SizedBox(width: 20),
        SizedBox(
          child: DropdownButton<String>(
            hint: Text("Select",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryFixed)),
            isExpanded: true,
            value: value,
            items: items
                .map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    ))
                .toList(),
            onChanged: onChanged,
            dropdownColor: Theme.of(context).colorScheme.primaryContainer,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primaryFixed,
                fontSize: 16),
            icon: Icon(Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primaryFixed),
            menuWidth: 280,
            elevation: 1,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

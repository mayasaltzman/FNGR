import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

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

class MultiSelectDropdown extends StatelessWidget {
  final MultiSelectController<String> controller;
  final String labelText;
  //final List<DropdownItem<String>> items;

  const MultiSelectDropdown({
    super.key,
    required this.controller,
    required this.labelText,
    //required this.items,
  });

  @override
  Widget build(BuildContext context) {
    late List<DropdownItem<String>> items;

    if (labelText == "Sexuality") {
      items = [
        DropdownItem(label: 'Aromantic', value: "Aromantic"),
        DropdownItem(label: 'Asexual', value: "Asexual"),
        DropdownItem(label: 'Bisexual', value: "Bisexual"),
        DropdownItem(label: 'Demisexual', value: "Demisexual"),
        DropdownItem(label: 'Gay', value: "Gay"),
        DropdownItem(label: 'Lesbian', value: "Lesbian"),
        DropdownItem(label: 'Other', value: "Other"),
        DropdownItem(label: 'Pansexual', value: "Pansexual"),
        DropdownItem(label: 'Polysexual', value: "Polysexual"),
        DropdownItem(label: 'Queer', value: "Queer"),
        DropdownItem(label: 'Sapphic', value: "Sapphic")
      ];
    } else if (labelText == "Gender Identity") {
      items = [
        DropdownItem(label: 'Agender', value: "Agender"),
        DropdownItem(label: 'Bigender', value: "Bigender"),
        DropdownItem(label: 'Genderfluid', value: "Genderfluid"),
        DropdownItem(label: 'Genderqueer', value: "Genderqueer"),
        DropdownItem(label: 'Intersex', value: "Intersex"),
        DropdownItem(label: 'Non-binary', value: "Non-binary"),
        DropdownItem(label: 'Pangender', value: "Pangender"),
        DropdownItem(label: 'Transgender', value: "Transgender"),
        DropdownItem(label: 'Trans Man', value: "Trans Man"),
        DropdownItem(label: 'Trans Woman', value: "Trans Woman"),
        DropdownItem(label: 'Trans Masculine', value: "Trans Masculine"),
        DropdownItem(label: 'Trans Feminine', value: "Trans Feminine"),
        DropdownItem(label: 'Two-Spirit', value: "Two-Spirit"),
        DropdownItem(label: 'Woman', value: "Woman")
      ];
    } else if (labelText == "Pronouns") {
      items = [
        DropdownItem(label: 'she/her', value: "she/her"),
        DropdownItem(label: 'they/them', value: "they/them"),
        DropdownItem(label: 'he/him', value: "he/him"),
        DropdownItem(label: 'ze/zir', value: "ze/zir"),
        DropdownItem(label: 'fae/faer', value: "fae/faer"),
        DropdownItem(label: 'ae/aer', value: "ae/aer"),
        DropdownItem(label: 'xe/xem', value: "xe/xem"),
        DropdownItem(label: 'it/its', value: "it/its"),
        DropdownItem(label: 'ask me', value: "ask me"),
      ];
    } else if (labelText == "Sexual Preferences") {
      items = [
        DropdownItem(label: 'top', value: "top"),
        DropdownItem(label: 'bottom', value: "bottom"),
        DropdownItem(label: 'switch', value: "switch"),
      ];
    } else if (labelText == "Gender Presentation") {
      items = [
        DropdownItem(label: 'androgynous', value: "androgynous"),
        DropdownItem(label: 'alien', value: "alien"),
        DropdownItem(label: 'chapstick', value: "chapstick"),
        DropdownItem(label: 'femme', value: "femme"),
        DropdownItem(label: 'futch', value: "futch"),
        DropdownItem(label: 'butch', value: "butch"),
        DropdownItem(label: 'lipstick', value: "lipstick"),
        DropdownItem(label: 'masc', value: "masc"),
        DropdownItem(label: 'stud', value: "stud"),
        DropdownItem(label: 'stemme', value: "stemme"),
      ];
    } else if (labelText == "Interests") {
      items = [
        DropdownItem(label: 'reading', value: "reading"),
        DropdownItem(label: 'outdoors', value: "outdoors"),
        DropdownItem(label: 'cooking', value: "cooking"),
        DropdownItem(label: 'emo femmes', value: "emo femmes"),
      ];
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(child: Text(labelText, style: ProfileStyles.inputHeader)),
      const SizedBox(width: 20),
      SizedBox(
          child: MultiDropdown(
        items: items,
        controller: controller,
        dropdownDecoration: DropdownDecoration(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer),
        dropdownItemDecoration: DropdownItemDecoration(
            textColor: Theme.of(context).colorScheme.primaryFixed,
            selectedBackgroundColor: Theme.of(context).colorScheme.primary,
            selectedTextColor: Theme.of(context).colorScheme.primaryFixed),
        fieldDecoration: FieldDecoration(
            showClearIcon: false,
            labelStyle:
                TextStyle(color: Theme.of(context).colorScheme.primaryFixed),
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primaryFixed,
                fontSize: 18),
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.tertiary),
                borderRadius: BorderRadius.circular(10)),
            suffixIcon: Icon(Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primaryFixed)),
        chipDecoration: ChipDecoration(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            labelStyle:
                TextStyle(color: Theme.of(context).colorScheme.primaryFixed),
            deleteIcon: Icon(Icons.close,
                color: Theme.of(context).colorScheme.primaryFixed, size: 15)),
      ))
    ]);
  }
}

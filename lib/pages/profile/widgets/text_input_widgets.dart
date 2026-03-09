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

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final String textType;

  const TextInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        child: Text(
          textType,
          style: ProfileStyles.inputHeader,
          softWrap: true,
        ),
      ),
      const SizedBox(width: 20),
      SizedBox(
          height: 50,
          child: TextFormField(
            controller: controller,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primaryFixed,
                fontSize: 16),
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primaryFixed),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primaryFixed,
                      width: 2),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary,
                //labelText: labelText,
                labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primaryFixed,
                    fontSize: 16)),
            validator: validator,
          ))
    ]);
  }
}

class TextInputFieldLong extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final String? bio;

  const TextInputFieldLong({
    super.key,
    required this.controller,
    this.validator,
    this.bio,
  });

  final int maxChars = 200;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("About me", style: ProfileStyles.inputHeader),
        SizedBox(
          width: 400,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final remaining = maxChars - value.text.length;

              return TextFormField(
                controller: controller,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 20,
                maxLength: maxChars,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryFixed,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    labelText: bio,
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primaryFixed,
                      fontSize: 16,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primaryFixed,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primaryFixed,
                        width: 2,
                      ),
                    ),
                    counterText: "$remaining characters remaining",
                    counterStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primaryFixed)),
              );
            },
          ),
        ),
        
      ],
    );
  }
}

class TextInputFieldBirthday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Your birthday: DD-MM-YYYY", style: ProfileStyles.inputHeader),
      Row(
        spacing: 10,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Day",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryFixed)),
              SizedBox(
                  width: 80,
                  height: 50,
                  child: TextFormField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryFixed,
                          fontSize: 16),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.primaryFixed),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary,
                                width: 2),
                          ),
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primaryFixed,
                              fontSize: 16))))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Month",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryFixed)),
              SizedBox(
                  width: 80,
                  height: 50,
                  child: TextFormField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryFixed,
                          fontSize: 16),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.primaryFixed),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary,
                                width: 2),
                          ),
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primaryFixed,
                              fontSize: 16))))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Year",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryFixed)),
              SizedBox(
                  width: 190,
                  height: 50,
                  child: TextFormField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryFixed,
                          fontSize: 16),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.primaryFixed),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.tertiary,
                                width: 2),
                          ),
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primaryFixed,
                              fontSize: 16))))
            ],
          ),
        ],
      ),
      Text("You cannot update your birthday later",
          style: TextStyle(color: Theme.of(context).colorScheme.primaryFixed))
    ]);
  }
}

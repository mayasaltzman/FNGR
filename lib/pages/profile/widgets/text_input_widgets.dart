import 'package:flutter/material.dart';
import '../create_profile_steps/styles/create_profile_styles.dart';

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
          style: ProfileStyles.inputHeader(context),
          softWrap: true,
        ),
      ),
      const SizedBox(width: 20),
      SizedBox(
          height: 50,
          child: TextFormField(
            controller: controller,
            style: ProfileStyles.inputText(context),
            decoration: ProfileStyles.inputDecoration(context).copyWith(
                hintText: labelText,
                hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primaryFixed)),
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
        Text("About me", style: ProfileStyles.inputHeader(context)),
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
                style: ProfileStyles.inputText(context),
                decoration: ProfileStyles.bioInputDecoration(
                        context, bio, remaining)
                    .copyWith(
                        hintText: "Tell us a bit about yourself!",
                        hintStyle: TextStyle(
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
      Text("Your birthday", style: ProfileStyles.inputHeader(context)),
      Row(
        spacing: 10,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Day", style: ProfileStyles.inputText(context)),
              SizedBox(
                  width: 80,
                  height: 50,
                  child: TextFormField(
                      style: ProfileStyles.inputText(context),
                      decoration: ProfileStyles.inputDecoration(context)
                          .copyWith(
                              hintText: "DD",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryFixed))))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Month", style: ProfileStyles.inputText(context)),
              SizedBox(
                  width: 80,
                  height: 50,
                  child: TextFormField(
                      style: ProfileStyles.inputText(context),
                      decoration: ProfileStyles.inputDecoration(context)
                          .copyWith(
                              hintText: "MM",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryFixed))))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Year", style: ProfileStyles.inputText(context)),
              SizedBox(
                  width: 190,
                  height: 50,
                  child: TextFormField(
                      style: ProfileStyles.inputText(context),
                      decoration: ProfileStyles.inputDecoration(context)
                          .copyWith(
                              hintText: "YYYY",
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryFixed))))
            ],
          ),
        ],
      ),
      Text("You cannot update your birthday later",
          style: ProfileStyles.inputText(context))
    ]);
  }
}

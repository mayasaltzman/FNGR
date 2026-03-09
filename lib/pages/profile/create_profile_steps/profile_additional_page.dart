import 'package:flutter/material.dart';
import '../widgets/multi_select_widget.dart';

class ProfileAdditionalPage extends StatelessWidget {
  ProfileAdditionalPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> fieldTypes = ['Sexual Preferences', 'Kink', 'Relationship Style', 'Relationship Status', 'Interests', 'Looking For', 'Gender Presentation'];
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                  "Almost there!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFAA4E85),
                      fontSize: 25)),
              MultiSelect(fieldTypes: fieldTypes),
              Spacer(),
              Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                      onPressed: () {},
                      label: Text("Skip"),
                      icon: Icon(Icons.arrow_forward_ios),
                      iconAlignment: IconAlignment.end,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFAA4E85),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      )))
            ]));
  }
}

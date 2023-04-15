import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key, required this.androidId, required this.phonenumber});
  final String? androidId;
  final String phonenumber;

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text("User Settings"),
          backgroundColor: Colors.red[800],
          ),
        body: Column(
          children: [
            SizedBox(
                height: 100,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("Your Account Settings",
                          style: TextStyle(
                              color: Colors.red[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 30)),
                    )
                  )
            ),
            const SizedBox(
              height: 30,
              child: Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ))
            ),
            SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:10),
                  child: Text("${widget.phonenumber}"),
                ))
            ),
            const SizedBox(
              height: 30,
              child: Text(
                "Registered Device ID",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ))
            ),
            SizedBox(
              height: 20,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:10),
                  child: Text("${widget.androidId}"),
                ))
            ),
          ],
        ));
  }
}

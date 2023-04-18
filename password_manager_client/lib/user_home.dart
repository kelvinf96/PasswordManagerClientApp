import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:password_manager_client/user_settings.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage(
      {super.key, required this.userphone, required this.androidId});
  final String userphone;
  final String? androidId;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Home Screen"),
        backgroundColor: Colors.red[800],
      ),
      body: Column(children: [
        SizedBox(
            height: 100,
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("Welcome back!",
                      style: TextStyle(
                          color: Colors.red[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 30)),
                ))),
        SizedBox(
            height: 50,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("This is the account home for ${widget.userphone}",
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    )),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              height: 80,
              width: 400,
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.3),
                  borderRadius: BorderRadius.circular(20)),
              child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Spacer(),
                      Icon(Icons.storage),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text("View all my passwords",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Spacer(),
                    ],
                  ))),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              height: 80,
              width: 400,
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.3),
                  borderRadius: BorderRadius.circular(20)),
              child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Spacer(),
                      Icon(Icons.search),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text("Find a password",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      Spacer(),
                    ],
                  ))),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserSettingsPage(
                          androidId: widget.androidId,
                          phonenumber: widget.userphone,
                        )),
              );
            },
            child: Container(
                height: 80,
                width: 400,
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.3),
                    borderRadius: BorderRadius.circular(20)),
                child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Spacer(),
                        Icon(Icons.settings),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text("Account Settings",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Spacer(),
                      ],
                    ))),
          ),
        ),
      ]),
    );
  }
}

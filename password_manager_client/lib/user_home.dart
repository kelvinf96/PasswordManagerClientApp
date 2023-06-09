import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:password_manager_client/add_password.dart';
import 'package:password_manager_client/user_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'all_passwords.dart';
import 'find_password.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage(
      {super.key, required this.androidId});
  
  final String? androidId;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
          
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)?.userNav ?? "Password Manager",
            ),
            backgroundColor: Colors.red[800],
          ),
          body: Column(children: [
            SizedBox(
                height: 100,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(AppLocalizations.of(context)?.welcomeMessage ?? "Welcome Back!",
                          style: TextStyle(
                              color: Colors.red[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 30)),
                    ))),
           
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddUserPasswordPage(
                              androidId: widget.androidId,
                              
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
                            Icon(Icons.add),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(AppLocalizations.of(context)?.addPassword ?? "Add a password",
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAllPasswordsPage(
                              androidId: widget.androidId,
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
                            Icon(Icons.storage),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                  AppLocalizations.of(context)?.viewAllPasswords ?? "View All Passwords",
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindPasswordPage(
                              androidId: widget.androidId,
                              
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
                            Icon(Icons.search),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child:
                                  Text(AppLocalizations.of(context)?.findPassoword ?? "Find a password",
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserSettingsPage(
                              androidId: widget.androidId,
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
                              child: Text(AppLocalizations.of(context)?.account ?? "Account Settings",
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
        ),
      ),
    );
  }
}

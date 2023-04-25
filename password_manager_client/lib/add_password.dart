import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:password_manager_client/user_home.dart';
import 'package:status_alert/status_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class AddUserPasswordPage extends StatefulWidget {
  const AddUserPasswordPage({super.key, required this.androidId});

  final androidId;

  @override
  State<AddUserPasswordPage> createState() => _AddUserPasswordPageState();
}

class _AddUserPasswordPageState extends State<AddUserPasswordPage> {
  TextEditingController _passwordNameController = TextEditingController();
  TextEditingController _passwordValueController = TextEditingController();

  void addPassword(var androidid, var passname, var passval) async {
    var uri = Uri.parse(
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/add?phoneId=$androidid&passwordName=$passname&passwordValue=$passval");

    final headers = {'Content-Type': 'application/json'};
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await post(
      uri,
      headers: headers,
      encoding: encoding,
    );

    if (response.statusCode == 200) {
      setState(() {
        StatusAlert.show(
          context,
          duration: const Duration(seconds: 2),
          subtitle: response.body,
          configuration: const IconConfiguration(
              icon: Icons.check_circle_rounded, color: Colors.green),
          maxWidth: 250,
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => UserHomePage(
                      androidId: widget.androidId,
                    )),
            (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)?.addPassword ?? "Add a password",
          ),
          backgroundColor: Colors.red[800],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 80,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                    AppLocalizations.of(context)?.addPasswordMessage ??
                        "Let's add a new password",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                  height: 80,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(50)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text("1",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                            child: Text(
                                AppLocalizations.of(context)?.addPasswordName ??
                                    "What is the password for?",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ))),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _passwordNameController,
                  )),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                  height: 80,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(50)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text("2",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                            child: Text(
                                AppLocalizations.of(context)
                                        ?.addPasswordValue ??
                                    "What is the password?",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ))),
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _passwordValueController,
                  )),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // some validation here first
                addPassword(
                  widget.androidId,
                  _passwordNameController.text.trim(),
                  _passwordValueController.text.trim()
                );
              },
              child: Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.green[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          AppLocalizations.of(context)?.submitButton ??
                              "Submit",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )))),
            )
          ],
        ));
  }
}

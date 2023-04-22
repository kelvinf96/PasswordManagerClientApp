// ignore_for_file: use_build_context_synchronously, prefer_final_fields, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:password_manager_client/user_home.dart';
import 'package:status_alert/status_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage(
      {super.key, required this.androidId, required this.phonenum});
  final androidId;
  final phonenum;

  @override
  State<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  TextEditingController _passwordName = TextEditingController();
  TextEditingController _newpasswordName = TextEditingController();
  late var currentPasswordName;
  bool passwordSearched = false;
  List<dynamic> allPasswords = [];
  late String errorMessage = AppLocalizations.of(context)!.searchPasswords;

  void findPassword() async {
    var toFind = _passwordName.text.trim();
    var url =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/find/name?phoneId=${widget.androidId}&passwordName=$toFind";

    var uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    var password = {
      'passwordName': _passwordName.text.trim(),
      'passwordValue': body,
    };

    setState(() {
      if (body.toString() == "$toFind not found") {
        errorMessage = "No password found for $toFind";
        passwordSearched = false;
      } else {
        passwordSearched = true;
        allPasswords = [password];
      }
    });
  }

  

  void deletePassword() async {
    var toDelete = _passwordName.text.trim();
    var url =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/remove/?phoneId=${widget.androidId}&passwordName=$toDelete";
    var uri = Uri.parse(url);

    final headers = {'Content-Type': 'application/json'};
    final encoding = Encoding.getByName('utf-8');

    Response response = await delete(
      uri,
      headers: headers,
      encoding: encoding,
    );

    setState(() {
      if (response.statusCode == 200) {
        StatusAlert.show(
          context,
          duration: const Duration(seconds: 2),
          subtitle: response.body,
          configuration: const IconConfiguration(
              icon: Icons.remove_circle_outline, color: Colors.red),
          maxWidth: 250,
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => UserHomePage(
                      androidId: widget.androidId,
                      userphone: widget.phonenum,
                    )),
            (route) => false);
      } else
        (print(response.body));
    });
  }

  void updatePasswordName() async {
    var updateWith = _passwordName.text.trim();
    var url =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/edit/name?phoneId=${widget.androidId}&passwordName=$currentPasswordName&newPasswordName=$updateWith";
    var uri = Uri.parse(url);

    final headers = {'Content-Type': 'application/json'};
    final encoding = Encoding.getByName('utf-8');

    Response response = await put(
      uri,
      headers: headers,
      encoding: encoding,
    );

    setState(() {
      if (response.statusCode == 200) {
        StatusAlert.show(
          context,
          duration: const Duration(seconds: 2),
          subtitle: response.body,
          configuration: const IconConfiguration(
              icon: Icons.save_as_rounded, color: Colors.green),
          maxWidth: 250,
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => UserHomePage(
                      androidId: widget.androidId,
                      userphone: widget.phonenum,
                    )),
            (route) => false);
      } else
        (print(response.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.findPassoword),
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
                      child: Text(AppLocalizations.of(context)!.searchPasswords,
                          style: TextStyle(
                            color: Colors.red[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                    ))),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 5),
              child: SizedBox(
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      AppLocalizations.of(context)!.passwordNameTag,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: TextField(
                          controller: _passwordName,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Netflix...Facebook"),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        findPassword();
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            color: Colors.green.withOpacity(.4),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Icon(Icons.arrow_forward_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Column(children: [
              !passwordSearched
                  ? SizedBox(
                      height: 300,
                      child: Text(errorMessage,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)))
                  : SizedBox(
                      height: 300,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: allPasswords.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  height: 50,
                                  child: Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                          allPasswords[index]['passwordName']),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        currentPasswordName =
                                            _passwordName.text.trim();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: TextFormField(
                                                  controller: _passwordName,
                                                  decoration: const InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey)))),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                      child: Row(
                                                    children: [
                                                      Text(
                                                          '${allPasswords[index]['passwordValue']}'),
                                                      Spacer(),
                                                      IconButton(
                                                        onPressed: () async {
                                                          await Clipboard.setData(
                                                              ClipboardData(
                                                                  text: allPasswords[
                                                                          index]
                                                                      [
                                                                      'passwordValue']));
                                                          Navigator.of(context)
                                                              .pop();
                                                          StatusAlert.show(
                                                            context,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 2),
                                                            subtitle:
                                                                "Password for ${allPasswords[index]['passwordName']} copied to clipboard",
                                                            configuration:
                                                                const IconConfiguration(
                                                                    icon: Icons
                                                                        .copy_rounded,
                                                                    color: Colors
                                                                        .green),
                                                            maxWidth: 250,
                                                          );
                                                        },
                                                        icon: const Icon(
                                                            Icons.copy),
                                                      ),
                                                    ],
                                                  )),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('OK'),
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                          onTap: () {
                                                            updatePasswordName();
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .save_as_rounded,
                                                              color: Colors
                                                                  .green)),
                                                      Spacer(),
                                                      GestureDetector(
                                                          onTap: () {
                                                            deletePassword();
                                                          },
                                                          child: const Icon(
                                                              Icons
                                                                  .delete_rounded,
                                                              color:
                                                                  Colors.red)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.remove_red_eye),
                                      ),
                                    )
                                  ])),
                            );
                          }),
                    ),
            ]),
          ],
        ));
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:status_alert/status_alert.dart';
import 'package:password_manager_client/user_home.dart';

class ViewAllPasswordsPage extends StatefulWidget {
  const ViewAllPasswordsPage({Key? key, required this.androidId})
      : super(key: key);

  final androidId;

  @override
  State<ViewAllPasswordsPage> createState() => _ViewAllPasswordsPageState();
}

class _ViewAllPasswordsPageState extends State<ViewAllPasswordsPage> {
  TextEditingController _passwordName = TextEditingController();
  TextEditingController _newpasswordName = TextEditingController();
  bool fetched = false;
  List<dynamic> allPasswords = [];
  String passwordCount = '';
  late var currentPasswordName;

  void updatePasswordName(int index, String newPasswordName) async {
    String oldPasswordName = allPasswords[index]['passwordName'];
    var url =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/edit/name?phoneId=${widget.androidId}&passwordName=$oldPasswordName&newPasswordName=$newPasswordName";
    var uri = Uri.parse(url);

    final headers = {'Content-Type': 'application/json'};
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http.put(
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
        Navigator.of(context).pop();
        fetchAllPasswords();
      } else
        (print(response.body));
    });
  }

  void deletePassword(int index) async {
    var toDelete = allPasswords[index]['passwordName'];
    var url =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/remove/?phoneId=${widget.androidId}&passwordName=$toDelete";
    var uri = Uri.parse(url);

    final headers = {'Content-Type': 'application/json'};
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http.delete(
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
        Navigator.of(context).pop();
        fetchAllPasswords();
      } else
        (print(response.body));
    });
  }

  void fetchAllPasswords() async {
    var url =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/find/all?phoneId=";

    url = url + widget.androidId;
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response);
    final body = response.body;

    final json = jsonDecode(body);
    print(json);

    setState(() {
      allPasswords = json?.cast<Map<String, dynamic>>()?.toList() ?? [];
      allPasswords
          .sort((a, b) => a['passwordName'].compareTo(b['passwordName']));
      fetched = true;
    });
  }

  void fetchAllPasswordsCount() async {
    var url =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/count?phoneId=";

    url = url + widget.androidId;
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    final count = response.body;

    setState(() {
      passwordCount = count;
      fetched = true;
    });
  }

  void deleteAllPasswords() async {
    var url =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/remove/all?phoneId=";

    url = url + widget.androidId;
    var uri = Uri.parse(url);
    final response = await http.delete(uri);

    setState(() {
      allPasswords = [];
    });

    // Show response message in an alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete All Passwords?'),
          content: Text(response.body),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void viewPassword(int index) {
    // Show the password value in an alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(allPasswords[index]['passwordName']),
          content: Text(allPasswords[index]['passwordValue']),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAllPasswords();
    fetchAllPasswordsCount();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)?.viewAllPasswords ?? "View all passwords",
            ),
            backgroundColor: Colors.red[800],
          ),
          body: !fetched
              ? const CircularProgressIndicator()
              : ListView.builder(
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
                              child: Text(allPasswords[index]['passwordName']),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                currentPasswordName =
                                    allPasswords[index]['passwordName'];
                                _newpasswordName.text = currentPasswordName;
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: TextFormField(
                                        controller: _newpasswordName,
                                        decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.grey),
                                          ),
                                        ),
                                      ),
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
                                                        text:
                                                            '${allPasswords[index]['passwordValue']}',
                                                      ),
                                                    );
                                                    StatusAlert.show(
                                                      context,
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      subtitle:
                                                          "Password for ${allPasswords[index]['passwordName']} copied to clipboard",
                                                      configuration:
                                                          const IconConfiguration(
                                                              icon: Icons
                                                                  .copy_rounded,
                                                              color: Colors.green),
                                                      maxWidth: 250,
                                                    );
                                                  },
                                                  icon: const Icon(Icons.copy),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'),
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                  onTap: () {
                                                    updatePasswordName(
                                                      index,
                                                      _newpasswordName.text.trim(),
                                                    );
                                                  },
                                                  child: Icon(Icons.save_as_rounded,
                                                      color: Colors.green)),
                                              Spacer(),
                                              GestureDetector(
                                                  onTap: () {
                                                    deletePassword(index);
                                                  },
                                                  child: const Icon(
                                                      Icons.delete_rounded,
                                                      color: Colors.red)),
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
          floatingActionButton: allPasswords.length > 0
              ? FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete All Passwords'),
                          content: const Text(
                              'Are you sure you want to delete all your passwords? This cannot be undone!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteAllPasswords();
                                },
                                child: const Text(
                                  'DELETE ALL',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  tooltip: 'Delete All Passwords',
                  child: const Icon(Icons.delete),
                )
              : null,
        ),
      ),
    );
  }
}

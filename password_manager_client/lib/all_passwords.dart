import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ViewAllPasswordsPage extends StatefulWidget {
  const ViewAllPasswordsPage({super.key, required this.androidId});
  final androidId;

  @override
  State<ViewAllPasswordsPage> createState() => _ViewAllPasswordsPageState();
}

class _ViewAllPasswordsPageState extends State<ViewAllPasswordsPage> {
  bool fetched = false;
  List<dynamic> allPasswords = [];

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
      allPasswords = json ?? '';
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

  @override
  void initState() {
    super.initState();
    fetchAllPasswords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("View All Passwords"),
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
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.remove_red_eye),
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
    );
  }
}

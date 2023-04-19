import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key, required this.androidId});
  final androidId;

  @override
  State<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  TextEditingController _passwordName = TextEditingController();
  bool passwordSearched = false;
  late String _passwordValue;
  String errorMessage = "Your password will show here";

  void findPassword() async {
    var toFind = _passwordName.text.trim();
    var url =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/find/name?phoneId=${widget.androidId}&passwordName=${toFind}";

    var uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;

    

    setState(() {
      if (body.toString() == "${toFind} not found") {
      errorMessage = "No password found for ${toFind}";
      passwordSearched = false;
    } else {
      passwordSearched = true;
      _passwordValue = body.toString();
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("Find a password"),
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
                      child: Text("Search your passwords",
                          style: TextStyle(
                            color: Colors.red[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          )),
                    ))),
            const Padding(
              padding: EdgeInsets.only(left: 10, bottom: 5),
              child: SizedBox(
                  height: 30,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        "Enter the password name"),
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
            !passwordSearched
                ? SizedBox(
                    height: 300,
                    child: Text(errorMessage,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)))
                : SizedBox(
                    height: 300,
                    child:
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, bottom: 10),
                                child: Text(
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  "Heres your password for ${_passwordName.text.trim()}"),
                              )),
                            Text(_passwordValue),
                          ],
                        ),
                  ),
          ],
        ));
  }
}

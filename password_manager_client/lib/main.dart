import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:password_manager_client/local_provider.dart';
import 'package:password_manager_client/user_home.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:http/http.dart' as http;
import 'package:status_alert/status_alert.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:password_manager_client/local_provider.dart';
import 'package:provider/provider.dart';

import 'l10n/l10n.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        {
          final provider = Provider.of<LocaleProvider>(context);
          return MaterialApp(
            supportedLocales: L10n.all,
            // locale: provider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            title: 'Password Manager',
            home: MyHomePage(title: 'Password Manager'),
          );
        }
      });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _userphone = TextEditingController();
  late String _androidId;

  // function to get the android id of phone
  void getInfo() async {
    String? result = await PlatformDeviceId.getDeviceId;

    // Update ID
    setState(() {
      print(result);
      _androidId = result ?? "";
    });
  }

  void userLogin() async {
    bool account = false;
    print("Running...");
    String? base =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Users/find?phoneID=";

    base = base + _androidId;
    var uri = Uri.parse(base);

    final response = await http.get(uri);
    final body = response.body;
    var json;

    if (body == "No user found with that phone") {
      account = false;
    } else {
      json = jsonDecode(body);
      print(json);
      account = true;
    }

    setState(() {
      if (!account) {
        print("No account.");
        showDialog(
            context: context,
            builder: ((context) => AlertDialog(
                title: Text("New Account?"),
                content: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text("Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        createUser();
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text("Create",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ))),
                      ),
                    ),
                  ],
                ))));
      } else {
        StatusAlert.show(
          context,
          duration: const Duration(seconds: 2),
          subtitle: "Login Successful!",
          configuration: const IconConfiguration(
              icon: Icons.check_circle_rounded, color: Colors.green),
          maxWidth: 250,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserHomePage(
                    androidId: _androidId,
                    
                  )),
        );
      }
    });
  }

  void createUser() async {
    bool created = false;

    String? base =
        "https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Users/add?phoneID=";

    base = base + _androidId;
    var uri = Uri.parse(base);

    final response = await http.post(uri);
    final body = response.body;
    print(body);

    if (body != "User added") {
      created = false;
    } else {
      created = true;
    }

    print(created);

    setState(() {
      if (created) {
        StatusAlert.show(
          context,
          duration: const Duration(seconds: 2),
          subtitle: "New User Created!",
          configuration: const IconConfiguration(
              icon: Icons.check_circle_rounded, color: Colors.green),
          maxWidth: 250,
        );
        userLogin();
      } else {
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(title: Text("Error creating account.")));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
    _userphone.addListener(() {
      final String text = _userphone.text.toLowerCase();
      _userphone.value = _userphone.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _userphone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.red[800],
            title: Align(
                alignment: Alignment.center,
                child: Text(AppLocalizations.of(context)?.passwordManagerTitle ?? "Password Manager")),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // DropdownButton(
                //     icon: Container(width: 10),
                //     items: L10n.all.map((locale) {
                //       final flag = L10n.getFlag(locale.languageCode);
      
                //       return DropdownMenuItem(
                //         child: Center(
                //           child: Text(
                //             flag,
                //             style: TextStyle(fontSize: 24),
                //           )
                //         ),
                      
                //       )
                //     }), onChanged: (value) {  },),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    height: 50,
                    child: Text(
                      AppLocalizations.of(context)?.appWelcomeMessage ?? "Welcome to Password Manager",
                      style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 30,
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 10),
                //       child: Text(
                //         AppLocalizations.of(context)!.enterNumberMessage,
                //         style: TextStyle(
                //           color: Colors.grey[800],
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 80,
                //   child: Padding(
                //     padding: EdgeInsets.all(10),
                //     child: TextField(
                //       controller: _userphone,
                //       keyboardType: TextInputType.number,
                //       decoration: const InputDecoration(
                //         border: OutlineInputBorder(),
                //         hintText: "089615...",
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context)?.correctDeviceMessage ?? "Ensure you are on the correct device",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      userLogin();
                    },
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(20)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            AppLocalizations.of(context)?.homeProceed ?? "Proceed",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key, required this.androidId});
  final String? androidId;
  

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.userSettingsTitle,),
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
                      child: Text(AppLocalizations.of(context)!.yourSettings,
                          style: TextStyle(
                              color: Colors.red[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 30)),
                    )
                  )
            ),
            
            SizedBox(
              height: 30,
              child: Text(
               AppLocalizations.of(context)!.deviceId,
                style: const TextStyle(
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

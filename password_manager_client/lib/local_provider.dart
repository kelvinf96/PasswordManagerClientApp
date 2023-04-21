import 'package:flutter/material.dart';
import 'package:password_manager_client/l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  late Locale _locale;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  @override
  void initState() {
    _locale = L10n.all[0];
  }
}

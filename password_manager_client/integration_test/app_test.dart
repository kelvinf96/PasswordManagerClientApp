// ignore_for_file: use_function_type_syntax_for_parameters

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:integration_test/common.dart';
import 'package:integration_test/integration_test.dart';
import 'package:password_manager_client/add_password.dart' as addpass;
import 'package:password_manager_client/all_passwords.dart';
import 'package:password_manager_client/find_password.dart';
import 'package:password_manager_client/l10n/l10n.dart';
import 'package:password_manager_client/local_provider.dart';
import 'package:password_manager_client/main.dart' as app;
import 'package:password_manager_client/main.dart';
import 'package:password_manager_client/user_home.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Widget createWidgetUnderTest() {
    return MaterialApp(
      supportedLocales: L10n.all,
      // locale: provider.locale,
      title: 'Password Manager',
      home: const MyHomePage(
        title: 'Password Manager',
      ),
    );
  }

  ;

  group('end to end test', () {
    testWidgets("login screen message displayed", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("Welcome to Password Manager"), findsOneWidget);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
    });

    testWidgets("User Home welcome message shown", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: Scaffold(
                // scaffold contents here
                ),
          ),
        ),
      );
      await tester
          .pumpWidget(const UserHomePage(androidId: "1bca94cb322e486c"));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("Welcome Back!"), findsOneWidget);
    });

    testWidgets("User Home buttons available", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: Scaffold(
                // scaffold contents here
                ),
          ),
        ),
      );
      await tester
          .pumpWidget(const UserHomePage(androidId: "1bca94cb322e486c"));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("Add a password"), findsOneWidget);
      expect(find.text("View All Passwords"), findsOneWidget);
      expect(find.text("Find a password"), findsOneWidget);
      expect(find.text("Account Settings"), findsOneWidget);
    });

    testWidgets("View all passwords page loading", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pumpWidget(
          const ViewAllPasswordsPage(androidId: "1bca94cb322e486c"));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("View all passwords"), findsOneWidget);
    });

    testWidgets("Try find a non existing password", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpWidget(createWidgetUnderTest());

      await tester
          .pumpWidget(const FindPasswordPage(androidId: "1bca94cb322e486c"));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("Search your passwords"), findsOneWidget);
      await tester.enterText(find.byType(TextField), "Not a real password");
      await Future.delayed(const Duration(seconds: 10));
      await tester.tap(find.byType(Container).at(1));
      await Future.delayed(const Duration(seconds: 10));
      expect(find.text("Password will show here"), findsOneWidget);
    });

    testWidgets(
        'Ensure we can access Add password page from home and add a password',
        (WidgetTester tester) async {
      // Build your widget tree
      await tester.pumpWidget(const MaterialApp(
        home: UserHomePage(
          androidId: "1bca94cb322e486c",
        ),
      ));

      // Find and click on button for add password page
      await tester.tap(find.byType(GestureDetector).at(0));
      await tester.pumpAndSettle();

      // Verify that the add password page is displayed
      expect(find.text("Let's add a new password"), findsOneWidget);

      // Fill in the text fields and tap the submit button
      await tester.enterText(find.byType(TextField).at(0), "Nike");
      await tester.enterText(find.byType(TextField).at(1), "Shews1");
      await tester.pumpAndSettle();

      // Make a mock HTTP POST request to your API endpoint, passing in above vars
      final response = await http.post(Uri.parse(
          'https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/add?phoneId=1bca94cb322e486c&passwordName=Nike&passwordValue=Shews1'));

      // Check that the response status code is 200 OK
      expect(response.statusCode, 200);
    });

    testWidgets('View all passwords and ensure new password is available',
        (WidgetTester tester) async {
      // Build your widget tree
      await tester.pumpWidget(const MaterialApp(
        home: UserHomePage(
          androidId: "1bca94cb322e486c",
        ),
      ));

      // Find and click on button for view all password page
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 20));

      // ensure password created above is shown
      expect(find.text("Nike"), findsOneWidget);
    });

    testWidgets('Edit Nike password name', (WidgetTester tester) async {
      // Build your widget tree
      await tester.pumpWidget(const MaterialApp(
        home: UserHomePage(
          androidId: "1bca94cb322e486c",
        ),
      ));

      // Find and click on button for view all password page
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 20));

      // confirm we are on the correct page & Nike password is there
      expect(find.text("Nike"), findsOneWidget);

      // mock api call to update the name on Nike password
      final response = await http.put(Uri.parse(
          'https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/edit/name?phoneId=1bca94cb322e486c&passwordName=Nike&newPasswordName=Nike2'));
      await tester.pumpAndSettle();
      expect(response.statusCode, 200);

      // redirect home and back into view all passwords
      await tester.pumpWidget(const MaterialApp(
        home: UserHomePage(
          androidId: "1bca94cb322e486c",
        ),
      ));
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), "Nike2");
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 20));

      
    });

    testWidgets('Confirm Nike password changed to Nike2', (WidgetTester tester) async {
      // Build your widget tree
      await tester.pumpWidget(const MaterialApp(
        home: UserHomePage(
          androidId: "1bca94cb322e486c",
        ),
      ));

      // Find and click on button for view all password page
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 20));

      // confirm we are on the correct page & Nike password is there
      expect(find.text("Nike2"), findsOneWidget);
    });

    testWidgets('Delete Nike2 password', (WidgetTester tester) async {
      // Build your widget tree
      await tester.pumpWidget(const MaterialApp(
        home: UserHomePage(
          androidId: "1bca94cb322e486c",
        ),
      ));

      // Find and click on button for view all password page
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 20));

      // confirm we are on the correct page & Nike password is there
      expect(find.text("Nike2"), findsOneWidget);

      // run mock api call to delete password
      final response = await http.delete(Uri.parse(
          'https://passwordmanagerapiead.azurewebsites.net/PasswordManager/api/Password/remove?phoneId=1bca94cb322e486c&passwordName=Nike2'));
      await tester.pumpAndSettle();
      expect(response.statusCode, 200);


      // open password dialog
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 20));
    });

    testWidgets('Confirm Nike2 password was removed', (WidgetTester tester) async {
      // Build your widget tree
      await tester.pumpWidget(const MaterialApp(
        home: UserHomePage(
          androidId: "1bca94cb322e486c",
        ),
      ));

      // Find and click on button for view all password page
      await tester.tap(find.byType(GestureDetector).at(1));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 20));

      // confirm we are on the correct page & Nike password is there
      expect(find.text("Nike2"), findsNothing);
    });
  });
}

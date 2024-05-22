
import 'package:app/homescreen.dart';
import 'package:app/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/signupscreen.dart';

import 'model/user.dart';
import "firebase_options.dart";

import 'package:firebase_core/firebase_core.dart';
import "package:firebase_analytics/firebase_analytics.dart";

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Attendance App',
      // themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Colors.black54,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const KeyboardVisibilityProvider(child: AuthCheck()),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedpref;

  @override
  void initState() {
    super.initState();
    _getCurrentuser();
  }

  void _getCurrentuser() async {
    sharedpref = await SharedPreferences.getInstance();
    try {
      // Dummy logic: Set a dummy user ID
      User.employeeId = 'dummy_user_id';
      setState(() {
        userAvailable = true;
      });
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? const SignupScreen() : const LoginScreen();
  }
}

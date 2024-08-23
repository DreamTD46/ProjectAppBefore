import 'package:ProjectAppBefore/screens/facebook_login.dart';
import 'package:ProjectAppBefore/screens/google_login.dart';
import 'package:ProjectAppBefore/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/pin_input_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/security_screen.dart';
import 'services/mock_auth_service.dart';
import 'screens/new_activity_screen.dart' as new_activity;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MockAuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifePlanner',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFB0BEC5), // Light Grey Blue
          secondary: Color(0xFFCFD8DC), // Very Light Blue
          background: Colors.white,
          surface: Color(0xFFECEFF1), // Very Light Grey
        ),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF263238), // Dark Grey Blue
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Color(0xFF455A64), fontSize: 16), // Grey Blue
          bodyMedium: TextStyle(color: Color(0xFF607D8B), fontSize: 14), // Light Grey Blue
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFFB0BEC5), // Light Grey Blue
          elevation: 1,
          iconTheme: IconThemeData(color: Color(0xFF263238)), // Dark Grey Blue
          titleTextStyle: TextStyle(
            color: Color(0xFF263238), // Dark Grey Blue
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: const Color(0xFFB0BEC5), // Light Grey Blue
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFCFD8DC), // Very Light Blue
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFECEFF1), // Very Light Grey
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFB0BEC5), width: 2), // Light Grey Blue
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
      home: HomeScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/Register': (context) => Register(),
        '/Googlelogin': (context) => GoogleLogin(),
        '/FacebookLogin': (context) => FacebookLogin(),
        '/pin': (context) => PinInputScreen(),
        '/auth': (context) => AuthScreen(),
        '/new_activity': (context) => new_activity.NewActivityScreen(
              onAdd: (name, note, dateTime) {},
            ),
        '/activities': (context) => ActivitiesScreen(),
        '/settings': (context) => SettingsScreen(), // เพิ่มนี้
        '/security': (context) => SecurityScreen(), // เพิ่มนี้
      },
    );
  }
}
import 'package:flutter/material.dart';

class MockAuthService extends ChangeNotifier {
  User? user;

  Future<void> signInWithGoogle() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    user = User(email: 'testuser@gmail.com'); // Mock user data
    notifyListeners();
  }

  Future<void> signInWithFacebook() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    user = User(email: 'testuser@facebook.com'); // Mock user data
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    user = User(email: email); // Mock user data
    notifyListeners();
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    user = null; // Clear mock user data
    notifyListeners();
  }
}

class User {
  final String email;
  User({required this.email});
}

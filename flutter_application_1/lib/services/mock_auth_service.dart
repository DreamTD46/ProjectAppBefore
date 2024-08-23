import 'package:flutter/material.dart';

class MockAuthService with ChangeNotifier {
  // Simulate a user
  User? user;

  // Simulate Google sign-in
  Future<void> signInWithGoogle() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    user = User(email: 'testuser@gmail.com'); // Mock user data
    notifyListeners();
  }

  // Simulate Facebook sign-in
  Future<void> signInWithFacebook() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    user = User(email: 'testuser@facebook.com'); // Mock user data
    notifyListeners();
  }

  // Simulate email/password sign-in
  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    user = User(email: email); // Mock user data
    notifyListeners();
  }

  // Simulate sign-out
  Future<void> signOut() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    user = null; // Clear mock user data
    notifyListeners();
  }
}

// Mock user class
class User {
  final String email;
  User({required this.email});
}

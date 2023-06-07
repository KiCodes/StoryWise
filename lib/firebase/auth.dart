import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Method to handle user login
  Future<void> login(String email, String password) async {
    // Perform login using Firebase Authentication
    // Set the value of _user to the logged-in user
    // Notify listeners of the state change
  }

  // Method to handle user logout
  Future<void> logout() async {
    // Perform logout using Firebase Authentication
    // Set the value of _user to null
    // Notify listeners of the state change
  }
}

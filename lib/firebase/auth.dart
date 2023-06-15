import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages/login.dart';
import '../pages/moodPage.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Method to handle user login
  Future<void> login(TextEditingController _usernameEmailController, TextEditingController _passwordController, context) async {
    String email = _usernameEmailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID of the signed-in user
      String userId = userCredential.user!.uid;

      // Retrieve the user document from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('_users').doc(userId).get();

      // Check if the user document exists and perform authorization checks
      if (userSnapshot.exists) {
        // Update the _user variable with the logged-in user
        _user = userCredential.user;

        // User is authorized, navigate to the desired page
        Fluttertoast.showToast(
          msg: 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
        );

        // User is authorized, navigate to the desired page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MoodPage()),
        );
      } else {
        // User document does not exist, show an error message or handle it accordingly
        Fluttertoast.showToast(
          msg: 'Invalid credentials',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
        );
      }
    } catch (error) {
      // An error occurred during login
      Fluttertoast.showToast(
        msg: 'Failed to login: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey,
      );
    }

    notifyListeners();
  }

  // Method to handle user logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      _user = null;
      Fluttertoast.showToast(
        msg: 'Logged out successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to logout: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey,
      );
    }

    notifyListeners();
  }

  Future<void> register(TextEditingController _usernameController, TextEditingController _passwordController, TextEditingController _emailController, TextEditingController _fullnameController, context) async {
    // Get the values from the text controllers
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;
    String fullname = _fullnameController.text;

    try {
      // Create a new user with email and password
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user ID of the created user
      String userId = userCredential.user!.uid;

      // Create a new document reference in the "_users" collection using the user ID
      DocumentReference userRef =
      FirebaseFirestore.instance.collection('_users').doc(userId);

      // Set the data for the user document
      userRef.set({
        'username': username,
        'email': email,
        'fullname': fullname,
      });

      // User registration successful
      print('User registered successfully!');

      // Show pop-up notification
      Fluttertoast.showToast(
        msg: 'User signed up successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey
      );

      // Delay for a few seconds
      await Future.delayed(Duration(seconds: 2));

      // You can navigate to another page or perform any other action here

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),));


        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _fullnameController.clear();

    } catch (error) {
      if (error is FirebaseAuthException) {
        // Show toast message for email already existing
        if (error.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'Email already exists',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
          );
        }else{
          // An error occurred during user registration
          print('Failed to register user: $error');
        }
      } else {
        // An error occurred during user registration
        print('Failed to register user: $error');
      }
    }
  }

}

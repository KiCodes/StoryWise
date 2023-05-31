import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storywise/pages/moodPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'constants/transitionBuilder.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => MyAppState(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionsBuilder(),
            TargetPlatform.iOS: CustomPageTransitionsBuilder(),
          },
        ),
        primarySwatch: Colors.blue,
      ),
      home: MoodPage(),
    );
  }
}

class MyAppState extends ChangeNotifier{
  bool _happyStories = false;

  bool get happyStories => _happyStories;


  bool _randomStories = false;
  bool _sadStories = false;
  bool _darkStories = false;

  bool get randomStories => _randomStories;

  bool get sadStories => _sadStories;

  bool get darkStories => _darkStories;


  void setHappyStories(bool value) {
    _happyStories = value;
    notifyListeners();
  }

  void setSadStories(bool value) {
    _sadStories = value;
    notifyListeners();
  }

  void setRandomStories(bool value) {
    _randomStories = value;
    notifyListeners();
  }

  void setDarkStories(bool value) {
    _darkStories = value;
    notifyListeners();
  }
}


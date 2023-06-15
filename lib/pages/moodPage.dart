import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storywise/main.dart';
import 'package:storywise/pages/login.dart';
import 'package:storywise/pages/profilePage.dart';
import 'package:storywise/pages/storyPage.dart';
import 'package:provider/provider.dart';

import '../firebase/auth.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  late User? currentUser;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final mediaQuery = MediaQuery.of(context).size;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    currentUser = authProvider.user;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF025464),
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 10, 0.0,0),
                child: InkWell(
                  onTap: () {
                    // Handle the icon tap here
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle,
                          color: Colors.grey),
                      padding: const EdgeInsets.all(3),
                      height: 23,
                      child: const Center(child: Icon(Icons.person, color: Colors.orange, size: 33,))),
                ),
              );
            }
          ),

        ),
        backgroundColor: Colors.transparent,
        drawer: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF025464), Color(0xFFe57c23)],
            ),
          ),
          child: Drawer(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.orangeAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: mediaQuery.height / 2.7,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blueGrey),
                    child: Column(
                      children: [
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(13.0),
                          child: Text('Account', style:  TextStyle(
                            color: Colors.white,

                          ),),
                        ),
                        const Spacer(),
                        Container(
                            decoration: const BoxDecoration(shape: BoxShape.circle,
                                color: Colors.grey),
                            padding: const EdgeInsets.all(3),
                            height: 90,
                            child: const Center(child: Icon(Icons.person, color: Colors.orange, size: 89,))),
                        const Spacer(),
                        Text('John Doe', style:  TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23
                        ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                //profile
                if (currentUser != null)
                  ListTile(
                  title: GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditProfilePage()));
                    },
                    child: const Text('Profile', style:  TextStyle(
                      color: Colors.white,

                    ),),
                  ),
                  onTap: () {
                    // Handle the profile option
                  },
                ),
                if (currentUser  != null)
                Divider(color: Colors.grey.withOpacity(0.5),
                    thickness: 3,
                indent: 15,
                endIndent: 15,),
                //saved stories
                if (currentUser  != null)
                ListTile(
                  title: const Text('Saved Stories',style:  TextStyle(
                    color: Colors.white,

                  ),),
                  onTap: () {
                    // Handle the saved stories option
                  },
                ),
                if (currentUser  != null)
                Divider(color: Colors.grey.withOpacity(0.5),
                  thickness: 3,
                  indent: 15,
                  endIndent: 15,),
                if (currentUser  == null)
                ListTile(
                  title: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage())
                      );
                    },
                    child: const Text('Sign In',style:  TextStyle(
                      color: Colors.white,

                    ),),
                  ),
                  onTap: () {
                    // Handle the saved stories option
                  },
                ),
                if (currentUser  != null)
                ListTile(
                  title: InkWell(
                    onTap: () {
                      authProvider.logout();
                    },
                    child: const Text('Sign Out',style:  TextStyle(
                      color: Colors.white,

                    ),),
                  ),
                  onTap: () {
                    // Handle the saved stories option
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF025464), Color(0xFFe57c23)],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18.0, 10, 18.0, 0),
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //welcome
                    const Padding(
                      padding: EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                      child: Text("Welcome to",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center),
                    ),
                    //logo
                    SizedBox(
                      child: Image.asset(
                        'assets/images/storywise.png',
                        alignment: Alignment.center,
                        height: 100,
                      ),
                    ),
                    //inspire you
                    const Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(18.0, 0, 18.0, 0),
                        child: Text("What stories will inspire you today?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 34,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    //space
                    const Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 30,
                        )),
                    //first two moods
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            appState.setHappyStories(true);
                            appState.setRandomStories(false);
                            appState.setSadStories(false);
                            appState.setDarkStories(false);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StoryGenerator()));
                          },
                          child: _buildMoodContainer(
                              'assets/images/smile.png', 'Happy Tales'),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            appState.setHappyStories(false);
                            appState.setRandomStories(true);
                            appState.setSadStories(false);
                            appState.setDarkStories(false);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StoryGenerator()));
                          },
                          child: _buildMoodContainer(
                              'assets/images/indifferent.png', 'Random Stories'),
                        ),
                      ],
                    ),
                    //space
                    const Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 30,
                        )),
                    //last two moods
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            appState.setHappyStories(false);
                            appState.setRandomStories(false);
                            appState.setDarkStories(false);
                            appState.setSadStories(true);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StoryGenerator()));
                          },
                          child: _buildMoodContainer(
                              'assets/images/tired.png', 'Tales of Sadness'),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            appState.setHappyStories(false);
                            appState.setRandomStories(false);
                            appState.setSadStories(false);
                            appState.setDarkStories(true);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StoryGenerator()));
                          },
                          child: _buildMoodContainer(
                              'assets/images/anger.png', 'Dark and Twisted'),
                        ),
                      ],
                    ),
                    const Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: 30,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodContainer(String mood, text) {
    return Column(
      children: [
        SizedBox(
          child: Image.asset(
            mood,
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

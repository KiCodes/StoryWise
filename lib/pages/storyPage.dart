import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:storywise/firebase/auth.dart';

import 'package:storywise/main.dart';
import 'package:storywise/pages/login.dart';

class StoryGenerator extends StatefulWidget {
  const StoryGenerator({Key? key}) : super(key: key);

  @override
  State<StoryGenerator> createState() => _StoryGeneratorState();
}
class _StoryGeneratorState extends State<StoryGenerator> {
  late StreamSubscription subscription;
  PageController _pageController = PageController();
  ScrollController _animationController = ScrollController();
  int _currentPage = 0;
  int _currentStory = 0;
  int _currentHeading = 0;
  Timer? _timer;

  late User? currentUser;

  String _currentStoryId = '';

  bool _endOfStories = false;
  bool _loading = false;
  bool _hasInternet = false;
  bool _isFavorited = false;
  String mood = "";

  List<String> _pages = [];
  List<Story> _stories = [];
  List<String> _headings = [];

  @override
  void initState() {
    print("working??");
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _hasInternet = result != ConnectivityResult.none;
      });
    });
    _pageController = PageController(initialPage: _currentPage);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      mediaQueryC = MediaQuery.of(context).size; // Initialize mediaQuery
      final appState = Provider.of<MyAppState>(context, listen: false);
      AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
      currentUser = authProvider.user;

      setState(() {
        print("set state pass??");
        if (appState.happyStories == true) {
          _fetchStoriesFromFirestore("happy");
          _fetchHeadingsFromFirestore("happy");
          mood = "happy";
        } else if (appState.sadStories == true) {
          _fetchStoriesFromFirestore("sad");
          _fetchHeadingsFromFirestore("sad");
          mood = "sad";
        } else if (appState.randomStories == true) {
          _fetchStoriesFromFirestore("random");
          _fetchHeadingsFromFirestore("random");
          mood = "random";
        } else {
          _fetchStoriesFromFirestore("dark");
          _fetchHeadingsFromFirestore("dark");
          mood = "dark";


          // Set isFavorite to false if currentUser is null
          if (currentUser == null) {
            print("eweee $currentUser");
            for (var story in _stories) {
              story.isFavorite = false;
            }
          }
          else{
            print("eweee $currentUser");
            _isFavorited = _currentStory < _stories.length ? _stories[_currentStory].isFavorite : false;
          }
        }


      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  List<String> splitString(String text, double maxWidth, double maxHeight) {
    List<String> result = [];
    String remainingText = text;

    TextSpan textSpan = TextSpan(
      text: text,
      style: const TextStyle(fontSize: 19, color: Colors.white),
    );
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);

    while (remainingText.isNotEmpty) {
      if (textPainter.height > maxHeight) {
        int splitIndex =
            _findSplitIndex(remainingText, textPainter, maxWidth, maxHeight);
        if (splitIndex == -1) {
          // Unable to find a split index, add the remaining text as it is
          result.add(remainingText);
          remainingText = '';
        } else {
          // Split the text at the detected index
          result.add(remainingText.substring(0, splitIndex).trim());
          remainingText = remainingText.substring(splitIndex).trim();
        }
      } else {
        // No overflow, add the remaining text as it is
        result.add(remainingText);
        remainingText = '';
      }
    }

    return result;
  }

  int _findSplitIndex(
      String text, TextPainter textPainter, double maxWidth, double maxHeight) {
    int splitIndex = -1;
    int textLength = text.length;

    for (int i = 0; i < textLength; i++) {
      TextSpan textSpan = TextSpan(
        text: text.substring(0, i + 1),
        style: const TextStyle(fontSize: 23, color: Colors.white),
      );

      TextPainter tempTextPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      tempTextPainter.layout(maxWidth: maxWidth);

      if (tempTextPainter.height > maxHeight) {
        splitIndex = i - 1;
        break;
      }
    }

    return splitIndex;
  }

  late Size mediaQueryC;

  Future<void> changeStory() async {
    if (_loading) {
      return;
    }

    if (_currentStory < _stories.length - 1) {
      setState(() {
        _currentStory++;
        _currentPage = 0;
        _pages = splitString(
          _stories[_currentStory].content,
          mediaQueryC.width,
          mediaQueryC.height / 1.9,
        );
        _currentStoryId = _stories[_currentStory].id;
        print("############ $_currentStoryId");
      });
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutSine,
      );
    } else {
      setState(() {
        _endOfStories = true;
      });
    }
  }

  //adding fav story
  void toggleFavorite() async {
    // Check if the user is logged in
    if (_stories.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      // print("------------- $user --------");
      if (user == null) {
        // Show pop-up notification and navigate to the login page
        Fluttertoast.showToast(
          msg: 'Please sign up to favorite',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        return; // Exit the function if user is null
      }

      _hasInternet = await InternetConnectionChecker().hasConnection;
      // Get the user's ID
      if (_hasInternet) {
        String userId = user.uid;

        // Get the current story ID (replace 'currentStoryId' with the actual ID of the current story)
          Story currentStory = _stories[_currentStory];
          String currentStoryId = _currentStoryId;
          print("%%%%%%%%%%%%%%%% $currentStoryId");

          // Get the user document reference
          DocumentReference userRef =
          FirebaseFirestore.instance.collection('_users').doc(userId);

          // Check if the subcollection 'favoriteStories' exists
          DocumentSnapshot userSnapshot = await userRef.get();
          if (!userSnapshot.exists || (userSnapshot.data() as Map<String, dynamic>).containsKey('favoriteStories')) {
            // Create the 'favoriteStories' subcollection
            CollectionReference favoriteStoriesRef = userRef.collection('favoriteStories');

            // Create the document inside the 'favoriteStories' subcollection
            DocumentReference storyRef = favoriteStoriesRef.doc(currentStoryId);
            await storyRef.set({
              'storyId': currentStoryId,
              // Add any additional fields you want to save with the story
            });

            // Update the UI to reflect that the story is favorited
            setState(() {
              _isFavorited = true;
            });
          } else {
            // The 'favoriteStories' subcollection exists, check if the current story is already favorited
            DocumentSnapshot favoriteSnapshot = await userRef.collection('favoriteStories').doc(currentStoryId).get();
            if (favoriteSnapshot.exists) {
              // The current story is already favorited, so remove it from the 'favoriteStories' subcollection
              await userRef.collection('favoriteStories').doc(currentStoryId).delete();

              // Update the UI to reflect that the story is not favorited
              setState(() {
                _stories[_currentStory].isFavorite = false;
                _isFavorited = false;
              });
            } else {
              // The current story is not favorited, so add it to the 'favoriteStories' subcollection
              await userRef.collection('favoriteStories').doc(currentStoryId).set({
                'storyId': currentStoryId,
              });

              // Update the UI to reflect that the story is favorited
              setState(() {
                _stories[_currentStory].isFavorite = true;
                _isFavorited = true;
              });
            }
          }
      }
      else{
        Fluttertoast.showToast(
          msg: "No Internet Connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
        );
      }
    }
  }

  Future<void> _fetchStoriesFromFirestore(String mood) async {
    setState(() {
      // Clear the existing stories and headings
      _stories = [];
      _headings = [];
      if(_loading){
        _endOfStories = true;
      }


    });

    // Fetch the favorite stories of the current user
    final currentUserFavorites = await FirebaseFirestore.instance
        .collection('_users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favoriteStories')
        .get();

    final favoriteStoryIds = currentUserFavorites.docs.map((doc) => doc.id).toSet();

    Timer(const Duration(seconds: 10), () {
      if (_loading) {
        setState(() {
          // Handle the timeout scenario here
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Alert();
            },
          );
          _loading = false;
        });
      }
    });

    final snapshot = await FirebaseFirestore.instance
          .collection('_stories')
          .where('mood', isEqualTo: mood)
          .get();

    setState(() {
      _stories = snapshot.docs.map((DocumentSnapshot document) {
        final data = document.data() as Map<String, dynamic>?;
        final content = data != null ? data['content'] as String : '';
        final storyId = document.id;
        // Check if the story is favorited by the current user
        final bool isFavorite = favoriteStoryIds.contains(storyId);

        return Story(
          id: storyId,
          content: content,
          isFavorite: isFavorite,
        );
      }).toList();

      if (_stories.isNotEmpty) {
        _currentStoryId = _stories[_currentStory].id;
        _pages = splitString(
          _stories[_currentStory].content,
          mediaQueryC.width,
          mediaQueryC.height / 1.9,
        );
      } else {
        _endOfStories = true;
      }

      _loading = false;
    });
    setState(() {
      // Set the loading state to false once the data fetching is complete
      _loading = false;
    });
  }

  Future<void> _fetchHeadingsFromFirestore(String mood) async {
    setState(() {
      // Clear the existing headings
      _headings = [];
      _loading = true;
    });

    _hasInternet = await InternetConnectionChecker().hasConnection;
    print('____$_hasInternet');

    Timer(const Duration(seconds: 10), () {
      if (_loading) {
        setState(() {
          // Handle the timeout scenario here
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const Alert();
            },
          );
          _loading = false;
        });
      }
    });

      FirebaseFirestore.instance
          .collection('_stories')
          .where('mood', isEqualTo: mood)
          .get()
          .then((QuerySnapshot snapshot) {
        setState(() {
          _headings = snapshot.docs.map((DocumentSnapshot document) {
            final data = document.data() as Map<String,
                dynamic>?; // Explicitly cast data to Map<String, dynamic>
            final content = data != null ? data['heading'] as String : '';
            return content;
          }).toList();
        });
      }).catchError((error) {
        print('Error retrieving stories: $error');
      }).whenComplete(() {
        setState(() {
          // Set the loading state to false once the data fetching is complete
          _loading = false;
        });
      });
  }

  Future<void> _fetchNewStories(String mood) async {
    setState(() {
      _loading = true;
    });
    _hasInternet = await InternetConnectionChecker().hasConnection;
    print('____$_hasInternet');

    if (_hasInternet) {
      _fetchStoriesFromFirestore(mood);
      _fetchHeadingsFromFirestore(mood);
      print('*******************$_hasInternet*****************');
    } else {
      setState(() {
        _loading = false; // Set loading state to false
        _hasInternet = false; // Update the isConnected flag
        _endOfStories = true; // Update the endOfStories flag to display the "No Internet Connection" message
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    _isFavorited = _currentStory < _stories.length ? _stories[_currentStory].isFavorite : false;


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0c134f),
        elevation: 0,
        centerTitle: true,
        title: _loading
            ? const CircularProgressIndicator(
                color: Colors.yellowAccent,
              ) // Display the loading indicator
            : !_hasInternet
                ? const Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  )
                : !_endOfStories
                    ? _headings.isNotEmpty && _currentHeading < _headings.length
                        ? Text(
                            _headings[_currentHeading],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox(),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0c134f), Color(0xFF5c469c)],
          ),
        ),
        child: Stack(
          children: [
            //quote up icon
            Positioned(
              top: mediaQuery.height / 120,
              left: 63,
              child: Transform(
                transform: Matrix4.rotationY(math.pi),
                child: const Icon(
                  Icons.format_quote_outlined,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
            //                 GestureDetector(
            //                   onTap: (){quote down
            Positioned(
              bottom: mediaQuery.height / 15,
              right: 33,
              child: const Icon(
                Icons.format_quote_outlined,
                color: Colors.white,
                size: 34,
              ),
            ),
            //page content
            Center(
              child: _endOfStories
                  ? _stories.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        const Text(
                          'No more stories',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.downloading_outlined,
                            color: Colors.yellowAccent,
                            size: 34,
                          ),
                          onPressed: () {
                            _fetchNewStories(mood);
                          },
                          label: const Text(
                            "Fetch New Stories",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                      ],
                    )
                  : const Text(
                      'No Stories Found',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                ),
              )
                  : SizedBox(
                      height: mediaQuery.height / 1.7,
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        pageSnapping: true,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(28.0, 0, 28, 0),
                            child: Text(
                              _pages[index],
                              style: const TextStyle(
                                  fontSize: 21, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
            ),
        _stories.isNotEmpty
            ? !_loading
                ? Positioned(
                  top: mediaQuery.height / 100,
                  right: mediaQuery.width / 2.25,
                  child: GestureDetector(
                      onTap: toggleFavorite,
                      child: Icon(
                        _stories[_currentStory]?.isFavorite ?? false ? Icons.favorite : Icons.favorite_border,
                        color: _stories[_currentStory].isFavorite ? Colors.red : Colors.white,
                        size: mediaQuery.width /10,
                      )
                  ),
            )
                : const SizedBox.shrink()
            : SizedBox.shrink(),// Display the loading indicator
            //Next story button
            Positioned(
              bottom: mediaQuery.height / 11,
              right: mediaQuery.width / 3,
              child: Row(
                children: [
                  TextButton(
                    child: const Text(
                      "Next Story",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      changeStory();
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      changeStory();
                    },
                    child: const Icon(
                      Icons.rotate_right,
                      color: Colors.lightBlueAccent,
                      size: 34,
                    ),
                  ),
                ],
              ),
            ),
            //previous story
            Positioned(
              top: mediaQuery.height / 20,
              right: mediaQuery.width / 3,
              child: TextButton.icon(
                icon: const Icon(
                  Icons.rotate_left,
                  color: Colors.deepOrange,
                  size: 34,
                ),
                onPressed: () {
                  setState(() {
                    if (_endOfStories) {
                      // If it's the end of stories, go back to the previous story
                      _endOfStories = false;
                      _currentPage = 0;
                      if (_currentStory >= 0 && _currentStory < _stories.length) {
                        _pages = splitString(
                          _stories[_currentStory].content,
                          mediaQuery.width,
                          mediaQuery.height / 1.9,
                        );
                      }
                    } else if (_currentStory > 0) {
                      _currentStory--; // Decrement the current story index
                      _currentPage = 0; // Reset the current page index
                      if (_currentStory >= 0 && _currentStory < _stories.length) {
                        _pages = splitString(
                          _stories[_currentStory].content,
                          mediaQuery.width,
                          mediaQuery.height / 1.9,
                        );
                      } else {
                        // Handle the case when the index is out of range
                        // For example, show an error message or perform a different action
                      }
                    }
                  });
                },
                label: const Text(
                  "Previous story",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            //dots
            Positioned(
              bottom: 16,
              left: 16,
              child: DotsIndicator(
                dotsCount: _endOfStories ? 1 : (_pages.isNotEmpty ? _pages.length : 1),
                position: _endOfStories ? 0 : _currentPage, // Current page position
                decorator: const DotsDecorator(
                  size: Size.fromRadius(6),
                  activeSize: Size.fromRadius(3),
                  activeShape: CircleBorder(side: BorderSide.none),
                  activeColor:
                      Colors.yellowAccent, // Customize the active dot color
                ),
              ), // Customize the active dot color
            ),
          ],
        ),
      ),
    );
  }
}

class Alert extends StatelessWidget {
  const Alert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.deepOrange,
      title: const Text('Timeout', style: TextStyle(color: Colors.white,),),
      content: const Text('Fetching stories timed out.'),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class Story {
  final String id;
  final String content;
  bool isFavorite;

  Story({required this.id, required this.content, required this.isFavorite});
}

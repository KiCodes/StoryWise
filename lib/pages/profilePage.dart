import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:storywise/pages/storyPage.dart';


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _profileImage;
  File? _bannerImage;
  String? imageUrl;
  String? myUName;
  String? myImage;


  bool _isScreenDark = false;
  bool _isPositioned = false;
  bool _isSelected = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  double circlePositionX = 0; // X-coordinate of the circle's position
  double circlePositionY = 0; // Y-coordinate of the circle's position

  double scale = 1.0;
  double previousScale = 1.0;
  Offset position = Offset.zero;
  Offset previousPosition = Offset(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    Future<void> _pickProfileImage() async {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        try {
          FirebaseStorage storage = FirebaseStorage.instance;
          Reference storageReference = storage.ref().child('profilePic/${DateTime.now().millisecondsSinceEpoch}');
          File imageFile = File(pickedImage.path);
          TaskSnapshot snapshot = await storageReference.putFile(imageFile);
          imageUrl = await snapshot.ref.getDownloadURL();
          print("noo$imageUrl");

          FirebaseFirestore.instance.collection('_images').doc(DateTime.now().toString()).set({
            'id': 'uchp5YRny0NWOYwgqNwI',
            'email': 'harry@gmail.com',
            'profilePic': myImage,
            'username': myUName,
            'Image': imageUrl,
            'downloads': 0,
            'createdAt': DateTime.now(),
          });

          Navigator.canPop(context) ? Navigator.pop(context) : null;
        } on Exception catch (e) {
          // Handle the exception
        }
      }
    }

    Future<void> _pickBannerImage() async {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _bannerImage = File(pickedImage.path);
          // _isScreenDark = true;
          // _isPositioned = true;
        });
      }
    }

    void read_user_info() async {
      FirebaseFirestore.instance.collection('_users').doc(FirebaseAuth.instance.currentUser!.uid).get().then<dynamic>((DocumentSnapshot snapshot) async{
          myUName = snapshot.get('username');
          myImage = snapshot.get('profilePic');

      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.lightBlueAccent.withOpacity(0.8),
        body: GestureDetector(
          onScaleStart: (details) {
            previousScale = scale;
            previousPosition = position;
          },
          onScaleUpdate: (details) {
            setState(() {
              scale = (previousScale * details.scale).clamp(1.0, double.infinity);

              // Calculate the maximum allowed movement in each direction based on the screen dimensions
              final maxMoveX = (mediaQuery.width * scale - mediaQuery.width) / 2 + 90;
              final maxMoveY = (mediaQuery.height * scale - mediaQuery.height) / 2 + 90;

              // Calculate the delta values
              final dx = details.focalPoint.dx - previousPosition.dx;
              final dy = details.focalPoint.dy - previousPosition.dy;

              // Calculate the new position by adding the delta values and clamping them within the maximum movement limits
              position = Offset(
                (previousPosition.dx + dx).clamp(-maxMoveX, maxMoveX),
                (previousPosition.dy + dy).clamp(-maxMoveY, maxMoveY),
              );
            });
          },
          behavior: HitTestBehavior.opaque,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Banner Image Section
                    Container(
                      height: mediaQuery.height / 4,
                      width: mediaQuery.width,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: _bannerImage == null
                          ? Image.asset(
                        "assets/images/IMG_4610.JPG",
                        fit: BoxFit.cover,
                      )
                          : Image.file(_bannerImage!, fit: BoxFit.cover),
                    ),
                    SizedBox(height: 16.0),
                    // Profile Image Section
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null, // No default image, set it to null
                          child: _profileImage == null
                              ? Icon(
                                  Icons.person,
                                  size: 80.0,
                                  color: Colors.orange,
                                ) // Replace with your desired icon
                              : null,
                        ),
                        SizedBox(width: 16.0),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // Mood Sections
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Happy',
                          style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold
                          ),),
                        Text('Sad',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold
                          ),),
                        Text('Indifferent',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold
                          ),),
                        Text('Dark',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold
                          ),),
                      ],
                    ),
                    Column(
                      children: [
                        buildMoodSection('Dark'),
                      ],
                    ),
                    Column(
                      children: [

                      ],
                    )
                  ],
                ),
              ),
              //banner button
              Positioned(
                top: mediaQuery.height / 7,
                right: mediaQuery.width / 14,
                child: ElevatedButton(
                  onPressed: _pickBannerImage,
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.3))
                  ),
                  child: Text('Change Banner'),
                ),
              ),
              Positioned(
                  top: mediaQuery.height / 3.4,
                  left: mediaQuery.width / 25,
                  child: GestureDetector(
                    onTap:
                      _pickProfileImage,
                      child: Icon(Icons.camera_enhance_rounded, size: 50, color: Colors.white.withOpacity(0.5),))),
              _isScreenDark
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _isScreenDark = false;
                        });
                      },
                      child: Container(
                        color: Colors.black,
                      ),
                    )
                  : SizedBox.shrink(),
              //profile image
              _isScreenDark && _isPositioned
                  ? Transform.translate(
                      offset: position,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: mediaQuery.width,
                          height: mediaQuery.height,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.transparent,
                          ),
                          child: _profileImage != null
                              ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.white.withOpacity(
                                        0.5), // Adjust the opacity value here
                                    BlendMode.dstATop,
                                  ),
                                  child: Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              _isScreenDark
                  ? ClipPath(
                      clipper: CircleClipper(),
                      child: Container(
                        color: Colors.black.withOpacity(0.8),
                        child: Container(
                          width: mediaQuery.width,
                          height: mediaQuery.height,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              _isScreenDark
                  ? ClipPath(
                clipper: CircleClipperSmall(),
                child: Container(
                  color: Colors.grey,
                  child: Container(
                    width: mediaQuery.width,
                    height: mediaQuery.height,
                  ),
                ),
              )
                  : SizedBox.shrink(),
              _isScreenDark
                  ? ElevatedButton(
                onPressed: (){

                },
                      child: Text("Apply"))
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoodSection(String mood) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.0),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('_users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('favoriteStories')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Display a loading indicator while fetching data
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Text('No favorite stories found.');
              }

              // Extract the list of story IDs from the snapshot
              List<String> storyIds = snapshot.data!.docs.map((doc) => doc.id).toList();

              if (storyIds.isEmpty) {
                return Text('No favorite stories found.');
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: storyIds.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('_stories').doc(storyIds[index]).get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return SizedBox.shrink();
                      }

                      // Extract the title and content from the story document
                      String title = snapshot.data!.get('title');
                      String content = snapshot.data!.get('content');

                      return ListTile(
                        title: Text(title),
                        subtitle: Text(content),
                        onTap: () {
                          // Handle the tap on the story here, navigate to another page
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => StoryPage(title, content)),
                          // );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

}

class CircleClipper extends CustomClipper<Path> {
  final double borderWidth;

  CircleClipper({this.borderWidth = 900.0});
  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5; // Adjust the radius as needed

    path.addOval(Rect.fromCircle(center: center, radius: radius));

    final borderPath = Path();
    borderPath.addOval(Rect.fromCircle(
        center: center,
        radius: radius + borderWidth / 2)); // Adjust the border width as needed

    path
      ..fillType = PathFillType.evenOdd
      ..addPath(borderPath, Offset.zero);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CircleClipperSmall extends CustomClipper<Path> {
  final double borderWidth;

  CircleClipperSmall({this.borderWidth = 12.0});
  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3; // Adjust the radius as needed

    path.addOval(Rect.fromCircle(center: center, radius: radius));

    final borderPath = Path();
    borderPath.addOval(Rect.fromCircle(
        center: center,
        radius: radius + borderWidth / 2)); // Adjust the border width as needed

    path
      ..fillType = PathFillType.evenOdd
      ..addPath(borderPath, Offset.zero);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

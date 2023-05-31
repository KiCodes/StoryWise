import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _profileImage;
  bool _isScreenDark = false;
  bool _isPositioned = false;
  double circlePositionX = 0; // X-coordinate of the circle's position
  double circlePositionY = 0; // Y-coordinate of the circle's position

  double scale = 1.0;
  double previousScale = 1.0;
  Offset position = Offset(0.0, 0.0);
  Offset previousPosition = Offset(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    Future<void> _pickProfileImage() async {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _profileImage = File(pickedImage.path);
          _isScreenDark = true;
          _isPositioned = true;
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: GestureDetector(
          onScaleStart: (details) {
            previousScale = scale;
            previousPosition = position;
          },
          onScaleUpdate: (details) {
            setState(() {
              scale =
                  (previousScale * details.scale).clamp(1.0, double.infinity);
              position = Offset(
                previousPosition.dx +
                    details.focalPoint.dx -
                    mediaQuery.width / 2,
                previousPosition.dy +
                    details.focalPoint.dy -
                    mediaQuery.height / 2,
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
                      child: _profileImage == null
                          ? Image.asset("assets/images/IMG_4610.JPG")
                          : SizedBox.shrink(), // No default image, set ,
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
                        ElevatedButton(
                          onPressed: _pickProfileImage,
                          child: Text('Change Image'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // Mood Sections
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildMoodSection('Happy'),
                        buildMoodSection('Sad'),
                        buildMoodSection('Indifferent'),
                        buildMoodSection('Dark'),
                      ],
                    )
                  ],
                ),
              ),
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
              ElevatedButton(onPressed: (){}, child:
              Text("Apply"))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMoodSection(String mood) {
    // TODO: Implement mood section based on the given mood
    // Display mood title and list of stories
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mood,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          // TODO: Display list of stories within the mood section
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
    final radius = size.width / 4; // Adjust the radius as needed

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
    final radius = size.width / 4; // Adjust the radius as needed

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

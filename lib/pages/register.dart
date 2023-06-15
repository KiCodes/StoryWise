import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../firebase/auth.dart';
import 'login.dart';
import 'moodPage.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  bool _isUsernameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  FocusNode _usernameFocusNode = FocusNode();

  void _validateUsername() {
    final enteredText = _usernameController.text;
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    setState(() {
      _isUsernameValid = regex.hasMatch(enteredText);
    });
  }
  void _validateEmail() {
    final enteredText = _emailController.text;
    final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    setState(() {
      _isEmailValid = regex.hasMatch(enteredText);
    });
  }
  void _validatePassword() {
    final enteredText = _passwordController.text;
    final regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    setState(() {
      _isPasswordValid = regex.hasMatch(enteredText);
    });
  }

  String _capitalizeAfterSpace(String text) {
    List<String> words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      if (word.isNotEmpty) {
        String capitalizedWord = word[0].toUpperCase() + word.substring(1);
        words[i] = capitalizedWord;
      }
    }

    return words.join(' ');
  }

  bool _focusFN = false;
  bool _focusEM = false;
  bool _focusUS = false;
  bool _focusPS = false;

  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    _focusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
    _usernameController.addListener(_validateUsername);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    super.initState();
  }
  void _onFocusChange() {
    setState(() {
      _focusFN = _focusNode.hasFocus;
      _focusEM = _focusNode.hasFocus;
      _focusUS = _focusNode.hasFocus;
      _focusPS = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0c134f), Color(0xFF5c469c)],
            ),
          ),
          child: Column(
            children: [
              _buildTopHalf(mediaQuery),
              Expanded(
                child: _buildBottomHalf(mediaQuery, authProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHalf(mediaQuery) {
    return Container(
      height: mediaQuery.height * 0.35,
      child: Stack(
        children: [
          Positioned.fill(
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: 20,
                color: Colors.transparent,
                shadowLightColor: Colors.grey.withOpacity(0.4),
                shadowDarkColor: Colors.black.withOpacity(0.2),
                lightSource: LightSource.right,
                boxShape: NeumorphicBoxShape.roundRect(
                  const BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                    topLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/images/2689196.png'),
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.transparent)
                ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoodPage()),
                  );
                },
                child: const Icon(Icons.arrow_back)),
          )
        ],
      ),
    );

  }

  Widget _buildBottomHalf(mediaQuery, AuthProvider authProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //FULL NAME
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _focusFN = hasFocus;
                });
              },
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 10,
                  color: _focusFN ? const Color(0xFF3f51b5).withOpacity(0.4) : const Color(0xFF3f51b5).withOpacity(0.08),
                  shadowLightColor: Colors.black.withOpacity(0.4),
                  shadowDarkColor: Colors.black.withOpacity(0.2),
                  intensity: 22,
                  lightSource: LightSource.bottom,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(29),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12,0),
                  child: TextField(
                    style: const TextStyle(color: Color(0xFFffe0b2), fontWeight: FontWeight.bold, fontSize: 15),
                    controller: _fullnameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.black,
                      hintText: 'Full name',
                      hintStyle: const TextStyle(color: Color(0xFFffe0b2)),
                      prefixIcon: const Icon(Icons.person, size: 20, color: Color(0xFFffe0b2),),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide: BorderSide(
                            color: Colors.yellow.withOpacity(0.5),
                            width: 13,
                          )
                      ),
                    ),
                    onChanged: (text) {
                      // Apply capitalization logic here
                      String capitalizedText = _capitalizeAfterSpace(text);
                      if (capitalizedText.isEmpty) {
                        capitalizedText = capitalizedText.toUpperCase();
                      }
                      _fullnameController.value = _fullnameController.value.copyWith(
                        text: capitalizedText,
                        selection: TextSelection.collapsed(offset: capitalizedText.length),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            //EMAIL
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _focusEM = hasFocus;
                });
              },
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 10,
                  color: _focusEM ? const Color(0xFF3f51b5).withOpacity(0.4) : const Color(0xFF3f51b5).withOpacity(0.08),
                  shadowLightColor: Colors.black.withOpacity(0.4),
                  shadowDarkColor: Colors.black.withOpacity(0.2),
                  intensity: 22,
                  lightSource: LightSource.bottom,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(29),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12,0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Color(0xFFffe0b2), fontWeight: FontWeight.bold, fontSize: 15),
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'email',
                      hintStyle: const TextStyle(color: Color(0xFFffe0b2)),
                      prefixIcon: const Icon(Icons.alternate_email,size: 20, color: Color(0xFFffe0b2),),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide: BorderSide(
                            color: Colors.yellow.withOpacity(0.5),
                            width: 13,
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _focusUS = hasFocus;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Neumorphic(
                    // TextField widget
                  ),
                  if (_focusEM && !_isEmailValid)
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10, 0, 2),
                      child: Text(
                        'Invalid email format',
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            //USERNAME
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _focusUS = hasFocus;
                });
              },
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 10,
                  color: _focusUS ? const Color(0xFF3f51b5).withOpacity(0.4) : const Color(0xFF3f51b5).withOpacity(0.08),
                  shadowLightColor: Colors.black.withOpacity(0.4),
                  shadowDarkColor: Colors.black.withOpacity(0.2),
                  intensity: 22,
                  lightSource: LightSource.bottom,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(29),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12,0),
                  child: TextField(
                    style: const TextStyle(color: Color(0xFFffe0b2), fontWeight: FontWeight.bold, fontSize: 15),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                      hintStyle: const TextStyle(color: Color(0xFFffe0b2)),
                      prefixIcon: const Icon(Icons.add_card_outlined,size: 20, color: Color(0xFFffe0b2),),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide: BorderSide(
                            color: Colors.yellow.withOpacity(0.5),
                            width: 13,
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _focusUS = hasFocus;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Neumorphic(
                    // TextField widget
                  ),
                  if (_focusUS && !_isUsernameValid)
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10, 0, 2),
                      child: Text(
                        'Username should only have alphabets, numbers, or underscores',
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            //PASSWORD
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _focusPS = hasFocus;
                });
              },
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 10,
                  color: _focusPS ? const Color(0xFF3f51b5).withOpacity(0.4) : const Color(0xFF3f51b5).withOpacity(0.08),
                  shadowLightColor: Colors.black.withOpacity(0.4),
                  shadowDarkColor: Colors.black.withOpacity(0.2),
                  intensity: 22,
                  lightSource: LightSource.bottom,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(29),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12,0),
                  child: TextField(
                    style: const TextStyle(color: Color(0xFFffe0b2), fontWeight: FontWeight.bold, fontSize: 15),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'password',
                      hintStyle: const TextStyle(color: Color(0xFFffe0b2)),
                      prefixIcon: const Icon(
                        Icons.key,
                        color: Color(0xFFffe0b2),
                      size: 20),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(23),
                          borderSide: BorderSide(
                            color: Colors.yellow.withOpacity(0.5),
                            width: 13,
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _focusUS = hasFocus;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Neumorphic(
                    // TextField widget
                  ),
                  if (_focusPS && !_isPasswordValid)
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 10, 0, 2),
                      child: Text(
                        'Password must contain at least 8 characters, including one uppercase letter, one lowercase letter, and one digit',
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            //submit button
            SizedBox(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xFF1a237e),),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(const Size(310, 55)),
                ),
                onPressed: () async {
                  await authProvider.register(_usernameController, _passwordController, _emailController, _fullnameController, context);
                },

                child: const Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No account? ',style: TextStyle(color: Colors.white),),
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text('Login', style: TextStyle(color: Colors.orange),))
              ],
            ),
          ],
        ),
      ),
    );
  }

}

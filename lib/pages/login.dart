import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:storywise/pages/moodPage.dart';
import 'package:storywise/pages/register.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode _focusNode = FocusNode();
  bool _focusUN = false;
  bool _focusP = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focusNode.addListener(_onFocusChange);
  }
  void _onFocusChange() {
    setState(() {
      _focusUN = _focusNode.hasFocus;
      _focusP = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFbd0417), Color(0xFFffd50e)],
            ),
          ),
          child: Column(
            children: [
              _buildTopHalf(mediaQuery),
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: _buildBottomHalf(),
                ),
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
                shadowLightColor: Colors.grey.withOpacity(0.7),
                shadowDarkColor: Colors.black.withOpacity(0.2),
                lightSource: LightSource.right,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                    bottomRight: Radius.circular(50),
                  ),
                ),
              ),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/images/2655615.png'),
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.transparent)
              ),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoodPage()),
                  );
                },
                child: Icon(Icons.arrow_back)),
          )
        ],
      ),
    );

  }

  Widget _buildBottomHalf() {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _focusUN = hasFocus;
                });
              },
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 10,
                  color: _focusUN ? Color(0xFFffd50e).withOpacity(0.38) : Color(0xFFffd50e),
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
                    style: TextStyle(color: Color(0xFF1a237e), fontWeight: FontWeight.bold, fontSize: 15),
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Color(0xFF1a237e)),
                      prefixIcon: Icon(Icons.mail, color: Color(0xFF1a237e),),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(23),
                        borderSide: BorderSide(
                          color: Colors.yellow.withOpacity(0.5),
                          width: 13,
                        )
                      ),
                      hintText: 'Username',

                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _focusP = hasFocus;
                });
              },
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 10,
                  color: _focusP ? Color(0xFFffd50e).withOpacity(0.38) : Color(0xFFffd50e),
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
                    style: TextStyle(color: Color(0xFF1a237e), fontWeight: FontWeight.bold, fontSize: 15),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'password',
                      hintStyle: TextStyle(color: Color(0xFF1a237e)),
                      prefixIcon: Icon(Icons.key, color: Color(0xFF1a237e),),
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
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Forgot Password?', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 40,
            ),
            //button
            Container(
              width: MediaQuery.of(context).size.width / 0.9,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFffd50e)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(Size(310, 55))
                ),
                onPressed: () {},
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Color(0xFF1a237e),
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('No Account? ',style: TextStyle(color:Colors.white),),
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text('Register', style: TextStyle(color: Color(0xFF1a237e)),))
              ],
            ),

          ],
        ),
      ),
    );
  }

}

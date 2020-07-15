import 'package:Chatapp/components/buttons.dart';
import 'package:Chatapp/screens/login_screen.dart';
import 'package:Chatapp/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  //bcoz welcomescreen state tells us the current state of animation
//(a ticker provider),here ticker is like a particular frame of animation helps to keep
// track of animation. we have added tat singletciker bcoz it makes welscreestate a ticker provider
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this, //for refering the object of a class inside the
      // class itself we use this,we are saying welscrstate obj will provide ticker
    );
    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward(); //to satrt animation from small to big
    //controller.reverse(from: 1.0);//animate from big to small
    //------------------------------------------------
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {   //here this is used for cycle animation from forward to backward then again vice versa
    //     controller.forward();
    //   }
    // });
    //----------------------------------------------------
    //search for prepackaged animation in pub,dartlang/packages
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.addListener(() {
      setState(() {});
      //setstate is called becoz to hear every change in ticker and cause to build the widget again
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    // height: animation.value * 100,  // to play animate with sizes
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 200),
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            LowerButton(
              color: Colors.lightBlueAccent,
              onpressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              label: 'Log In',
            ),
            LowerButton(
              color: Colors.blueAccent,
              onpressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              label: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}

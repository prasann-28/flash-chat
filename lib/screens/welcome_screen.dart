import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/RoundedButton.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey ,end: Colors.deepPurpleAccent ).animate(controller);
    controller.forward();
    animation.addStatusListener((status) {
      print(status);
    });

    controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
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
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 100,
                    ),
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic
                  ),
                ),
                // AnimatedTextKit(animatedTexts: [
                //   TyperAnimatedText('Flash Chat',
                //   textStyle: TextStyle(
                //     fontSize: 40.0,
                //     fontWeight: FontWeight.w900
                //   ),
                //   curve: Curves.easeInOutCubicEmphasized
                //   ),
                //
                // ]),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(buttonTitle:'Log in' ,buttonColor: Colors.pinkAccent, onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
            }, ),
            RoundedButton(buttonTitle: "Register", buttonColor: Colors.pink, onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            }),
          ],
        ),
      ),
    );
  }
}

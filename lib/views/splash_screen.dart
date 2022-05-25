import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tamka/res/custom_colors.dart';
import '../screens/home_screen.dart';



class Splash extends StatefulWidget {
  const Splash({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  VideoState createState() => VideoState();
}



class VideoState extends State<Splash> with SingleTickerProviderStateMixin{

  User currentUser = FirebaseAuth.instance.currentUser;
  var _visible = true;

   AnimationController animationController;
   Animation<double> animation;

  startTime() async {
    var _duration = const Duration(seconds: 4);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => HomeScreen(),
      ),
          (route) => false,//if you want to disable back feature set to false
    );
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => CameraScreen ()));
  }

  @override
  void initState() {

    super.initState();



    animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    animation =
    CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/icon/logo.png',
                width: animation.value * 200,
                height: animation.value * 400,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children:  <Widget>[
              Padding(padding: EdgeInsets.only(bottom: 70.0),child:Text(
                "Welcome Back ${currentUser.email.replaceAll("@gmail.com", "")}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.firebaseNavy,
                    fontSize: 15),
              )
              ),

              Padding(padding: EdgeInsets.only(bottom: 30.0),
                  child:Text("powered by",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.firebaseNavy,
                        fontSize: 15),
                  )
              ),Image.asset("assets/vliruos-logo.png")
              
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plwha/res/custom_colors.dart';
import 'package:plwha/screens/sign_in_screen.dart';
import 'package:plwha/services/auth.dart';
import 'package:plwha/widgets/appbar/app_bar_title.dart';

import '../helperfunctions/sharedpref_helper.dart';
import '../widgets/searchbar/search_bar.dart';
import 'home_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key key,User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}


class _UserInfoScreenState extends State<UserInfoScreen> {
  User _user;
  bool _isSigningOut = false;
  String myName, myProfilePic, myUserName, myEmail;
  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    //myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
  }
  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  editProfileUsername(){

  }
  uploadPhoto(){}

  @override
  void initState() {
    _user = widget._user;
    getMyInfoFromSharedPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: const AppBarTitle(),
          actions:
          <Widget>[
            PopupMenuButton(
                color: CustomColors.firebaseNavy,
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.info, size: 18,),
                            SizedBox(width: 5,),
                            Text(" About PLWHA"),
                          ]
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.home, size: 18,),
                            SizedBox(width: 5,),
                            Text(" Home"),
                          ]
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              FontAwesomeIcons.arrowLeft, size: 18,),
                            SizedBox(width: 5,),
                            Text(" Logout"),
                          ]
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    try {
                      _aboutPage();
                    } on Exception catch (_, e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  }  else if (value == 1) {
                    try {
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      );
                      Navigator.of(context)
                          .pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } on Exception catch (_, e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }

                    } else if (value == 2){
                    try {
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      );
                      _logoutUser();
                    } on Exception catch (_, e) {
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  }
                }
            ),
          ]
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              _user.photoURL != null
                  ? ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Image.network(
                          _user.photoURL,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: CustomColors.firebaseGrey,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 16.0),
              Text(
                'Hello  ${myUserName}',
                style: TextStyle(
                  color: CustomColors.firebaseGrey,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              Text(
                '( ${_user.email} )',
                style: TextStyle(
                  color: CustomColors.firebaseOrange,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                'You are now signed in using your Google account. To sign out of your account click the "Sign Out" button below.',
                style: TextStyle(
                    color: CustomColors.firebaseGrey.withOpacity(0.8),
                    fontSize: 14,
                    letterSpacing: 0.2),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
  _logoutUser() async{
    setState(() {
      _isSigningOut = true;
    });
    await AuthMethods.signOut();
    setState(() {
      _isSigningOut = false;
    });
    Navigator.of(context)
        .pushReplacement(_routeToSignInScreen());
  }
  _aboutPage() async{
    setState(() {
      _isSigningOut = false;
    });
    _showMyDialog();
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PEOPLE LIVING WITH HIV/AIS PROJECT'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("The Project titled People Living with HIV and Aids (PLWHA) is coordinated under the Faculty of Law Mzumbe University "
                    "in collaboration with the University of Ghent in Belgium. HIV/AIDS is a major development crisis"
                    "affecting the whole population and all sectors. Being an economic, social, and cultural problem, HIV/AIDS"
                    "discrimination and stigma is one of the greatest challenges in the prevention and control of the epidemic. Often, people"
                    "living with HIV/AIDS are deprived of health and social protection."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

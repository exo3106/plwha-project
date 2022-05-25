import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamka/res/custom_colors.dart';
import 'package:tamka/screens/sign_in_screen.dart';
import 'package:tamka/widgets/appbar/ChatAppBarUI.dart';
import 'package:tamka/widgets/appbar/GameAppBarUI.dart';
import 'package:tamka/widgets/appbar/HomeAppBarUI.dart';
import 'package:tamka/widgets/nav_drawer.dart';
import '../services/auth.dart';
import 'chat_screen_ui.dart';
import 'game_screen_ui.dart';
import 'home_screen_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _HomeScreenState createState() => _HomeScreenState(_user);
}

class _HomeScreenState extends State<HomeScreen> {
  User _user;
  bool _isSigningOut = false;
  int index = 0;
  bool isWhichScreen = false;
  User currentUser = FirebaseAuth.instance.currentUser;
  final appbar = [
    const HomeAppBarUI(),
    const ChatAppBarUI(),
     GameAppBarUI(),
  ];
  final screens = [
      const HomeScreenUI(),
      const ChatScreenUI(),
      GameScreenUI()
  ];

  _HomeScreenState(this._user);


  @override
  void initState() {
    _user = widget._user;
    index = 0;
    isWhichScreen = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseBackground,
      drawer: NavDrawer(),
      appBar:PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: appbar[index]),
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
          data:  NavigationBarThemeData(
            backgroundColor: CustomColors.firebaseNavy,
            indicatorColor: CustomColors.firebaseNavyLight,
            height: 60
          ),
          child:NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (index){
              setState(() {
                this.index = index;
              });
            },
            destinations:   [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined,size: 18,color: CustomColors.firebaseAmber,),
                  label: "Home"
              ),
              NavigationDestination(
                  icon: Icon(FontAwesomeIcons.envelopeOpenText,size: 18,color: CustomColors.firebaseOrange,),
                  label: "Private Chat"
              ),
              NavigationDestination(
                  icon: Icon(FontAwesomeIcons.comments,size: 18,color: CustomColors.firebaseYellow,),
                  label: "Forum"
              ),
            ],
          )
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
        .pushReplacement(routeToSignInScreen());
  }
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PEOPLE LIVING WITH HIV/AIS PROJECT'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
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
  Future<void> _showGroupDialog() async {
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
  PageRoute routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}


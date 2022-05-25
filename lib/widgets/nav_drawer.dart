

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamka/res/custom_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/sign_in_screen.dart';


class NavDrawer extends StatelessWidget {
   NavDrawer({Key key,User user})
      : _user = user,
        super(key: key);

  final User _user;
  String myName, myProfilePic, myUserName, myEmail;
  final user = FirebaseAuth.instance.currentUser;
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




  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'People Living With HIV/AIDS',
                  style: TextStyle(color: CustomColors.firebaseYellow, fontSize: 20),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    myProfilePic != null
                        ? ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Image.network(
                          myProfilePic,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                        : ClipOval(
                      child: Material(
                        color: CustomColors.firebaseGrey.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: CustomColors.firebaseGrey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      "${user.email}",
                      style: TextStyle(color: CustomColors.firebaseOrange, fontSize: 15),
                    )
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
                color:Color(0xFF2C384A),
            ),

          ),
          ListTile(
            leading: const Icon(
              Icons.logout,),
            title: const Text('Logout'),
            onTap: () => {Navigator.of(context).pushReplacement(_routeToSignInScreen())},
          ),
          ListTile(
            leading:const Icon(Icons.search_off_sharp),
            title: const Text('website'),
            onTap: () => {Navigator.of(context).pop(_launchURL())},
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.cog),
            title: const Text('Settings'),
            onTap: () => {
              Navigator.of(context).pop(),

            } ),


        ],
      ),
    );
  }

}
_launchURL() async {
  const url = 'https://ussd.kvm.co.tz/';

    await launch(url, forceWebView: true,forceSafariVC: true,enableJavaScript: true);

}

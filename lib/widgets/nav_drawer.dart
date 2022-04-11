
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plwha/res/custom_colors.dart';

import '../helperfunctions/sharedpref_helper.dart';


class NavDrawer extends StatelessWidget {
   NavDrawer({Key key,User user})
      : _user = user,
        super(key: key);

  final User _user;
  String myName, myProfilePic, myUserName, myEmail;

  getMyInfoFromSharedPreference() async {
    User _user = await FirebaseAuth.instance.currentUser;
    myName = _user.email.toString(); //SharedPreferenceHelper().getDisplayName().toString();
    // myProfilePic =  SharedPreferenceHelper().getUserProfileUrl();
    // myUserName =  SharedPreferenceHelper().getUserName();
    // myEmail =  SharedPreferenceHelper().getUserEmail();

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
                  style: TextStyle(color: Colors.white, fontSize: 20),
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
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: CustomColors.firebaseGrey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      "${myEmail}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
            leading: const Icon(FontAwesomeIcons.commentAlt),
            title: const Text('Private Messages'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading:const Icon(FontAwesomeIcons.building),
            title: const Text('Resources'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.cog),
            title: const Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),

        ],
      ),
    );
  }

}
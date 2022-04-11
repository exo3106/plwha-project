import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plwha/res/custom_colors.dart';
import 'app_bar_title.dart';

class ChatAppBarUI extends StatelessWidget{
  const ChatAppBarUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return AppBar(
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
                        Icon(FontAwesomeIcons.user, size: 18,),
                        SizedBox(width: 5,),
                        Text(" PLWHA Groups"),
                      ]
                  ),
                ),

                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(FontAwesomeIcons.infoCircle, size: 18,),
                        SizedBox(width: 5,),
                        Text(" Broadcast"),
                      ]
                  ),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(FontAwesomeIcons.infoCircle, size: 18,),
                        SizedBox(width: 5,),
                        Text(" About PLWHA"),
                      ]
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                User user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  _showGroupDialog(context);
                }
              } else if (value == 1) {

              } else if (value == 2) {
                _showMyDialog(context);
              }
              try {} on Exception catch (_, e) {

              }
            }
        ),
      ],
    );

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
              child: Text('Close', style: TextStyle(
                  color: CustomColors.firebaseBackground
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showGroupDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Group'),
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
              child: Text('Close',style: TextStyle(
                color: CustomColors.firebaseBackground,
              ),
              ),
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
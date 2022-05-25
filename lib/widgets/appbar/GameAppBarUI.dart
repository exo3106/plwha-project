import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamka/res/custom_colors.dart';

import '../searchbar/search_bar.dart';
import 'app_bar_title.dart';

class GameAppBarUI extends StatelessWidget{
  const GameAppBarUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return
      AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.comments,size: 18, color: CustomColors.firebaseOrange,),

            Text("\t Forums", style: TextStyle(fontSize: 18, color: CustomColors.firebaseYellow,),),
          ],
        ),
        actions:
        <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SearchPage()
                      ));
                },
                child: const Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )
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
          title: const Text('Game Profile'),
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

}

import 'package:flutter/material.dart';

import '../res/custom_colors.dart';

class GameScreenUI extends StatelessWidget{
  const GameScreenUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: CustomColors.firebaseBackground,
      body: Container(
        child: Text("Game",style: TextStyle(color: CustomColors.firebaseNavy),),
      ),
    );
  }
}
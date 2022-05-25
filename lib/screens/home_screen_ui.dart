import 'package:flutter/material.dart';
import 'package:tamka/res/custom_colors.dart';

import '../views/home_plwha.dart';

class HomeScreenUI extends StatelessWidget{
  const HomeScreenUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: CustomColors.firebaseBackground,
      body: PLWHA(),
    );
  }
}
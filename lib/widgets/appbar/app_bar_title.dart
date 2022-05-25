import 'package:flutter/material.dart';

import '../../res/custom_colors.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logo-white.png',
          height: 30,
        ),
        Text("PLWHA", style: TextStyle(fontSize: 18, color: CustomColors.firebaseYellow,fontWeight: FontWeight.bold)),
      ],
    );
  }
}

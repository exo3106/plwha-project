import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:plwha/widgets/searchbar/chatroom_search_bar.dart';
import 'package:plwha/widgets/searchbar/create_new_chat.dart';
import '../res/custom_colors.dart';

class NormalChatTab extends StatefulWidget {
  const NormalChatTab ({Key key}) : super(key: key);

  @override
  _NormalChatTabState createState() => _NormalChatTabState();
}

class _NormalChatTabState extends State<NormalChatTab> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavyLight,
      floatingActionButton: _getFAB(),
        body:Container(
          child: Text("Normal Chat"),
        ),
      );
  }
  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22,color: CustomColors.firebaseBackground),
      backgroundColor: CustomColors.firebaseNavy,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(Icons.search),
            backgroundColor: CustomColors.firebaseNavy,
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) =>  SearchChat() //ChatSearchPage(user: _user )
                  ));
            },
            label: 'Search for a Chat',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: CustomColors.firebaseNavy),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: CustomColors.firebaseNavy,
            onTap: () {
                Navigator.of(context).push(
                MaterialPageRoute(builder: (_) =>  CreateSearchChat() //ChatSearchPage(user: _user )
                ));

              setState(() {
                _counter = 0;
              });
            },
            label: 'New Message',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: CustomColors.firebaseNavyLight)
      ],
    );
  }
}

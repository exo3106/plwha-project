import 'package:flutter/material.dart';
import 'package:tamka/res/custom_colors.dart';

import '../../screens/forum_screen/chat_page.dart';
// import 'package:group_chat_app/pages/chat_page.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;

  GroupTile({this.userName, this.groupId, this.groupName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName,)));
      },
      child:
      Container(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Card(
        child: ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: CustomColors.firebaseNavy,
            child: Text(groupName.substring(0, 2).trim(), textAlign: TextAlign.center, style: TextStyle(color: CustomColors.firebaseOrange)),
          ),
          title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join the conversation as $userName", style: TextStyle(fontSize: 13.0)),
        ),),
      ),
    );
  }
}
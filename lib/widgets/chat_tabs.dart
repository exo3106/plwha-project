import 'package:flutter/material.dart';
import 'package:tamka/widgets/private_chat_widget.dart';

class ChatTabs extends StatefulWidget {
  const ChatTabs({Key key}) : super(key: key);

  @override
  _ChatTabsState createState() => _ChatTabsState();
}

class _ChatTabsState extends State<ChatTabs> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 2,
        child: Scaffold(
          body:
              PrivateChatTab()
        ),
      );
  }


}

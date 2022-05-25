import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../res/custom_colors.dart';


import '../widgets/chat_tabs.dart';

class ChatScreenUI extends StatefulWidget {
  const ChatScreenUI({Key key}):
        super(key: key);


  @override
  ChatScreenUIState createState() => ChatScreenUIState();

}

class ChatScreenUIState extends State<ChatScreenUI>{
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      // backgroundColor: CustomColors.firebaseBackground,
      body: ChatTabs(),
    );
  }


  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}


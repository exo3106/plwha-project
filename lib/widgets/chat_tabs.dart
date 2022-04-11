import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plwha/res/custom_colors.dart';
import 'package:plwha/services/auth.dart';
import 'package:plwha/widgets/forum_widget.dart';
import 'package:plwha/widgets/private_chat_widget.dart';
import '../screens/home_screen.dart';

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
          backgroundColor: CustomColors.firebaseNavy,
          appBar: PreferredSize(

              preferredSize: const Size.fromHeight(50),
                child: AppBar(
                  backgroundColor: CustomColors.firebaseNavy,
                    bottom: const TabBar(

                      tabs: [
                        Tab(text:"Forum",),
                        Tab(text:"Private Chat",),
                      ],
                    ),
                  )
          ),
          body: const TabBarView(
            children: [
              NormalChatTab(),
              PrivateChatTab()
            ],
          ),
        ),
      );
  }


}

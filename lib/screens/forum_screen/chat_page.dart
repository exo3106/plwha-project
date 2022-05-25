import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tamka/res/custom_colors.dart';
// import 'package:group_chat_app/services/database_service.dart';
// import 'package:group_chat_app/widgets/message_tile.dart';

import '../../services/database_service.dart';
import '../../widgets/forum_widget/message_tile.dart';

class ChatPage extends StatefulWidget {

  final String groupId;
  final String userName;
  final String groupName;

  ChatPage({
    this.groupId,
    this.userName,
    this.groupName
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isJoined = false;
  User _user = FirebaseAuth.instance.currentUser;


  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();
  _joinValueInGroup(String userName, String groupId, String groupName) async {
    bool value = await DatabaseService(uid: _user.uid).isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }
  Widget _chatMessages(){
    _joinValueInGroup(widget.userName, widget.groupId, widget.groupName,);
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return MessageTile(
              message: snapshot.data.docs[index]["message"],
              sender: snapshot.data.docs[index]["sender"],
              sentByMe: widget.userName == snapshot.data.docs[index]["sender"],
            );
          }
        )
        :
        Container();
      },
    );
  }

  _sendMessage() async {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      await DatabaseService(uid: _user.uid).togglingGroupJoin(widget.groupId, widget.groupName,widget. userName);
      if(_isJoined) {
        setState(() {
          _isJoined = !_isJoined;
        });
        // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);


      }
      else {
        setState(() {
          _isJoined = !_isJoined;
        });
      }

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color:CustomColors.firebaseOrange,fontWeight: FontWeight.bold,fontSize: 14)),
        centerTitle: false,
        backgroundColor: Colors.black87,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Row(
                  children: <Widget>[
                    Expanded(child: TextFormField(
                      controller: messageEditingController,
                      minLines: 1,

                      // style: TextStyle(fontSize: 15.0,height: 2),
                      keyboardType: TextInputType.multiline,

                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "send a message",
                        fillColor: Colors.white10,
                        prefixIcon:Icon(FontAwesomeIcons.m, color: CustomColors.firebaseNavy,),
                        // filled: true,
                        // border: OutlineInputBorder(
                        //   // borderSide: BorderSide(width: 0),
                        //   gapPadding: 10,
                        //   // borderRadius: BorderRadius.horizontal(),
                        // )
                      ),
                    )),
                    // Expanded(
                    //   child: TextField(
                    //     controller: messageEditingController,
                    //     style: TextStyle(
                    //       color: Colors.white
                    //     ),
                    //     decoration: InputDecoration(
                    //       hintText: "Send a message ...",
                    //       hintStyle: TextStyle(
                    //         color: CustomColors.firebaseNavy,
                    //         fontSize: 16,
                    //       ),
                    //       border: InputBorder.none
                    //     ),
                    //   ),
                    // ),

                    SizedBox(width: 12.0),

                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: CustomColors.firebaseNavy,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(child: Icon(Icons.send, color: CustomColors.firebaseYellow)),
                      ),
                    )
                  ],
                ),
              ),

          ],
        ),
      ),
    );
  }
}

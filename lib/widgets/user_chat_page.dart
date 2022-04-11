import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plwha/res/custom_colors.dart';

import '../helperfunctions/sharedpref_helper.dart';
import '../services/database.dart';
import '../views/chatscreen.dart';
// Search Page
class UserChatPage extends StatefulWidget {
  UserChatPage({Key key}) : super(key: key);

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

getChatRoomIdByUsernames(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

class _UserChatPageState extends State<UserChatPage> {
  final bool _validate = false;
  final _controller = TextEditingController();
  String myName, myProfilePic, myUserName, myEmail;
  Stream usersStream, chatRoomsStream;
  String userdata;

  getMyInfoFromSharedPreference() async {
    User user = FirebaseAuth.instance.currentUser;
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = user.email;
    setState(() {});
  }
  getCurrentUserInfo () async {

    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection("users").doc(user.uid).get().then(
            (DocumentSnapshot userdoc){
          userdata = userdoc.get("is_staff").toString();
          // userId = userdoc.get("username").toString();
        }
    );
    setState(() {

    });
  }
  Widget searchListUserTile({String profileUrl, BuildContext context ,name, username, email}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUsernames(myUserName, username);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, username]
        };
        DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        print(username);
        print(name);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(myUserName, name)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                profileUrl,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(name), Text(email)])
          ],
        ),
      ),
    );
  }
  Widget searchUsersList() {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            print(ds["email"]);
            return searchListUserTile(
                context: context,
                profileUrl: ds["imgUrl"],
                name:ds['name'],
                email: ds["email"],
                username: ds["username"]);
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
  onChatPageLoad() async {
    setState(() {});
    usersStream = await DatabaseMethods()
        .getAllUsers();
    setState(() {});
  }
  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    await onChatPageLoad();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
          backgroundColor: CustomColors.firebaseNavy,
          // The search area here
          title: Text("Users"),

      ),
        body: Container(
          child: searchUsersList(),
        )
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUsername);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";
  String myName, myProfilePic, myUserName, myEmail;

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }
  getThisUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUsername, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    print(
        "something bla bla ${querySnapshot.docs[0].id} ${querySnapshot.docs[0]["name"]}  ${querySnapshot.docs[0]["imgUrl"]}");
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username, name)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipOval(
              child: Material(
                color: CustomColors.firebaseGrey.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.person,
                    size: 15,
                    color: CustomColors.firebaseGrey,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${name}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3),
                Text(widget.lastMessage)
              ],
            )
          ],
        ),
      ),
    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tamka/helperfunctions/helper_functions.dart';
import '../res/custom_colors.dart';
import '../services/database_service.dart';
import '../widgets/forum_widget/group_tile.dart';
class ForumScreenUI extends StatefulWidget {
  @override
  _ForumScreenUIState createState() => _ForumScreenUIState();
}

class _ForumScreenUIState extends State<ForumScreenUI> {

  // data
  // final AuthService _auth = AuthService();
  // FirebaseUser _user;
  User _user= FirebaseAuth.instance.currentUser;

  String _groupName;
  String _userName = '';
  String _email = '';
  Stream _groups;


  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }


  // widgets
  Widget noGroupWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  _popupDialog(context);
                },
                child: Icon(Icons.add, color: CustomColors.firebaseOrange, size: 45.0,),



            ),
            SizedBox(height: 20.0),
            Text("You've not joined any thread, tap on the 'add' icon to create a discussion or search for threads by tapping on the search button below."),
          ],
        )
    );
  }



  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data['groups'] != null) {
            // print(snapshot.data['groups'].length);
            if(snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = snapshot.data['groups'].length - index - 1;
                    return GroupTile(userName: snapshot.data['username'], groupId: _destructureId(snapshot.data['groups'][reqIndex]), groupName: _destructureName(snapshot.data['groups'][reqIndex]));
                  }
              );
            }
            else {
              return noGroupWidget();
            }
          }
          else {
            return noGroupWidget();
          }
        }
        else {
          return Center(
              child: CircularProgressIndicator()
          );
        }
      },
    );
  }


  // functions
  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
  }


  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }


  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }


  void _popupDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = TextButton(
      child: Text("Create", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: CustomColors.firebaseAmber),),
      onPressed:  () async {
        if(_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {

            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });
          Navigator.of(context).pop();

        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Start a Thread", style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: CustomColors.firebaseOrange),),
      content: TextField(
          onChanged: (val) {
            _groupName = val;
          },
          style: TextStyle(
              fontSize: 15.0,
              height: 2.0,
              color: Colors.black
          )
      ),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: CustomColors.firebaseOrange, size: 35.0),
        backgroundColor:CustomColors.firebaseNavy,
        elevation: 0.0,
      ),
    );
  }
}


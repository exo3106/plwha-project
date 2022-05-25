import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tamka/res/custom_colors.dart';
import '../../helperfunctions/helper_functions.dart';
import '../../screens/forum_screen/chat_page.dart';
import '../../services/database_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  // data
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  QuerySnapshot returnResultSnapshot;
  bool isLoading = false;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String _userName = '';
  User _user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  // initState()
  @override
  void initState() {
    super.initState();
    _getCurrentUserNameAndUid();
    _returnAll();
  }


  // functions
  _getCurrentUserNameAndUid() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
    _user = await FirebaseAuth.instance.currentUser;
  }


  _initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchByName(searchEditingController.text).then((snapshot) {
        searchResultSnapshot = snapshot;
        //print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
    else{
      _returnAll();
    }

  }

  _returnAll() async {

      setState(() {
        isLoading = true;
      });
      await DatabaseService().returnAllGroup().then((snapshot) {
        returnResultSnapshot = snapshot;
        //print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          hasUserSearched = false;
        });
      });
    }




  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueAccent,
          duration: Duration(milliseconds: 1500),
          content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0)),
        )
    );
  }

  _joinValueInGroup(String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseService(uid: _user.uid).isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }


  // widgets
  Widget groupList() {
    return hasUserSearched ?
    ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: searchResultSnapshot.docs.length,
        itemBuilder: (context, index) {
          return groupTile(
            _userName,
            searchResultSnapshot.docs[index]["groupId"],
            searchResultSnapshot.docs[index]["groupName"],
            searchResultSnapshot.docs[index]["recentMessage"],
          );
        }
    )
        :

    ListView.builder(
        physics: NeverScrollableScrollPhysics(),
         shrinkWrap: true,

         itemCount: returnResultSnapshot.docs.length,
         itemBuilder: (context, index) {
           return Container( child: groupTile(
             _userName,
             returnResultSnapshot.docs[index]["groupId"],
             returnResultSnapshot.docs[index]["groupName"],
             returnResultSnapshot.docs[index]["recentMessage"],
           )
           );
         }

     );
  }


  Widget groupTile(String userName, String groupId, String groupName, String admin){
    _joinValueInGroup(userName, groupId, groupName, admin);
    return Card(
      child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: CircleAvatar(
          radius: 20.0,
          backgroundColor: CustomColors.firebaseNavy,
          child: Text(groupName.substring(0, 1).toLowerCase(), style: TextStyle(color: CustomColors.firebaseAmber))
      ),
      title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(admin, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold,),overflow: TextOverflow.ellipsis,),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName)));

        },
    ),
    );
  }


  // building the search page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black87,
        title: Text('Threads', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: CustomColors.firebaseOrange)),
      ),
      body:
      // isLoading ? Container(
      //   child: Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // )
      // :

      Container(

        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                          hintText: "Search thread...",
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: (){
                        _initiateSearch();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: CustomColors.firebaseNavy,
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: Icon(Icons.search, color: CustomColors.firebaseAmber)
                      )
                  )
                ],
              ),
            ),

            Expanded(child: Container(

              child:isLoading ? Center(child: CircularProgressIndicator()) :SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child:
                  groupList()

              ),
            ))


                ],
        ),
      ),
    );
  }
}

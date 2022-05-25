import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../res/custom_colors.dart';
import '../screens/seachScreen.dart';
import '../screens/sign_in_screen.dart';
import '../views/chatscreen.dart';

class PrivateChatTab extends StatefulWidget {
  const PrivateChatTab ({Key key}) : super(key: key);


  @override
  _PrivateChatTabState createState() => _PrivateChatTabState();
}

class _PrivateChatTabState extends State<PrivateChatTab> {
  bool isSearching = false;
  String userdata ="";
  bool _isSigningOut = false;


  TextEditingController searchUsernameEditingController =
  TextEditingController();

  final _user = FirebaseAuth.instance.currentUser;


  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      /*
      * Creating the app bar with a
      * lending icon (top-left conner)
      * app title (centered)
      * action button (top-right conner)
       */

      body:
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(_user.uid).collection('messages').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){

            if(snapshot.data.docs.length <1){
              return const Center(
                child: Text(
                    "No Message Available"
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index){
                  var receiverId = snapshot.data.docs[index].id;
                  var lastMsg = snapshot.data.docs[index]['last_msg'];
                  var id = snapshot.data.docs[index]['is_receiver'];
                  return
                    FutureBuilder(
                      future: FirebaseFirestore.instance.collection('users').doc(receiverId).get(),
                      builder: (context,AsyncSnapshot  asyncSnapshot){
                        if(asyncSnapshot.hasData){
                          var receiver =asyncSnapshot.data;
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                            child: Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: CustomColors.firebaseNavy,
                                  child: Text(receiver['name'].substring(0, 2).trim(), textAlign: TextAlign.center, style: TextStyle(color: CustomColors.firebaseOrange)),
                                ),
                                title: Text(receiver['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("$lastMsg", style: TextStyle(fontSize: 13.0),overflow: TextOverflow.ellipsis,),
                                trailing: id?Icon(FontAwesomeIcons.envelope,color: Colors.red,):Icon(Icons.done,color: Colors.grey,) ,
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(
                                    senderId: _user,
                                    receiverId: receiver['user_id'],
                                    senderName: receiver['name'],
                                    // senderImage: receiver['image']
                                  )
                                  ));
                                },
                              ),
                            ),

                          );
                            Card(
                              child:
                              ListTile(
                                trailing: id?Icon(FontAwesomeIcons.envelope,color: Colors.red,):Icon(Icons.done,color: Colors.grey,) ,

                                title: Text(receiver['name'],style: TextStyle( color: CustomColors.firebaseYellow,fontWeight: FontWeight.bold,fontSize: 20),),
                                subtitle: Container(
                                  child: Text("$lastMsg", style: TextStyle( color: CustomColors.firebaseGrey,fontWeight: FontWeight.normal,fontSize: 10,),overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(
                                      senderId: _user,
                                      receiverId: receiver['user_id'],
                                      senderName: receiver['name'],
                                      // senderImage: receiver['image']
                                    )
                                  ));
                                },

                              ));
                        }
                        return LinearProgressIndicator();

                      }
                  );
                });

          }
          return const Center(
            child: CircularProgressIndicator(),
          );


        },
        /*
        * this container will contain the text messaging area where sender can send a message to receiver
        * to improve code readability we created the widget in widget folder that will contain the functionality

         */


      ),
      /*
        * the floating button below is used to search friend
        * once you hit the button it will navigate to the search page so that user can type
        * for username and initiate the chat

         */

      floatingActionButton:

      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: CustomColors.firebaseYellow,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen(user: _user)));
        },

      ),


    );
  }
}


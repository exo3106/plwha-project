

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:weed/widgets/singleMessage.dart';

import '../res/custom_colors.dart';
import '../widgets/message_text_field.dart';
import '../widgets/singleMessage.dart';
// import '../widgets/message_text_field.dart';
/*
        * This is the chart screen
        * this is the screen where an individual can chart privately with a user

         */
class ChatScreen extends StatelessWidget{
  /*
        * we started with the declaration of required data for both, sender and receiver

         */
   final User senderId;
   final String receiverId;
   final String senderName;

  /*
        * create the class constructor so that it will be easy to retrieve data

         */
  ChatScreen({
     this.senderId, this.receiverId, this.senderName,
  });
  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        backgroundColor:CustomColors.firebaseNavy,
        title: Row(
          /*
        * on title we use the row widget so that it can accept many data on app bar

         */
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child:
              ClipOval(

                child: Material(
                  color: CustomColors.firebaseOrange.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: CustomColors.firebaseGrey,
                    ),
                  ),
                ),
              ),

            ),
            SizedBox(width: 5,),
            Text(senderName,style: TextStyle(fontSize: 20, color: CustomColors.firebaseOrange),)
          ],
        ),
      ),
      body: Column(

        children: [
          /*
        * the first container is where the message will be displayed

         */
          Expanded(child: Container(

            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                // color: CustomColors.firebaseNavy,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                )

            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(senderId.uid).collection('messages').doc(receiverId).collection('chats').orderBy('date', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  if(snapshot.data.docs.length <1){
                    return const Center(
                      child: Text(
                          "say hi"
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        bool isMe = snapshot.data.docs[index]['senderId'] ==senderId.uid;
                        return SingleMessage(
                            message: snapshot.data.docs[index]['message'],
                            isMe: isMe,
                            date:timeago.format(DateTime.tryParse(snapshot.data.docs[index]['date'].toDate().toString())).toString() );
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
          )
          ),
          MessageTextField(senderId: senderId.uid, receiverId: receiverId),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../res/custom_colors.dart';
/*
        * in this screen we implement the message text field

         */
class MessageTextField extends StatefulWidget{
  /*
        * Declare the sender and receiver variable

         */
   final String senderId;
   final String receiverId;

  /*
        * ASSIGN VARIABLE INTO CLASS CONSTRUCTOR

         */
  MessageTextField({
     this.senderId, this.receiverId

});
  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField>{
  //declare the _message variable
  TextEditingController _message =TextEditingController();
  @override
  Widget build(BuildContext context){
    return
      Row(

        children: [
          Expanded(child: TextFormField(
            controller: _message,
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
          SizedBox(width: 10,),
          GestureDetector(
            onTap: ()async{
              /*
        * Here now we implement the sending message function
        * we need to send message to the firestore database
        *  here is a single user can have a message to one receive with multiple chat and vice vesa is tru

         */
              // step 1. get the message entered by user, and clean the text field
              String message =_message.text;
              _message.clear();

              // step 2 save the sender  message to firebase store, we created a new collection "message" which hold the user id and the chats docs which hold the chats
              await FirebaseFirestore.instance.collection('users').doc(widget.senderId).collection('messages').doc(widget.receiverId).collection('chats').add(
                {"senderId": widget.senderId,
                  "receiverId": widget.receiverId,
                  "message":message,
                  "type": "text",
                  "date": DateTime.now()


                }
              ).then((value){
                FirebaseFirestore.instance.collection('users').doc(widget.senderId).collection('messages').doc(widget.receiverId).set({
                  "last_msg": message,
                  "is_receiver": false
                }
                );
              });
              // step 2 save the receiver  message to firebase store, we created a new collection "message" which hold the user id and the chats docs which hold the chats
              await FirebaseFirestore.instance.collection('users').doc(widget.receiverId).collection('messages').doc(widget.senderId).collection('chats').add(
                  {"senderId": widget.senderId,
                    "receiverId": widget.receiverId,
                    "message":message,
                    "type": "text",
                    "date": DateTime.now()


                  }
              ).then((value){
                // save the last message so that it will be easy to fetch data
                FirebaseFirestore.instance.collection('users').doc(widget.receiverId).collection('messages').doc(widget.senderId).set({
                  "last_msg": message,
                  "is_receiver": true
                }
                );
              });

            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.firebaseNavy,

              ),
              child: Icon(Icons.send, color: CustomColors.firebaseOrange,),
            ),
          )
        ],


    );
  }
}
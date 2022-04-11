import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserField{
  static const String lastMessageTime = 'lastMessageTime';
}

class UserData{
  String userID;
  String email;
  String name;
  Timestamp lastMessageTime;

  UserData({
    this.userID,
    this.email,
    this.name,
    this.lastMessageTime
  });

  static UserData fromJson (Map<String, dynamic> json)=>UserData(
    userID: json['uid'],
    email: json['email'],
    name: json['name'],
    lastMessageTime: json['lastMessageTime'],

  );
  Map<String,dynamic> toJson()=>{
    'uid': userID,
    'email': email,
    'name': name,
    'lastMessageTime': lastMessageTime,
  };

}
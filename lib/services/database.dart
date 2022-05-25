import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tamka/helperfunctions/sharedpref_helper.dart';

class DatabaseMethods {

  // Future<Stream<QuerySnapshot>> getAllUser() async{
  //   return FirebaseFirestore.instance
  //       .collection("users").snapshots();
  // }
  //
  // Future<Stream<QuerySnapshot>> getAllUsers() async{
  //   return FirebaseFirestore.instance
  //       .collection("users")
  //       .where("is_staff",isEqualTo:true).snapshots();
  // }
  // static Future addUserInfoToDB(
  //     String userId, Map<String, dynamic> userInfoMap) async {
  //   return FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(userId)
  //       .set(userInfoMap);
  // }
  //
  // Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
  //   return FirebaseFirestore.instance
  //       .collection("users")
  //       .where("username", isEqualTo: username)
  //       .snapshots();
  // }
  //
  // Future addMessage(
  //     String chatRoomId, String messageId, Map messageInfoMap) async {
  //   return FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .doc(chatRoomId)
  //       .collection("chats")
  //       .doc(messageId)
  //       .set(messageInfoMap);
  // }
  //
  // updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
  //   return FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .doc(chatRoomId)
  //       .update(lastMessageInfoMap);
  // }
  //
  // createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
  //   final snapShot = await FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .doc(chatRoomId)
  //       .get();
  //
  //   if (snapShot.exists) {
  //     // chatroom already exists
  //     return true;
  //   } else {
  //     // chatroom does not exists
  //     return FirebaseFirestore.instance
  //         .collection("chatrooms")
  //         .doc(chatRoomId)
  //         .set(chatRoomInfoMap);
  //   }
  // }
  //
  // Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
  //   return FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .doc(chatRoomId)
  //       .collection("chats")
  //       .orderBy("ts", descending: true)
  //       .snapshots();
  // }
  //
  // Future<Stream<QuerySnapshot>> getChatRooms() async {
  //   String myUsername = await SharedPreferenceHelper().getUserName();
  //   return FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .orderBy("lastMessageSendTs", descending: true)
  //       .where("users", arrayContains: myUsername)
  //       .snapshots();
  // }
  //
  // Future<Stream<QuerySnapshot>> getOrganisationChatRooms() async {
  //   String user="mu-fol";
  //   return FirebaseFirestore.instance
  //       .collection("chatrooms")
  //       .orderBy("lastMessageSendTs", descending: true)
  //       .where("username", isEqualTo: user)
  //       .snapshots();
  // }
  // Future<QuerySnapshot> getUserInfo(String username) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("username", isEqualTo: username)
  //       .get();
  // }
  //
  // Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> getcurrentUserInfo() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(user.uid).snapshots();
  // }
  Future<Stream<QuerySnapshot>> getUserByUserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }
  Future<Stream<QuerySnapshot>> getAllUsers() async{
    return FirebaseFirestore.instance
        .collection("users")
        .where("is_staff",isEqualTo:true).snapshots();
  }
  static Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }
  Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await FirebaseFirestore.instance.collection("users").doc(auth.currentUser.uid).get().then(
            (DocumentSnapshot userdoc){
              return FirebaseFirestore.instance
                  .collection("chatrooms")
                  .orderBy("lastMessageSendTs", descending: true)
                  .where("users", arrayContains:  userdoc.get("username").toString())
                  .snapshots();


            }

            );

        }




  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }
}


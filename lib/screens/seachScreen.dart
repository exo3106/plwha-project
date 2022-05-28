import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../res/custom_colors.dart';
import '../views/chatscreen.dart';

class SearchScreen extends StatefulWidget{
  /*
  * now as the user must be logged in to access this page
  * the user checked from the main page and their data is sent to this page
  * so we need to accept the sent data first
   */
  //call the user model
  const SearchScreen({Key key,User user})
      : _user = user,
        super(key: key);

  final User _user;
  //  //accept the data

  @override
  _SearchScreenState createState() => _SearchScreenState();

}

class _SearchScreenState  extends State<SearchScreen>{
  bool is_found = false;
  TextEditingController searchController =TextEditingController();

  List<Map> searchResult =[];
  bool isLoading=false;

  //create search functional method
 void onSearch()async{
   setState(() {
     isLoading =true;
   });

   await FirebaseFirestore.instance.collection('users').where("is_staff",isEqualTo: true).get().then((value){


     if(value.docs.isEmpty){
       // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No user found")));

      setState(() {
        is_found=false;

        isLoading =false;
      });
       return;
     }
     value.docs.forEach((user) {
       if(user.data()['email']!= widget._user.email){
         searchResult.add(user.data());

       }
       setState(() {
         is_found=true;

         isLoading =false;
       });
     });
   });

 }

  @override
  void initState() {
    onSearch();
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
      appBar: AppBar(
        centerTitle: true,


          title: Card(
            // width: double.infinity,
            // height: 60,
            // decoration: BoxDecoration(
            //     color: CustomColors.firebaseGrey, borderRadius: BorderRadius.circular(5)),
            child:  Center(
              child:
              TextField(
                // controller: searchController,

                decoration: InputDecoration(
                    prefixIcon:  Icon(Icons.home, color: CustomColors.firebaseOrange ,),

                    hintText: 'Organization List',

                    // focusColor: CustomColors.firebaseNavy,
                    border: InputBorder.none),
              ),
            ),
          )),
        // centerTitle: true,
        backgroundColor: CustomColors.firebaseNavy,
      body: Center(
    child: Column(
    children: [
      if(searchResult.isNotEmpty)
    Expanded(child: ListView.builder(itemCount: searchResult.length,
    shrinkWrap: true, itemBuilder: (BuildContext context, int index) {

      return Card(
          child: ListTile(

            leading:
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
            title: Text(searchResult[index]['name'],
              style: TextStyle( color: CustomColors.firebaseYellow,fontWeight: FontWeight.bold,fontSize: 20),
            ),
            subtitle: Text(searchResult[index]['email'],
              style: TextStyle( color: CustomColors.firebaseGrey,fontWeight: FontWeight.normal,fontSize: 10),),
            trailing: IconButton(onPressed: ()async{
              setState(() {
                searchController.text ="";
              });
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
              ChatScreen(senderId: widget._user, receiverId: searchResult[index]['user_id'], senderName: searchResult[index]['name'])

              ));

            }, icon: Icon(Icons.message),color: CustomColors.firebaseOrange,),
          )
      );

      },

    )
    )
    else if(isLoading ==true)
      const Center(
        child: CircularProgressIndicator(),






      ),],





    )));
  }

}

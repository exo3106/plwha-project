
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tamka/screens/home_screen.dart';
import 'package:tamka/services/database.dart';
import 'package:sizer/sizer.dart';
import '../helperfunctions/sharedpref_helper.dart';
import '../res/custom_colors.dart';
import '../services/Validator.dart';
import '../services/auth.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key key}) : super(key: key);
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
   bool _validate = false;
   bool passenable = true;
   bool _isSigningIn = false;
   bool _isLoginPage = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  @override
  void initState() {
    _isLoginPage = false;
    _isSigningIn= false;
    super.initState();

    // Start listening to changes on the form fields
    //_email.addListener(_printLatestValue);
    //_pass.addListener(_printLatestValue);
  }
  @override
  void dispose() {
    _emailAddress.dispose();
    _pass.dispose();
    _validate = false;
    _isLoginPage = true;
    _isSigningIn=false;
    super.dispose();
  }

  OutlinedButton registerNewUserButton(SnackBar snackBar){
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor:MaterialStateProperty.all(Colors.redAccent),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),bottomRight:  Radius.circular(10))
          ),
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          User userInfo = await AuthMethods
              .createUserUsingEmailPassword(
              email: _emailAddress.text.trim(),
              password: _pass.text.trim(),
              context: context);

          if (userInfo != null) {
            String getUserProfile = "https://www.pinclipart.com/picdir/big/73-739007_icon-profile-picture-circle-png-clipart.png";
            Map<String, dynamic> userInfoMap = {
              "email": userInfo.email,
              "username": userInfo.email.replaceAll("@gmail.com", ""),
              "name": userInfo.email.replaceAll("@gmail.com", ""),
              "imgUrl": getUserProfile,
              "user_id":userInfo.uid,
              'groups': [],
              "is_staff": false
            };
            await DatabaseMethods.addUserInfoToDB(userInfo.uid, userInfoMap);

            setState(() {
              _isSigningIn = false;
              _isLoginPage = true;
            });


           // await DatabaseRefDoc(uid:userInfo.uid).updateUserInfo(email:userInfo.email, name:getRandomString(5).toString());
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //Send Email Verification

          }else{
            setState(() {
              _validate = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid Credentials')),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(90, 10, 90, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children:const [
            Icon(Icons.person_outlined,color: Colors.white),
            Text(' Register',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
  loginButton(SnackBar snackBar){
    return _isSigningIn ? const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    )
        : OutlinedButton(
      style: ButtonStyle(
        backgroundColor:MaterialStateProperty.all(Colors.blueAccent),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),bottomRight:  Radius.circular(10))
          ),
        ),
      ),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          User userDetails = await AuthMethods
              .signInUsingEmailPassword(
              email: _emailAddress.text.trim(),
              password: _pass.text.trim(),
              context: context);
          if (userDetails != null) {

            SharedPreferenceHelper().saveUserEmail(userDetails.email);
            SharedPreferenceHelper().saveUserId(userDetails.uid);
            SharedPreferenceHelper()
                .saveUserName(userDetails.email.replaceAll("@gmail.com", ""));
            SharedPreferenceHelper().saveDisplayName(userDetails.email.replaceAll("@gmail.com", ""));
            setState(() {
              _isSigningIn = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context)
                .pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen(user: userDetails)),
            );
          }else{
            setState(() {
              _validate = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid Credentials')),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(90, 10, 90, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children:const [
            Icon(Icons.arrow_right_alt,color: Colors.white),
            Text(' Login',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _printLatestValue() {
  //   if (kDebugMode) {
  //     print('Second text field: ${_pass.text}');
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final snackBar =  SnackBar(
      backgroundColor: CustomColors.firebaseNavyLightInput,
      content: Text('Login Successfully'+ _emailAddress.text,style: TextStyle(
          color: CustomColors.firebaseBackground
      ),),
    );
    final registerSnackBar =  SnackBar(
      backgroundColor: CustomColors.firebaseNavyLightInput,
      content: Text('You have register a new Account'+ _emailAddress.text,style: TextStyle(
          color: CustomColors.firebaseBackground
      ),),
    );
    return
      Sizer(
        builder: (context, orientation, deviceType){
          return  Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: Container(
                height:screenSize.height,
                width: screenSize.width,
                decoration: const BoxDecoration(
                    color: Color(0xFF39435F)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 50,),
                    SizedBox(
                        height:100,
                        width: 200,
                        child: Image.asset("assets/logo-white.png")
                    ),
                     SizedBox(child: Text("PLWHA FORUM", style: TextStyle(color: CustomColors.firebaseOrange, fontWeight: FontWeight.bold, fontSize: 18),),),
                    const SizedBox(height: 15,),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve:Curves.bounceInOut,
                      width: 325,
                      height: _validate? 400 : 430,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C384A),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child:Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isLoginPage = false;
                                  });
                                },
                                child: Text('Register', style:_isLoginPage? const TextStyle(
                                    fontWeight: FontWeight.normal
                                ): const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFCA28)
                                )),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isLoginPage = true;
                                  });
                                },
                                child: Text('Login',style:_isLoginPage? const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFCA28)
                                ): const TextStyle(
                                    fontWeight: FontWeight.normal
                                )),
                              )
                            ],
                          ),
                          _isLoginPage? Form(
                            key: _formKey,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 10,),
                                const Text("Login With your Credential",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),),
                                const SizedBox(height: 5,),
                                Container(
                                  padding: const EdgeInsets.only(right: 20,left: 20),
                                  child: TextFormField(
                                    controller: _emailAddress,
                                    validator: (value) => Validator.validateEmail(email:_emailAddress.text.trim()),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email_outlined,color:Color(0xFFFFCA28)),
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10),
                                            bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                      ),
                                    ),

                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Container(
                                  padding: const EdgeInsets.only(top: 10, right: 20,left: 20),
                                  child: TextFormField(
                                    controller: _pass,
                                    textInputAction: TextInputAction.done,
                                    obscureText: true,
                                    validator: (value) => Validator.validatePassword(password: _pass.text.trim()),
                                    decoration:  InputDecoration(
                                      prefixIcon: Icon(Icons.lock,color: Color(0xFFFFCA28),),
                                      labelText: 'Password',
                                      border:
                                      OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:Color(0xFFFFCA28),
                                        ),
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      loginButton(snackBar),
                                      //googleLogInWithFireBase()
                                    ],
                                  ),
                                const SizedBox(height: 15,),
                                Padding(
                                  padding:const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () async{
                                        },
                                        child:const Text("Need Help?",
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF)
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async{
                                        },
                                        child:const Text("Forget Password",
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ):
                          Form(
                            key: _formKey,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 10,),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child:Container(
                                        child:Padding(
                                            padding: EdgeInsets.all(10),
                                            child:const Text("HINT\nIn order to improve privacy, do not use personal email \nUse any email even if it's not exist ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                    decoration: BoxDecoration(
                                      color:CustomColors.firebaseNavyLight,
                                      borderRadius: BorderRadius.all(Radius.circular(7)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Container(
                                  padding: const EdgeInsets.only(right: 20,left: 20),
                                  child: TextFormField(
                                    controller: _emailAddress,
                                    validator: (value) => Validator.validateEmail(email:_emailAddress.text.trim()),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email_outlined,color:Color(0xFFFFCA28)),
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10),
                                            bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                      ),
                                    ),

                                  ),
                                ),
                                const SizedBox(height: 5,),
                                Container(
                                  padding: const EdgeInsets.only(top: 10, right: 20,left: 20),
                                  child: TextFormField(
                                    controller: _pass,
                                    textInputAction: TextInputAction.done,
                                    obscureText: true,
                                    validator: (value) => Validator.validatePassword(password: _pass.text.trim()),
                                    decoration:  InputDecoration(
                                      prefixIcon: Icon(Icons.lock,color: Color(0xFFFFCA28),),
                                      labelText: 'Password',
                                      border:
                                      OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:Color(0xFFFFCA28),
                                        ),
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(10),topRight:Radius.circular(10),bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                                      ),
                                      // suffix:
                                      // IconButton(onPressed: (){
                                      //   setState(() {
                                      //     if(passenable){
                                      //       passenable=false;
                                      //     }
                                      //     else{
                                      //       passenable=true;
                                      //     }
                                      //   });
                                      // }, icon: Icon(passenable? Icons.remove_red_eye:Icons.password)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding:const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      registerNewUserButton(registerSnackBar),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                Padding(
                                  padding:const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () async{
                                        },
                                        child:const Text("Need Help?",
                                          style: TextStyle(
                                              color: Color(0xFFFFFFFF)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }
}

class DatabaseRefDoc {

  final String uid;

  DatabaseRefDoc({this.uid});
  final refDocument = FirebaseFirestore.instance.collection('users');
  //User Update Info to FireStore
  Future updateUserInfo({ String email, String name}) async {
    await refDocument.doc(uid).set({
      'userId':uid,
      'email':email,
      'name': name,
    });
  }

}


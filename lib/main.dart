import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plwha/screens/home_screen.dart';
import 'package:plwha/screens/sign_in_screen.dart';
import 'package:plwha/services/auth.dart';
import 'package:plwha/views/home_chat.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    FirebaseOptions firebaseOptions = const FirebaseOptions(
      appId: '1:482794916970:android:d7bfcdcfb489c79db50e13',
      apiKey: 'AIzaSyBMOn4Loxi9KRVREIgqk4PFF8nTbPHHv3Y',
      projectId: 'plwha-68e4e',
      messagingSenderId: '482794916970',
    );
    await Firebase.initializeApp(
        options: firebaseOptions
    );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PLWHA App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: FutureBuilder(
        future: AuthMethods().getCurrentUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
    );
  }
}

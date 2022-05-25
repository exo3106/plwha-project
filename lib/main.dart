import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tamka/services/auth.dart';
import 'package:tamka/views/splash_screen.dart';
import 'package:tamka/views/splash_screen2.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    FirebaseOptions firebaseOptions = const FirebaseOptions(
      appId: '1:482794916970:android:d7bfcdcfb489c79db50e13',
      apiKey: 'AIzaSyBMOn4Loxi9KRVREIgqk4PFF8nTbPHHv3Y',
      projectId: 'plwha-68e4e',
      messagingSenderId: '482794916970',
      storageBucket:'plwha-68e4e.appspot.com'
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
            return Splash();
          } else {
            return  Splash2();
          }
        },
      ),
    );
  }
}

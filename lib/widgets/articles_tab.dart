import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';

class ArticlesTab extends StatefulWidget {
  const ArticlesTab ({Key key}) : super(key: key);


  @override
  _ArticlesTabState createState() => _ArticlesTabState();
}
class _ArticlesTabState extends State<ArticlesTab>{
  List<PostModel> books =[];
  Reference storageRef =  FirebaseStorage.instance.ref().child('articles');
  @override
  void initState(){
    listArticles();
    super.initState();
  }



  /* Function to list articles files from firestore */
  Future<Widget> listArticles() async {

    final storageRef = FirebaseStorage.instance.ref().child("articles");
    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {
      // The prefixes under storageRef.
      // You can call listAll() recursively on them.
      return  Future.value(
          ListTile(
          leading: Icon(Icons.list),
          trailing: Text("GFG",
            style: TextStyle(
                color: Colors.green,fontSize: 15),),
          title:Text('${prefix.name}')
      ));
    }

  }
  @override
  Widget build(BuildContext context){
    return Container(
      height: 200,
      child: FutureBuilder(
        future: listArticles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return Container(
              width: 10,
              height: 10,

              child:CircularProgressIndicator()
          );
        },
      )
    );
  }
}

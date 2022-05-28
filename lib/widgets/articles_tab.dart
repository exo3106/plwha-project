import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/firebase_file.dart';
import '../screens/image_page.dart';
import '../services/database_service.dart';

class ArticlesTab extends StatefulWidget {
  const ArticlesTab ({Key key}) : super(key: key);


  @override
  _ArticlesTabState createState() => _ArticlesTabState();
}
class _ArticlesTabState extends State<ArticlesTab> {
  List<PostModel> books = [];
  Future<List<FirebaseFile>> futureFiles = FirebaseApi.listAll('articles/');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 200,
      child: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Some error occurred!'));
              } else {
                final files = snapshot.data;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          return buildFile(context, file);
                        },
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) =>
      ListTile(
        leading: SizedBox(
          height:30,
          width: 30,
            child:Image.asset("assets/file-icon.png")
        ),
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () =>
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ImagePage(file: file),
            )),
      );
}
import 'package:flutter/material.dart';
import 'package:plwha/data/data.dart';
import 'package:plwha/models/book_model.dart';
import 'package:plwha/models/single_post_model.dart';
import 'package:plwha/res/widgets.dart';
import 'package:readmore/readmore.dart';
import '../data/data.dart';
import '../models/book_model.dart';
import '../models/single_post_model.dart';
import '../widgets/image_carousel.dart';
import 'posts_details.dart';

String slectedCategorie = "All";

class PLWHA extends StatefulWidget {
  @override
  _PLWHAState createState() => _PLWHAState();
}

class _PLWHAState extends State<PLWHA> {

  List<String> categories = ["All","Videos","Popular Articles"];

  List<PostModel> books =[];
  List<SinglePostModel> singleeBooks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    books = getBooks();
    singleeBooks = getSingleBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
          child: Container(
        color: Color(0xffF2F5F9),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16,),
              Carousel(),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                child: ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index){
                      return CategorieTile(
                        text: categories[index],
                        isSelected: slectedCategorie == categories[index],
                      );
                    }),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                    itemCount: books.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index){
                      return PostTile(
                        imgAssetPath: books[index].imgAssetPath,
                        rating: books[index].rating,
                        title: books[index].title,
                        description: books[index].description,
                        category: books[index].categorie,
                      );
                    }),
              ),
              SizedBox(height: 16,),
              Text("Articles and Publications", style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
              ),),
              SizedBox(height: 12,),
              Container(
                height: 250,
                child: ListView.builder(
                    itemCount: singleeBooks.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index){
                      return SingleBookTile(
                        title: singleeBooks[index].title,
                        categorie: singleeBooks[index].categorie,
                        imgAssetPath: singleeBooks[index].imgAssetPath,
                      );
                    }),
              )
            ],
          ),
        ),
      )
      ),
    );
  }
}

class CategorieTile extends StatefulWidget {

  final String text;
  final bool isSelected;
  CategorieTile({this.text, @required this.isSelected});

  @override
  _CategorieTileState createState() => _CategorieTileState();
}

class _CategorieTileState extends State<CategorieTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 12),
              child: Text(widget.text, style: TextStyle(
                  color: widget.isSelected ? Colors.black87 : Colors.grey,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: widget.isSelected ? 23 : 18
              ),),
            ),
            SizedBox(height: 3,),
            widget.isSelected ? Container(
              height: 5,
              width: 16,
              decoration: BoxDecoration(
                  color: Color(0xff007084),
                  borderRadius: BorderRadius.circular(12)
              ),
            ) : Container()
          ],
        )
    );
  }
}

class PostTile extends StatelessWidget {

  final String imgAssetPath,title,description, category;
  final int rating;
  PostTile({@required this.rating,@required this.description,
    @required this.title,@required this.category, @required this.imgAssetPath});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => BookDetails()
        ));
      },
      child: Container(
        height: 200,
        margin: EdgeInsets.only(right: 16),
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: <Widget>[
            Container(
              height: 180,
              alignment: Alignment.bottomLeft,
              child: Container(
                  height:  MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width - 80,
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 110,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 220,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(title, style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                            ),),
                            SizedBox(height: 10,),
                            Text(description, style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13
                            ),),
                            Spacer(),
                            Row(
                              children: <Widget>[
                                StarRating(
                                  rating: rating,
                                ),
                                Spacer(),
                                Text(category,style: TextStyle(
                                    color: Color(0xff007084)
                                ),)
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
            Container(
              height: 180,
              margin: EdgeInsets.only(left: 12,
                top: 0,),
              child: Image.asset(imgAssetPath, height: 120,width: 100,
                fit: BoxFit.contain,),
            )
          ],
        ),
      ),
    );
  }
}

class SingleBookTile extends StatelessWidget {

  final String title,categorie, imgAssetPath;
  SingleBookTile({this.title,this.categorie,this.imgAssetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(imgAssetPath, height: 170,fit: BoxFit.fitHeight,) ,
          ReadMoreText(
              title, style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 10
              ),
            trimLines: 2,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(categorie, style: TextStyle(
              color: Color(0xff007084),
              fontSize: 13
          ),)
        ],
      ),
    );
  }
}

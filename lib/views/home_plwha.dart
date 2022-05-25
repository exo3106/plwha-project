import 'package:flutter/material.dart';
import 'package:tamka/data/data.dart';
import 'package:tamka/models/single_post_model.dart';
import 'package:tamka/widgets/articles_tab.dart';
import 'package:readmore/readmore.dart';
import '../data/data.dart';
import '../models/single_post_model.dart';
import '../res/custom_colors.dart';
import '../widgets/video_tab.dart';
import 'carousel_home.dart';

class PLWHA extends StatefulWidget {
  @override
  _PLWHAState createState() => _PLWHAState();
}

class _PLWHAState extends State <PLWHA> with SingleTickerProviderStateMixin {

  TabController tabController;

  List<SinglePostModel> singleeBooks = [];

  @override
  void initState() {
    // TODO: implement initState
    tabController =  TabController(length:2 ,vsync: this);
    super.initState();

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
              CarouselHome(),
              SizedBox(height: 30,),
              TabBar(
                  controller:tabController,
                  labelColor: CustomColors.firebaseNavy,
                  unselectedLabelColor: CustomColors.firebaseNavyLight,
                  tabs: [
                    Tab(text:"Videos",),
                    Tab(text:"Articles",),
                  ],
                ),
                SizedBox(
                height:200,
                child:TabBarView(
                      controller: tabController,
                        children:[
                            VideosTab(),
                            ArticlesTab()
                        ]
                    ),
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

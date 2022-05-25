import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class CarouselHome extends StatefulWidget {
  CarouselHome({Key key}) : super(key: key);
  Stream carouselData;
  @override
  _CarouselHomeState createState() => _CarouselHomeState();
}


class _CarouselHomeState extends State<CarouselHome> {
  final Stream<QuerySnapshot> _streamImages = FirebaseFirestore.instance.collection('images').snapshots();
  final storageRef = FirebaseStorage.instance.ref().child("images");


  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      child: StreamBuilder(
          stream: _streamImages,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container( child: Center(child:CircularProgressIndicator()));
            } else {
                return Container(
                      width: 150,
                      height:200,
                      child: CarouselSlider(
                      options: CarouselOptions(height: 400.0),
                      items: snapshot.data.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child:Image.network(data['img'],fit: BoxFit.cover, width: 1000)
                            );
                          },
                        );
                      }).toList(),
                    )
                );
              }
            }
      ),
    );
  }
}
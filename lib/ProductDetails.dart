import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/PhotoScreen/ImageViewer.dart';
import 'package:e_commerce/Payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DetailsTable.dart';
class ProductDetails extends StatefulWidget {
  String productId;
  String productName;
  @override
  ProductDetails({this.productId,this.productName});
  _ProductDetailsState createState() => _ProductDetailsState(productId: productId,productName: productName);
}

class _ProductDetailsState extends State<ProductDetails> {

  String productId;
  String productName;
  List<dynamic> imageUrls=[];


  static const rowStyle=TextStyle(fontSize: 16,color: Colors.black);
  String title="Payment Easy";
  TextEditingController controller= TextEditingController();

  //Firebase variable
  var _firestore=FirebaseFirestore.instance;

  _ProductDetailsState({this.productId,this.productName});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text("Product Details",
            style: TextStyle(
                color: Colors.white
            ),)
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Card(
                elevation: 9,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        productName,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87
                        ),),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
              child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('productDetails').snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasData) {
                  final productDetails = snapshot.data.docs;
                    for (var eachDetail in productDetails) {
                      if(eachDetail.id==productId)
                        imageUrls=eachDetail.get('imageUrls');
                    }
                  }
                return Card(
                  elevation: 9,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(22)
                      ),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                      margin: EdgeInsets.all(5),
                      height: 400,
                      child: CarouselSlider(
                        options:CarouselOptions(
                          height: 380,
                          aspectRatio: 0.25,
                          autoPlayInterval:Duration(seconds: 15),
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          autoPlay: true,
                        ),
                        items:[
                          for (var imageUrl in imageUrls)
                            buildImageViewer(context,imageUrl),
                        ],
                      )
                  ),
                );
                }

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
              child: DetailsTable(productId:productId,productName:productName),
            ),
            Container(
              margin: EdgeInsets.all(15),
              height:100,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: RaisedButton(
                    onPressed:(){
                      Navigator.push(context,MaterialPageRoute(builder: (_){
                        return PaymentScreen();
                      }));
                    },
                    color: Colors.lightBlue[900],
                    child:Text("Place Order",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent
                      ),)),
              ),
            ),
          ],
        ),
      ),
    );;
  }

  GestureDetector buildImageViewer(BuildContext context,String imageUrl) {
    return GestureDetector(
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (_){
                          return HeroAnimation1(url: imageUrl);
                        }));
                      },
                      child:Column(children: [
                        Expanded(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.fill,
                            width: double.maxFinite,
                            height: double.maxFinite,
                            filterQuality: FilterQuality.high,
                            loadingBuilder: (BuildContext context,
                                Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress
                                      .expectedTotalBytes !=
                                      null
                                      ? loadingProgress
                                      .cumulativeBytesLoaded /
                                      loadingProgress
                                          .expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ])
                    );
  }
}



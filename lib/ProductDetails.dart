import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/PhotoScreen/ImageViewer.dart';
import 'package:e_commerce/Payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:badges/badges.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

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
  int price;
  double oldPrice;
  double offer;
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
          backgroundColor: Theme.of(context).primaryColor,
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
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
              child: Container(
                margin: EdgeInsets.all(5),
                child: Badge(
                  elevation: 7,
                  toAnimate: false,
                  shape: BadgeShape.square,
                  badgeColor: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  badgeContent: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        productName,
                        style: TextStyle(
                          fontFamily: 'YuseiMagic',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white
                        ),),
                    ),
                  ),
                ),
              ),
            ),
            //carousel slider
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('productDetails').snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasData) {
                  final productDetails = snapshot.data.docs;
                    for (var eachDetail in productDetails) {
                      if(eachDetail.id==productId) {
                        price = eachDetail.get('Price');
                        offer = eachDetail.get('Offer');
                        oldPrice = eachDetail.get('OldPrice');
                        imageUrls = eachDetail.get('imageUrls');
                      }
                    }
                  }
                else{
                  CircularProgressIndicator();
                }
                return Card(
                  shadowColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                  ),
                  elevation: 9,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(22)
                      ),
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      margin: EdgeInsets.all(5),
                      height: 400,
                      child: CarouselSlider(
                        options:CarouselOptions(
                          height: 380,
                          aspectRatio: 0.25,
                          autoPlayInterval:Duration(seconds: 5),
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
            //badges
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child:StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('productDetails').snapshots(),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    final productDetails = snapshot.data.docs;
                    for (var eachDetail in productDetails) {
                      if (eachDetail.id == productId) {
                        price = eachDetail.get('Price');
                        offer = eachDetail.get('Offer');
                        oldPrice = eachDetail.get('OldPrice');
                      }
                    }
                  }
                  return Column(
                    children: [
                      //price,offer and old price
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Container(
                                height:50,
                                child: Badge(
                                  elevation: 7,
                                  toAnimate: false,
                                  shape: BadgeShape.square,
                                  badgeColor: Colors.black87,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(25)
                                  ),
                                  badgeContent: Center(
                                    child:
                                    Text(
                                        '₹ ' + price.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        color: Colors.white
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Container(
                                height:50,
                                width:100,
                                child: Badge(
                                  elevation: 7,
                                  toAnimate: false,
                                  shape: BadgeShape.square,
                                  badgeColor: Colors.yellow,
                                  borderRadius: BorderRadius.circular(16),
                                  badgeContent: Center(
                                    child: Text('- '+
                                        offer.toString()+' %',
                                        style: TextStyle(
                                          fontSize: 20,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: Container(
                                height:40,
                                width:80,
                                child: Badge(
                                  elevation: 7,
                                  toAnimate: false,
                                  shape: BadgeShape.square,
                                  badgeColor: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8),
                                  badgeContent: Center(
                                    child: Text(
                                        '₹ ' + oldPrice.toString(),
                                        style: TextStyle(
                                            decoration: TextDecoration.lineThrough,
                                            fontSize: 17,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // assured product and rating badges
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Container(
                              height:40,
                              width:200,
                              child: Badge(
                                toAnimate: false,
                                shape: BadgeShape.square,
                                badgeColor: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(8),
                                badgeContent: Center(
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.tag_fill,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      Text(
                                          '  Our Assured Product', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16,
                                          color: Colors.white)
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Container(
                              height:40,
                              width:60,
                              child: Badge(
                                toAnimate: false,
                                shape: BadgeShape.square,
                                badgeColor: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8),
                                badgeContent: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                          '  4 ', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16,
                                          color: Colors.white)
                                      ),
                                      Icon(
                                        CupertinoIcons.star_circle_fill,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }
              )
            ),
            //details
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              child: DetailsTable(productId:productId,productName:productName),
            ),
            //button
            Container(
              margin: EdgeInsets.all(15),
              height:100,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: RaisedButton(
                    onPressed:(){
                      Navigator.push(context,MaterialPageRoute(builder: (_){
                        return PaymentScreen(productId: productId,productName: productName,price: price,);
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
                      child:Container(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: imageUrl,
                        )
                        ),
                    );
  }
}



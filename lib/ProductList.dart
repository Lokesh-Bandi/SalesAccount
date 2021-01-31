import 'package:flutter/material.dart';
import 'package:e_commerce/DisplayCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class ProductList extends StatefulWidget {
  String screenName;

  ProductList({this.screenName});

  _ProductListState createState() => _ProductListState(screenName);
}

class _ProductListState extends State<ProductList> {
  String productId;
  String productName;
  String offeredBy ;
  double offer ;
  double oldPrice ;
  int price ;
  int rating ;
  String screenName;
  var currentTime;
  String imageUrl =
      "https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/193845/01/fnd/IND/fmt/png/Softride-Rift-Slip-On-Men's-Running-Shoes";
  List<String> reviews;
  final _firestore = FirebaseFirestore.instance;

  _ProductListState(this.screenName);

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Text(
              screenName,
              style: TextStyle(color: Colors.white),
            )),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('productDetails').orderBy('Time',descending: true).snapshots(),
                  builder: (context, snapshot) {
                    List<DisplayCard> displayCards = [];
                    if (snapshot.hasData) {
                      final displayData = snapshot.data.docs;
                      for (var eachProduct in displayData) {
                        productId=eachProduct.id;
                        productName = eachProduct.get('Name');
                        offeredBy = eachProduct.get('OfferedBy');
                        price = eachProduct.get('Price');
                        offer = eachProduct.get('Offer');
                        oldPrice = eachProduct.get('OldPrice');
                        imageUrl = eachProduct.get('imageUrls')[0];
                        final displayCardWidget = DisplayCard(
                          productId: productId,
                          productName: productName,
                          offeredBy: offeredBy,
                          price: price,
                          offer: offer,
                          oldPrice: oldPrice,
                          imageUrl: imageUrl,
                        );
                        displayCards.add(displayCardWidget);
                      }
                    }
                      return Column(
                          children: displayCards
                      );
                  },
                ),
              ],
            )
        )
    );
  }
}

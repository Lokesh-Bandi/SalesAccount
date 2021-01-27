import 'package:flutter/material.dart';
import 'package:e_commerce/DisplayCard.dart';

// ignore: must_be_immutable
class ProductList extends StatefulWidget {
  String screenName;

  ProductList({this.screenName});

  _ProductListState createState() => _ProductListState(screenName);
}

class _ProductListState extends State<ProductList> {
  String productName = "Reebok casual wear for men and women by fort follies";
  String offeredBy = "fort follies";
  double offer = 40;
  double oldPrice = 2599;
  int price = ((40 / 100) * 2599).round();
  int rating = 3;
  String screenName;
  String imageUrl =
      "https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/193845/01/fnd/IND/fmt/png/Softride-Rift-Slip-On-Men's-Running-Shoes";
  List<String> reviews;

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
                DisplayCard(
                  productName: productName,
                  offeredBy: offeredBy,
                  price: price,
                  offer: offer,
                  oldPrice: oldPrice,
                  rating: rating,
                  imageUrl: imageUrl,
                  reviews: reviews,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
                  height: 320,
                  width: double.maxFinite,
                  child: Card(
                    elevation: 9,
                  ),
                ),
              ],
            )));
  }
}

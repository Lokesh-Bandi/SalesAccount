import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/ProductDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/MyBag.dart';
import 'package:loading_animations/loading_animations.dart';
// ignore: must_be_immutable
class DisplayCard extends StatefulWidget {
  String productId;
  String productName;
  String offeredBy;
  int price;
  double offer;
  double oldPrice;
  String imageUrl;
  List<String> reviews;


  DisplayCard(
      {Key key,
        this.productId,
        this.productName,
        this.offeredBy,
        this.price,
        this.offer,
        this.oldPrice,
        this.imageUrl,
        this.reviews})
      : super(key: key);

  @override
  _DisplayCardState createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  var unsaved=Icon(CupertinoIcons.heart);

  var saved=Icon(CupertinoIcons.heart_fill);

  var isSaved=false;

  String ratingFunction(int rating) {
    String full = "★";
    String empty = "☆";
    String result = "";
    int i;
    for (i = 1; i <= rating; i++) {
      result = result + full;
    }
    if (i <=5) {
      for (i = rating + 1; i <= 5; i++) {
        result = result + empty;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ProductDetails(productId: this.widget.productId,productName:this.widget.productName);
          }));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          shadowColor: Colors.yellowAccent,
          elevation: 9,
          child: Container(
            padding: EdgeInsets.fromLTRB(3, 5, 3, 5),
            height: 320,
            width: double.maxFinite,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Wrap(children: [
                        Text(
                          widget.productName,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold,fontFamily: 'YuseiMagic'),
                        ),
                      ]),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                          child: Container(
                            child: Column(children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: widget.imageUrl,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                    ),
                                  ),
                                  ),
                                  placeholder: (context, url) => Center(
                                      child: LoadingBouncingGrid.circle(
                                        size: 30,
                                        backgroundColor: Color(0xfffca9e4),
                                    )
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ])
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.maxFinite,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "By "+widget.offeredBy,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black,fontFamily: 'EBGaramond'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "₹${widget.price}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:5.0,horizontal: 1),
                                child: Text(
                                  "OFFER ${widget.offer}%",
                                  style: TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:5.0,horizontal: 1),
                                child: Text(
                                  "₹${widget.oldPrice}",
                                  style: TextStyle(
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              // SizedBox(
                              //   height: 28
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "View >>",
                                  style: TextStyle(
                                    fontFamily: 'EBGaramond',
                                      letterSpacing: 3,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              IconButton(
                                  icon: isSaved?saved:unsaved,
                                  onPressed:(){
                                      setState(() {
                                        if (isSaved==true){
                                          isSaved=false;
                                        }
                                        else{
                                          isSaved=true;

                                        }
                                      });
                              })
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

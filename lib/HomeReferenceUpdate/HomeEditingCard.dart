import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animations/loading_animations.dart';

class HomeEditingCard extends StatelessWidget {
  var _firestore=FirebaseFirestore.instance;
  String screenName='';
  String sareeType='Name';
  String imageUrl="https://firebasestorage.googleapis.com/v0/b/ecommerce-cec80.appspot.com/o/SareeTypes%2Fimage_picker5766300265020068825.jpg?alt=media&token=b89ad7a3-7d3c-4529-ac21-b59254c2a0e7";
  HomeEditingCard({this.sareeType,this.imageUrl});
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: GestureDetector(
        onLongPress: (){
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context){
                return AlertDialog(
                  title:Text("Do you want to delete?"),
                  content: Image.asset(
                      'Images/tenor.gif',
                      height:60,
                      width: 60
                  ),
                  elevation: 30.0,
                  backgroundColor: Colors.white,
                  actions: [
                    FlatButton(
                      child:Text(
                        'No',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.teal
                        ),
                      ),
                      onPressed:() {Navigator.pop(context);},
                    ),
                    FlatButton(
                      child:Text(
                        'Yes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red
                        ),
                      ),
                      onPressed:() async{
                        await for (var snapshot in _firestore.collection('SareeTypes').snapshots()) {
                          for (var eachType in snapshot.docs) {
                            if(eachType.get('Saree Type')==this.sareeType){
                              await _firestore.collection('SareeTypes').doc(eachType.id).delete();
                              Navigator.pop(context);
                            }
                          }
                        }
                      },
                    ),
                  ],
                );
              }
          );
        },
        child: Card(
          elevation: 9,
          child: Container(
            height: 200,
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end:Alignment.centerRight,
                colors: [Colors.white24,
                  Colors.white54
                ]
              )
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl:
                          imageUrl,
                          imageBuilder:
                              (context, imageProvider) =>
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                          placeholder: (context, url) =>
                              Center(
                                  child: LoadingFlipping
                                      .square(
                                    borderColor: Color(0xfffca9e4),
                                    size: 30.0,
                                    backgroundColor:
                                    Color(0xfffca9e4),
                                  )),
                          errorWidget:
                              (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ])
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Text(sareeType,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


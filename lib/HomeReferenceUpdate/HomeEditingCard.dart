import 'package:e_commerce/ProductList.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return ProductList(screenName: this.sareeType);
          }));
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
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                          width: double.maxFinite,
                          height: double.maxFinite,
                          filterQuality: FilterQuality.medium,
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


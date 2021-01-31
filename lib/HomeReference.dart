import 'package:flutter/material.dart';
import 'package:e_commerce/ProductList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeReference extends StatefulWidget {
  @override
  _HomeReferenceState createState() => _HomeReferenceState();
}

class _HomeReferenceState extends State<HomeReference> {
  List<SareesTypes> sareeList;
  final _firestore = FirebaseFirestore.instance;
  bool isLoading;

  void initState() {
    super.initState();
    sareeList = [];
    setState(() {
      isLoading = true;
    });
    getSareeTypes();
  }

  //getting data from firebase
  void getSareeTypes() async {
    await for (var snapshot
        in _firestore.collection('SareeTypes').snapshots()) {
      for (var eachType in snapshot.docs) {
        var temp = SareesTypes(
            name: eachType.get('Saree Type'),
            imageUrl: eachType.get('ImageUrl'));
        sareeList.add(temp);
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Text(
              "HomeReference",
              style: TextStyle(color: Colors.white),
            )),
        body: GridView.builder(
          itemCount: sareeList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8.0 / 12.0,
            crossAxisCount: 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ProductList(screenName: sareeList[index].name);
                    }));
                  },
                  child: Card(
                      elevation: 15,
                      semanticContainer: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              width: double.maxFinite,
                              child: Column(children: [
                                Expanded(
                                  child: Image.network(
                                    sareeList[index].imageUrl,
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
                              ]),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                sareeList[index].name,
                                style: TextStyle(fontSize: 18.0),
                              )),
                        ],
                      )),
                ));
          },
        ));
  }
}

class SareesTypes {
  String name;
  String imageUrl;

  SareesTypes({@required this.name, @required this.imageUrl});
}

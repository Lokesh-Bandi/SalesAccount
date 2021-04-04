import 'package:e_commerce/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/ProductList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeReference extends StatefulWidget {
  @override
  _HomeReferenceState createState() => _HomeReferenceState();
}

class _HomeReferenceState extends State<HomeReference> {
  List<SareesTypes> sareeList;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          _firebaseAuth.currentUser.photoURL,
                        ),
                      ),
                      title: Text(
                        _firebaseAuth.currentUser.displayName,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'YuseiMagic',
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text(_firebaseAuth.currentUser.phoneNumber.toString()),
                    ),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(15),bottomRight: Radius.circular(15))
                        ),
                        height: 30,
                        width: 150,
                        child: Center(child: Text('View Profile',style: TextStyle(fontFamily: 'Lobster',fontWeight: FontWeight.bold,fontSize: 15),)),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(color: Colors.teal[300]),
              ),
              ListTile(
                leading: Icon(
                  Icons.shopping_bag_rounded,
                  size: 30,
                ),
                title: Text('My Bag'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.contact_mail,
                  size: 30,
                ),
                title: Text('Contact us'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.feedback,
                  size: 30,
                ),
                title: Text('Feedback'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, size: 30),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Do you want to logout?"),
                          content: Image.asset('Images/tenor.gif',
                              height: 60, width: 60),
                          elevation: 30.0,
                          backgroundColor: Colors.white,
                          actions: [
                            FlatButton(
                              child: Text(
                                'No',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.teal),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.red),
                              ),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('alreadyVisited');
                                await _firebaseAuth.signOut().then((_) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return LoginScreen();
                                  }));
                                });
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
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
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ProductList(screenName: sareeList[index].name);
                    }));
                  },
                  child: Card(
                      shadowColor:(index%3==0) ?Colors.pinkAccent:((index%3==1?Colors.deepPurpleAccent:Colors.yellowAccent)),
                      elevation: 9,
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
                                  child: CachedNetworkImage(
                                    imageUrl: sareeList[index].imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                sareeList[index].name,
                                style: TextStyle(
                                    fontSize: 16.0, fontFamily: 'YuseiMagic',fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Center(
                                child: Text(
                                  'View all  >',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Lemonada',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ))
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

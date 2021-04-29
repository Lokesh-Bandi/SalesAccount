import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/ProductList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/GoogleMaps.dart';
import 'package:e_commerce/CurrentPosition.dart';
import 'package:badges/badges.dart';
import 'package:getwidget/getwidget.dart';


class HomeReference extends StatefulWidget {
  @override
  _HomeReferenceState createState() => _HomeReferenceState();
}

class _HomeReferenceState extends State<HomeReference> {
  List<SareesTypes> sareeList;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading;

  var deliveryAddress;

  final List<String> carouselImages = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
  ];

  final List<String> todayStories = [
    "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg"
  ];

  void initState() {
    super.initState();
    sareeList = [];

    setState(() {
      isLoading = true;
    });
    getSareeTypes();
    getPosition();
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

  void getPosition() async {
    CurrentPosition position = CurrentPosition();
    deliveryAddress = await position.determinePosition();
    setState(() {});
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
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                      height: 30,
                      width: 150,
                      child: Center(
                          child: Text(
                        'View Profile',
                        style: TextStyle(
                            fontFamily: 'Lobster',
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )),
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
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return SimpleMap();
                }));
              },
              tooltip: 'Current Location',
              icon: Icon(CupertinoIcons.location))
        ],
      ),
      body: PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          ListView(
            children: [
              Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    child: GFCarousel(
                      items: carouselImages.map(
                            (url) {
                          return Container(
                            margin: EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  width: 1000.0
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      aspectRatio: 17/8,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      pagination: true,
                      pagerSize: 8,
                      passiveIndicator: Colors.grey,
                      activeIndicator: Color(0xfffca9e4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:3.0,left:12.0,right:12.0,bottom: 0),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Text(
                              'Today Stories',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                letterSpacing: 2,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                          SizedBox(width: 150),
                          Text(
                            'view all >>',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                letterSpacing: 1,
                                decoration: TextDecoration.underline,
                                color: Color(0xfffca9e4),
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:0,horizontal:12.0),
                    child: SizedBox(
                      width: 250,
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ),
                  GFItemsCarousel(
                    rowCount: 4,
                    itemHeight: 90,
                    children: todayStories.map(
                          (url) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal:5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            child:
                            Image.network(url, fit: BoxFit.cover, width: 1000.0),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0,left:12.0,right:12.0,bottom: 0),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Text(
                            'New Arrivals',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              letterSpacing: 2,
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                          SizedBox(width: 160),
                          Text(
                            'view all >>',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              letterSpacing: 1,
                                decoration: TextDecoration.underline,
                                color: Color(0xfffca9e4),
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:0,left:12.0,right:12.0,bottom: 0),
                    child: SizedBox(
                      width: 250,
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ),
                  GFItemsCarousel(
                    rowCount: 4,
                    itemHeight: 105,
                    children: todayStories.map(
                          (url) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal:5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            child:
                            Image.network(url, fit: BoxFit.cover, width: 1000.0),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0,left:12.0,right:12.0,bottom: 0),
                    child: SizedBox(
                      child: Row(
                        children: [
                          Text(
                            'Top rated',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                          SizedBox(width: 190),
                          Text(
                            'view all >>',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                letterSpacing: 1,
                                decoration: TextDecoration.underline,
                                color: Color(0xfffca9e4),
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:0,horizontal:12.0),
                    child: SizedBox(
                      width: 250,
                      child: Divider(
                        thickness: 2,
                      ),
                    ),
                  ),
                  GFItemsCarousel(
                    rowCount: 3,
                    itemHeight: 130,
                    children: todayStories.map(
                          (url) {
                        return Container(
                          margin: EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            child:
                            Image.network(url, fit: BoxFit.cover, width: 1000.0),
                          ),
                        );
                      },
                    ).toList(),
                  )
                ],
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                        height: 35,
                        child: Badge(
                          elevation: 7,
                          toAnimate: false,
                          shape: BadgeShape.square,
                          badgeColor: Color(0xfff4deee),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25)),
                          badgeContent: Center(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Text('Delivery Address : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black54)),
                                Text(deliveryAddress ?? 'Loading...',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black54)),
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
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
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return ProductList(
                                    screenName: sareeList[index].name);
                              }));
                            },
                            child: Card(
                                shadowColor: (index % 3 == 0)
                                    ? Colors.pinkAccent
                                    : ((index % 3 == 1
                                        ? Colors.deepPurpleAccent
                                        : Colors.yellowAccent)),
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
                                              imageUrl:
                                                  sareeList[index].imageUrl,
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
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
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
                                              fontSize: 16.0,
                                              fontFamily: 'YuseiMagic',
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Center(
                                          child: Text(
                                            'View all  >',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
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
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SareesTypes {
  String name;
  String imageUrl;

  SareesTypes({@required this.name, @required this.imageUrl});
}

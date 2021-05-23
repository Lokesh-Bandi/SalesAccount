import 'package:salesaccount/HomeReferenceUpdate/InsertHomeReference.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salesaccount/HomeReferenceUpdate/HomeEditingCard.dart';

import 'InsertDeleteHomePage.dart';

class EditableHomeReference extends StatefulWidget {
  @override
  _EditableHomeReferenceState createState() => _EditableHomeReferenceState();
}

class _EditableHomeReferenceState extends State<EditableHomeReference> {
  var sareeType = '';
  String imageUrl;
  final _firestore = FirebaseFirestore.instance;

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "HomeReference",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('SareeTypes').snapshots(),
              builder: (context, snapshot) {
                List<HomeEditingCard> itemcards = [];
                if (snapshot.hasData) {
                  final displayData = snapshot.data.docs;
                  for (var eachProduct in displayData) {
                    sareeType = eachProduct.get('Saree Type');
                    imageUrl=eachProduct.get('ImageUrl');
                    var temp =HomeEditingCard(sareeType: sareeType,imageUrl: imageUrl);
                    itemcards.add(temp);
                }
              }
                return Column(
                    children: itemcards
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_){
              return InsertHomeReference();
            })
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                title: Text("Home"),
                icon: Icon(Icons.home)
            ),
            BottomNavigationBarItem(
                title: Text("Send"),
                icon: Icon(Icons.send)
            )
          ],
          elevation: 9,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
    );
  }

}


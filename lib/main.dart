import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:e_commerce/HomeReference.dart';

void main() {
  runApp(MaterialApp(home: SafeArea(child: HomePage())));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Text(
              "Home",
              style: TextStyle(color: Colors.white),
            )),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: RaisedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_){
                        return HomeReference();
                      }));
                    },
                    child: Text("Click"),
                  ),
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
            )
        )
    );
  }
}

// ignore: must_be_immutable

import 'package:e_commerce/DataInsert.dart';
import 'package:e_commerce/HomeReferenceUpdate/EditableHomeReference.dart';
import 'package:e_commerce/main.dart';
import 'package:flutter/material.dart';
class InsertDeleteHomePage extends StatefulWidget {
  @override
  _InsertDeleteHomePageState createState() => _InsertDeleteHomePageState();
}

class _InsertDeleteHomePageState extends State<InsertDeleteHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
        "Insert & Delete",
        style: TextStyle(color: Colors.white),
    )),
    body: Center(
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.grey,Colors.white54]
          )
        ),
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_){
                      return EditableHomeReference();
                    })
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 230,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors: [Colors.white,Colors.greenAccent]
                        )
                    ),
                    child: Center(child: Text("Update HomeReference",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),)),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_){
                      return DataInsert();
                    })
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 230,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors: [Colors.white,Colors.greenAccent]
                        )
                    ),
                    child: Center(child: Text("Insert",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),)),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_){
                      return HomePage();
                    })
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 230,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                            colors: [Colors.white,Colors.redAccent]
                        )
                    ),
                    child: Center(child: Text("Delete",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),)),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    )
    );
  }
}

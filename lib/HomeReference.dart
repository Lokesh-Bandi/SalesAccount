import 'package:flutter/material.dart';
import 'package:e_commerce/ProductList.dart';

class HomeReference extends StatefulWidget {
  @override
  _HomeReferenceState createState() => _HomeReferenceState();
}

class _HomeReferenceState extends State<HomeReference> {
  @override
  var sareesList;
  void initState() {
    // TODO: implement initState
    super.initState();
    sareesList = {
      '1': 'Dharmavaram sarees',
      '2': 'Gadwal sarees',
      '3': 'Kalamkari sarees',
      '4': 'Mangalgiri sarees',
      '5': 'Narayanpet sarees',
      '6': 'Pochampally sarees',
      '7': 'Uppada sarees',
      '0': 'Venkatagiri sarees'
    };
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
          itemCount: sareesList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8.0 / 10.0,
            crossAxisCount: 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return ProductList(screenName: sareesList['$index']);
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
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "Images/sarees/"+sareesList['$index']+".jpg"),
                                  fit: BoxFit.fill),
                            ),
                          )),
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                sareesList['$index'],
                                style: TextStyle(fontSize: 18.0),
                              )),
                        ],
                      )),
                ));
          },
        ));
  }
}

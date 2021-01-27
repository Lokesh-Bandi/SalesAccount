import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/PhotoScreen/ImageViewer.dart';
import 'package:e_commerce/Payment.dart';
class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  static const rowStyle=TextStyle(fontSize: 16,color: Colors.black);
  String title="Payment Easy";
  TextEditingController controller= TextEditingController();
  List<String> url=["https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_1750,h_1750/global/193845/01/sv01/fnd/IND/fmt/png/Softride-Rift-Slip-On-Men's-Running-Shoes",
    "https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/193845/01/fnd/IND/fmt/png/Softride-Rift-Slip-On-Men's-Running-Shoes",
    "https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/193845/01/mod03/fnd/IND/fmt/png/Softride-Rift-Slip-On-Men's-Running-Shoes",
    "https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/193845/01/bv/fnd/IND/fmt/png/Softride-Rift-Slip-On-Men's-Running-Shoes",
    "https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_2000,h_2000/global/193845/01/sv04/fnd/IND/fmt/png/Softride-Rift-Slip-On-Men's-Running-Shoes"];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text("Product Details",
            style: TextStyle(
                color: Colors.white
            ),)
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
              child: Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color:Colors.lightBlue[900] ,
                        width: 7),
                    borderRadius: BorderRadius.circular(15)
                ),

                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      'Reebok casual wear for men and women',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87
                      ),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
              child: Container(
                  margin: EdgeInsets.all(5),
                  height: 400,
                  decoration: BoxDecoration(
                      border:Border.all(
                          color: Colors.lightBlue[900],
                          width: 7
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: CarouselSlider(
                    options:CarouselOptions(
                      height: 380,
                      aspectRatio: 0.25,
                      autoPlayInterval:Duration(seconds: 15),
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: true,
                    ),
                    items:[
                      GestureDetector  (
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (_){
                            return HeroAnimation1(url: url[0]);
                          }));
                        },
                        child:Image(
                          image:NetworkImage(url[0]),
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (_){
                            return HeroAnimation1(url: url[1]);
                          }));
                        },
                        child: Image(image: NetworkImage(url[1])),
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (_){
                            return HeroAnimation1(url: url[2]);
                          }));
                        },
                        child: Image(image: NetworkImage(url[2])),
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (_){
                            return HeroAnimation1(url: url[3]);
                          }));
                        },
                        child: Image(image: NetworkImage(url[3])),
                      ),
                      GestureDetector(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (_){
                            return HeroAnimation1(url: url[4]);
                          }));
                        },
                        child: Image(image: NetworkImage(url[4])),
                      )
                    ],
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
              child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border:Border.all(
                          color: Colors.lightBlue[900],
                          width: 7
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: DataTable(
                    dividerThickness: 2,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Description',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ],
                    rows: const <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Product Name:',style: rowStyle)),
                          DataCell(Text('Reebok casual wear for men and women',style: rowStyle)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Colour:',style: rowStyle,)),
                          DataCell(Text('BlueGrey',style: rowStyle)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Size:',style: rowStyle)),
                          DataCell(Text('9 [UK]',style: rowStyle)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Price:',style: rowStyle)),
                          DataCell(Text('₹1099',style: rowStyle)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Rating:',style: rowStyle)),
                          DataCell(Text('★★★★☆',style: rowStyle)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('Offer:',style: rowStyle)),
                          DataCell(Text('NO',style: rowStyle)),
                        ],
                      ),
                    ],
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.all(15),
              height:100,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: RaisedButton(
                    onPressed:(){
                      Navigator.push(context,MaterialPageRoute(builder: (_){
                        return PaymentScreen();
                      }));
                    },
                    color: Colors.lightBlue[900],
                    child:Text("Place Order",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent
                      ),)),
              ),
            ),
          ],
        ),
      ),
    );;
  }
}

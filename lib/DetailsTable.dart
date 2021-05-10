import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DetailsTable extends StatelessWidget {

  String productId='';
  String productName='';
  String offeredBy='';
  int price;
  double oldPrice;
  double offer;
  String fabric='';
  String catalog='';
  String sareeColor='';
  String blouseColor='';
  var updatedTime;

  static const rowStyle=TextStyle(fontSize: 16,color: Colors.black);
  var _firestore=FirebaseFirestore.instance;

  DetailsTable({this.productId,this.productName});

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('productDetails').snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          final productDetails=snapshot.data.docs;
          for(var eachDetail in productDetails){
            if(this.productId==eachDetail.id) {
              productId = eachDetail.id;
              productName = eachDetail.get('Name');
              offeredBy = eachDetail.get('OfferedBy');
              price = eachDetail.get('Price');
              offer = eachDetail.get('Offer');
              oldPrice = eachDetail.get('OldPrice');
              sareeColor = eachDetail.get('Saree Color');
              blouseColor = eachDetail.get('Blouse Color');
              fabric = eachDetail.get('Fabric');
              catalog = eachDetail.get('Catalog');
              updatedTime = eachDetail.get('Time');
            }
          }
        }
        return Card(
          shadowColor: Colors.lightBlueAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22)
          ),
          elevation: 9,
          child: Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border:Border.all(
                    color: Colors.grey[700],
                    width: 3
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(22)
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dividerThickness: 2,
                columns: <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Container(
                        child: Text(
                          'Name',
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
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
                rows: <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Product Name:',style: rowStyle)),
                      DataCell(Text(productName,style: rowStyle)),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Sponsored By:',style: rowStyle)),
                      DataCell(Text(offeredBy,style: rowStyle)),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Price:',style: rowStyle)),
                      DataCell(Text('₹ '+ price.toString(),style: TextStyle(fontSize: 16,color: Colors.green,fontWeight: FontWeight.bold))),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Offer in % :',style: rowStyle)),
                      DataCell(Text(offer.toString()+' %',style:TextStyle(fontSize: 16,color: Colors.blueAccent,fontWeight: FontWeight.bold) )),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Actual Price:',style: rowStyle,)),
                      DataCell(Text('₹ '+oldPrice.toString(),style: TextStyle(fontSize: 16,color: Colors.redAccent,fontWeight: FontWeight.bold))),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Saree Color:',style: rowStyle)),
                      DataCell(Text(sareeColor,style: rowStyle)),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Blouse Color:',style: rowStyle)),
                      DataCell(Text(blouseColor,style: rowStyle)),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Fabric:',style: rowStyle)),
                      DataCell(Text(fabric,style: rowStyle)),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Catalog:',style: rowStyle)),
                      DataCell(Text(catalog,style: rowStyle)),
                    ],
                  ),
                ],
              ),
            )
            ),
        );
      },
    );
  }

}

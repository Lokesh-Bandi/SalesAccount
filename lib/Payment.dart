import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Razorpay razorpay=Razorpay();
  static const rowStyle=TextStyle(fontSize: 16,color: Colors.black);
  TextEditingController controller= TextEditingController();
  // ignore: must_call_super
  void initState(){
    super.initState();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,handlerSuccess);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,handlerWallet);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,handlerError);
  }
  void dispose(){
    super.dispose();
    razorpay.clear();
  }
  void openCheckOut(){
    var options={
      'key':'rzp_test_gjA9z87B9iEVa6',
      'amount': double.parse(controller.text)*100,
      'name':'Bandi Lokesh',
      'Description': 'Money payment to Silicon',
      'prefill':{
        'contact':'9381275562',
        'email':'lokeshbandi005@gmail.com'
      },
      'external':['paytm','phonepay']
    };
    razorpay.open(options);
  }
  void handlerSuccess(PaymentSuccessResponse response){
    print(response);
  }
  void handlerWallet(){
    print("Payment success in wallet");
  }
  void handlerError(){
    print("Payment Failed");
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color:Colors.black45,style: BorderStyle.solid)
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
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5,horizontal:10),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextField(
                    controller: controller ,
                    textAlign: TextAlign.justify,
                    keyboardType: TextInputType.number,
                    style:TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    ),
                    decoration: InputDecoration(
                        focusColor: Colors.redAccent,
                        fillColor: Colors.white,
                        hintText: "Enter the amount",
                        prefixIcon: Icon(Icons.rate_review),
                        border: OutlineInputBorder()
                    ),
                  ),
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
                    openCheckOut();
                  },
                  color: Colors.lightBlue[900],
                  child:Text("Pay",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent
                    ),)),
            ),
          ),
        ],
      ),
    );
  }
}

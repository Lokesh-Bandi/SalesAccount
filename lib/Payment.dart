import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:e_commerce/DetailsTable.dart';
import 'package:badges/badges.dart';
class PaymentScreen extends StatefulWidget {
  String productId;
  String productName;
  int price;
  PaymentScreen({this.productId,this.productName,this.price});
  _PaymentScreenState createState() => _PaymentScreenState(productId: productId,productName: productName,price:price);
}

class _PaymentScreenState extends State<PaymentScreen> {
  String productId;
  String productName;
  int price;
  _PaymentScreenState({this.productId,this.productName,this.price});
  @override
  Razorpay razorpay=Razorpay();
  TextEditingController controller= TextEditingController();
  static const rowStyle=TextStyle(fontSize: 16,color: Colors.black);
  // ignore: must_call_super
  void initState(){
    super.initState();
    controller.text=price.toString();
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
      'amount': double.parse(price.toString())*100,
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
          //product summary
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5, horizontal: 5),
            child: Container(
              height:50,
              child: Badge(
                elevation: 7,
                toAnimate: false,
                shape: BadgeShape.square,
                badgeColor: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25)
                ),
                badgeContent: Center(
                  child:
                  Text(
                      'Your Product Summary',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white
                      )
                  ),
                ),
              ),
            ),
          ),
          //product details
          DetailsTable(productId: productId,productName: productName,),
          //amount field
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5,horizontal:10),
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextFormField(
                    controller: controller,
                    enabled: false,
                    textAlign: TextAlign.justify,
                    style:TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    ),
                    decoration: InputDecoration(
                      labelText:'Product Price',
                        hintText: "Enter the amount",
                        prefixText: 'Total Amount : ₹  ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
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

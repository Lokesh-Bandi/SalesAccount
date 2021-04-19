import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/ImageWidgetConstants.dart';


class DataInsert extends StatefulWidget {
  @override
  _DataInsertState createState() => _DataInsertState();
}

class _DataInsertState extends State<DataInsert> {
  double offer;
  String sareeType;
  String clothType;
  TextEditingController productNameEditor=TextEditingController();
  TextEditingController offeredByEditor=TextEditingController();
  TextEditingController offerEditor=TextEditingController();
  TextEditingController sareeColorEditor=TextEditingController();
  TextEditingController blouseColorEditor=TextEditingController();
  TextEditingController priceEditor=TextEditingController();
  TextEditingController oldPriceEditor=TextEditingController();


  //For four images
  List<String> imageUrls =[];
  List<Icon> imageEmpty = [
    Constants.imageEmpty,
    Constants.imageEmpty,
    Constants.imageEmpty,
    Constants.imageEmpty,
  ];
  List<bool> isCamera=new List(4);
  List<bool> isLoading=[false,false,false,false];

  //firebase
  final _firestore = FirebaseFirestore.instance;
  var uploadingTime;

  //Uploading Image
  uploadImage(int imageNumber) async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      if(isCamera[imageNumber]) {
        image = await _imagePicker.getImage(source: ImageSource.camera, imageQuality: 50);
      }
      else
        image = await _imagePicker.getImage(source: ImageSource.gallery,imageQuality: 100);
      var file = File(image.path);
      if (image != null) {
        //to start cicularprogressindicator
        setState(() {
          isLoading[imageNumber] = true;
        });
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('images/${Path.basename(file.path)}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          if (downloadUrl.isNotEmpty) {
            isLoading[imageNumber]=false;
            imageUrls.add(downloadUrl);
            imageEmpty[imageNumber] = Constants.imageStatusSuccess;
          }
          else
            imageEmpty[imageNumber] = Constants.imageStatusFail;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Insert the data',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          //Names
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Product Name',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: productNameEditor,
                  autofocus: false,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  maxLines: 2,
                  maxLength: 45,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Product name"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Offered by',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: offeredByEditor,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  maxLines: 1,
                  maxLength: 25,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Offered by"),
                ),
              ],
            ),
          ),
          //Colors
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Saree colour',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: sareeColorEditor,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  maxLines: 1,
                  maxLength: 25,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter the colour"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Blouse colour',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: blouseColorEditor,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  maxLines: 1,
                  maxLength: 25,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter the colour"),
                ),
              ],
            ),
          ),
          //Pricing
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Old Price',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: oldPriceEditor,
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  maxLines: 1,
                  maxLength: 10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Old Price"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Offer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: offerEditor,
                  keyboardType: TextInputType.number,
                  autocorrect: true,
                  maxLines: 1,
                  maxLength: 3,
                  autofocus: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Offer'),
                  onChanged: (text) {
                    setState(() {
                      if (offerEditor.text.isEmpty) {
                        priceEditor.text = oldPriceEditor.text;
                        offerEditor.text = 0.toString();
                      }
                      var oldPrice=double.parse(oldPriceEditor.text);
                      offer = double.parse(offerEditor.text);
                      if (offer <= 100 && offer >= 0) {
                        priceEditor.text = ((oldPrice - (offer / 100) * oldPrice).round()).toString();
                      } else {
                        priceEditor.text = 0.toString();
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Price',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: priceEditor,
                  autofocus: true,
                  autocorrect: true,
                  enabled: false,
                  maxLines: 1,
                  maxLength: 10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: priceEditor.text),
                ),
              ],
            ),
          ),
          //DropDowns
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                child: DropdownButton<String>(
                  underline: Container(color:Colors.grey[900], height:2.0,),
                  iconSize: 25,
                  focusColor:Colors.grey,
                  value: sareeType,
                  elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: <String>[
                    'Party Wear',
                    'Full Design',
                    'Printed',
                    'Catalogue',
                    'Fancy',
                    'Georgette',
                    'Chiffon',
                    'Casual Wear',
                    'Silk',
                    'Wedding'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style:TextStyle(
                          color:Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      ),
                      ),
                    );
                  }).toList(),
                  hint:Text(
                    "Choose a saree type",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      sareeType = value;
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                child: DropdownButton<String>(
                  underline: Container(color:Colors.grey[900], height:2.0,),
                  iconSize: 25,
                  focusColor:Colors.grey,
                  value: clothType,
                  elevation: 5,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor:Colors.black,
                  items: <String>[
                    'Cotton',
                    'Pure cotton',
                    'Silk',
                    'Net',
                    'Crepe',
                    'Benaurus',
                    'seko',
                    'Gadwal',
                    'Tassaur'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style:TextStyle(
                          color:Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      ),
                      ),
                    );
                  }).toList(),
                  hint:Text(
                    "Choose a cloth type",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      clothType = value;
                    });
                  },
                ),
              ),
            ),
          ),
          //Image1
          buildImageUploadWidget(1),
          buildImageUploadWidget(2),
          buildImageUploadWidget(3),
          buildImageUploadWidget(4),
          //Proceed button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                uploadingTime=DateTime.now();
                _firestore.collection('productDetails').add({
                  'Name': productNameEditor.text,
                  'OfferedBy': offeredByEditor.text,
                  'Saree Color':sareeColorEditor.text,
                  'Blouse Color':blouseColorEditor.text,
                  'Price': int.parse(priceEditor.text),
                  'Offer': double.parse(offerEditor.text),
                  'OldPrice': double.parse(oldPriceEditor.text),
                  'Saree Type':sareeType,
                  'Cloth Type':clothType,
                  'Time':uploadingTime,
                  'imageUrls': imageUrls
                }
                );

                Navigator.pop(context);

              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white,Colors.blueAccent]
                  )
                ),
                child: Center(child: Text("Proceed",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),)),
              ),
            ),
          )
        ],
      ),
    );
  }

  Stack buildImageUploadWidget(int imageNumber) {
    return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                color: Colors.grey[200],
                child: ListTile(
                  focusColor: Colors.grey,
                  leading: GestureDetector(
                      onTap: () {
                        if(imageNumber>1) {
                          if (imageEmpty[imageNumber - 1] !=
                              Constants.imageStatusSuccess &&
                              imageEmpty[imageNumber - 2] ==
                                  Constants.imageStatusSuccess) {
                            setState(() {
                              isCamera[imageNumber - 1] = true;
                              uploadImage(imageNumber - 1);
                            });
                          }
                        }
                        else{
                          if (imageEmpty[imageNumber-1] != Constants.imageStatusSuccess) {
                            setState(() {
                              isCamera[imageNumber-1]=true;
                              uploadImage(imageNumber-1);
                            });
                          }
                        }
                      },
                      child: Icon(Icons.add_a_photo)),
                  title: Text(
                    "Image-$imageNumber",
                    textScaleFactor: 1.3,
                  ),
                  trailing: GestureDetector(
                      onTap: () {
                        if(imageNumber>1) {
                          if (imageEmpty[imageNumber - 1] !=
                              Constants.imageStatusSuccess &&
                              imageEmpty[imageNumber - 2] ==
                                  Constants.imageStatusSuccess) {
                            setState(() {
                              isCamera[imageNumber - 1] = false;
                              uploadImage(imageNumber - 1);
                            });
                          }
                        }
                        else{
                          if (imageEmpty[imageNumber-1] != Constants.imageStatusSuccess) {
                            setState(() {
                              isCamera[imageNumber-1]= false;
                              uploadImage(imageNumber-1);
                            });
                          }
                        }
                      },
                      child: imageEmpty[imageNumber-1]),
                ),
              ),
            ),
            isLoading[imageNumber-1]?Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                strokeWidth: 4,),
            ):(Center()),
          ],
        );
  }
}


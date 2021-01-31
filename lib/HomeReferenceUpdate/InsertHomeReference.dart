import 'package:e_commerce/InsertDeleteHomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/DataInsert.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
class InsertHomeReference extends StatefulWidget {
  @override
  _InsertHomeReferenceState createState() => _InsertHomeReferenceState();
}

class _InsertHomeReferenceState extends State<InsertHomeReference> {
  String imageUrl;
  var imageStatusSuccess = Icon(Icons.check, color: Colors.green, size: 30);
  var imageStatusFail = Icon(Icons.clear, color: Colors.redAccent, size: 30);
  var imageEmpty =Icon(Icons.add, color: Colors.black87, size: 30);
  bool isCamera;
  bool isLoading=false;
  final _firestore = FirebaseFirestore.instance;
  var uploadingTime;
  TextEditingController sareeTypeEditor= TextEditingController();

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      if(isCamera) {
        image = await _imagePicker.getImage(source: ImageSource.camera, imageQuality: 25);
      }
      else
        image = await _imagePicker.getImage(source: ImageSource.gallery,imageQuality: 25);
      var file = File(image.path);
      if (image != null) {
        //to start cicularprogressindicator
        setState(() {
          isLoading = true;
        });
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('SareeTypes/${Path.basename(file.path)}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          if (downloadUrl.isNotEmpty) {
            isLoading=false;
            imageUrl=downloadUrl;
            imageEmpty= imageStatusSuccess;
          }
          else
            imageEmpty = imageStatusFail;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  Stack buildImageUploadWidget() {
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
                      if (imageEmpty !=
                          imageStatusSuccess ) {
                        setState(() {
                          isCamera = true;
                          uploadImage();
                        });
                    }
                    else{
                      if (imageEmpty != imageStatusSuccess) {
                        setState(() {
                          isCamera=true;
                          uploadImage();
                        });
                      }
                    }
                  },
                  child: Icon(Icons.add_a_photo)),
              title: Text(
                "Upload Image",
                textScaleFactor: 1.3,
              ),
              trailing: GestureDetector(
                  onTap: () {
                      if (imageEmpty !=
                          imageStatusSuccess ) {
                        setState(() {
                          isCamera = false;
                          uploadImage();
                        });
                    }
                    else{
                      if (imageEmpty != imageStatusSuccess) {
                        setState(() {
                          isCamera= false;
                          uploadImage();
                        });
                      }
                    }
                  },
                  child: imageEmpty),
            ),
          ),
        ),
        isLoading?Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
            strokeWidth: 4,),
        ):(Center()),
      ],
    );
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
                    'Name of the saree type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: sareeTypeEditor,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  maxLines: 1,
                  maxLength: 35,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: "Saree type"),
                ),
              ],
            ),
          ),
          buildImageUploadWidget(),
          //Proceed button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                uploadingTime=DateTime.now();
                if(sareeTypeEditor.text.isNotEmpty && imageUrl.isNotEmpty) {
                  _firestore.collection('SareeTypes').add({
                    'Saree Type': sareeTypeEditor.text,
                    'ImageUrl': imageUrl
                  }
                  );
                  Navigator.pop(context,true);
                }

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
}

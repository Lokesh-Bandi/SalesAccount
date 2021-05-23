import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:salesaccount/ImageWidgetConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class InsertHomeReference extends StatefulWidget {
  @override
  _InsertHomeReferenceState createState() => _InsertHomeReferenceState();
}

class _InsertHomeReferenceState extends State<InsertHomeReference> {

  bool isCamera;
  bool isLoading=false;

  final firestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;
  var uploadingTime;

  TextEditingController sareeTypeEditor= TextEditingController();
  File file;
   var resultIcon;
  // ignore: non_constant_identifier_names

  void initState(){
    super.initState();
    resultIcon=Constants.imageEmpty;
  }
  CropingImage(String image) async{
    File _croppedImage= await ImageCropper.cropImage(
        sourcePath: image,
        aspectRatio: CropAspectRatio(ratioX: 1.0,ratioY: 1.25)
    );
    if(_croppedImage!=null){
      setState(() {
        file=_croppedImage;
      });

    }
  }

  uploadImage() async {

    final _imagePicker = ImagePicker();
    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      if(isCamera) {
        image = await _imagePicker.getImage(source: ImageSource.camera, imageQuality: 50);
        await CropingImage(image.path);
      }
      else {
        image = await _imagePicker.getImage(
            source: ImageSource.gallery, imageQuality: 100);
        await CropingImage(image.path);
      }
      if (image != null) {
        //to start cicularprogressindicator
        setState(() {
          isLoading = true;
        });
        //Upload to Firebase
        var snapshot = await firebaseStorage
            .ref()
            .child('SareeTypes/${Path.basename(file.path)}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          if (downloadUrl.isNotEmpty) {
            isLoading=false;
            Constants.imageUrl=downloadUrl;
            resultIcon= Constants.imageStatusSuccess;
          }
          else
            resultIcon= Constants.imageStatusFail;
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
                      if (Constants.imageEmpty !=
                          Constants.imageStatusSuccess ) {
                        setState(() {
                          isCamera = true;
                          uploadImage();
                        });
                    }
                  },
                  child: Icon(Icons.add_a_photo)),
              title: Text(
                "Upload Image",
                textScaleFactor: 1.3,
              ),
              trailing: GestureDetector(
                  onTap: () {
                      if (Constants.imageEmpty !=
                          Constants.imageStatusSuccess ) {
                        setState(() {
                          isCamera = false;
                          uploadImage();
                        });
                    }
                  },
                  child: resultIcon),
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
      body: Builder(
        builder: (context)=>ListView(
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
                  if(sareeTypeEditor.text.isNotEmpty && Constants.imageUrl.isNotEmpty) {
                    firestore.collection('SareeTypes').add({
                      'Saree Type': sareeTypeEditor.text,
                      'ImageUrl': Constants.imageUrl
                    }
                    );
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.black87,
                          content:Text('Successfully Saved',style: TextStyle(color: Colors.white70),),
                          duration: Duration(seconds: 5),
                          action: SnackBarAction(
                            textColor: Colors.greenAccent,
                            label: 'Back',
                            onPressed: (){
                             Navigator.pop(context);
                            },
                          ),

                        )
                    );
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
      ),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class HeroAnimation1 extends StatelessWidget {
  @override
  String url = "";
  HeroAnimation1({this.url});

  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: PhotoView(imageProvider: NetworkImage(url)),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

List<List<String>> items=[];
class MyBag extends StatefulWidget {
  @override
  _MyBagState createState() => _MyBagState();
}

class _MyBagState extends State<MyBag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('My Bag',
            style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder:(BuildContext context,int index){
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: items[index][0],
                imageBuilder: (context, imageProvider) =>
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
              ),
              title: Text(items[index][1]),
              subtitle: Text(items[index][2]),
              onTap: (){

              },
            );
    },
      )
    );
  }
}

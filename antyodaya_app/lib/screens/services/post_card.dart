import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Post_Card extends StatelessWidget {
  getImage(String imageUrl) {
    try {
      return CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error));
    } catch (e) {
      return null;
    }
  }

  String imageurl, name, description, phoneno;
  double lat, long;
  Post_Card(
      {this.imageurl,
      this.description,
      this.name,
      this.phoneno,
      this.lat,
      this.long});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Card(
        margin: EdgeInsets.all(15.0),
        elevation: 10.0,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(
                Icons.person,
                size: 40.0,
              ),
              title: Text("NAME: " + name),
              subtitle: Text('Phone Number: ' + phoneno),
            ),

            Container(
              child: getImage(imageurl),
            ),
            Text(
              'Description: $description',
            ),
            ElevatedButton(
              onPressed: () {},
            ),
            //Image.asset('assets/card-sample-image.jpg'),
          ],
        ),
      ),
    );
  }
}

import 'package:antyodaya_app/screens/screenNav/profile.dart';
import 'package:flutter/material.dart';

class DrawerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 200,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: DrawerHeader(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                        // //   image: DecorationImage(
                        // // image: AssetImage('assets/images/icon.png'),
                        // fit: BoxFit.fill,
                        //)
                        ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(17),
                bottomRight: Radius.circular(17),
              ),
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(thickness: 1, color: Colors.white),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: Text(
            'Profile',
            style: TextStyle(
                fontFamily: 'Montserrat SemiBold', color: Colors.white),
          ),
          onTap: () {
            return Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
        Divider(
          thickness: 1,
          color: Colors.white,
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: Text(
            'About',
            style: TextStyle(
                fontFamily: 'Montserrat SemiBold', color: Colors.white),
          ),
          onTap: () {
            bool isLender = true;
            if (isLender) {
              // return Navigator.push(context,
              // MaterialPageRoute(builder: (context) => RequestPage()));
            } else {
              // Toast.show("You have not added any bike!", context,
              //  duration: Toast.LENGTH_SHORT);
            }
            // rent requests
            // ...
          },
        ),
        Divider(thickness: 1, color: Colors.white),
      ],
    );
  }
}

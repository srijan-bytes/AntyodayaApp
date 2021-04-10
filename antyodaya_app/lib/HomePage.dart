import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:antyodaya_app/screens/screenNav/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          RaisedButton(
            child: Text("Sign Out"),
            onPressed: () {
              signOut();
            },
          )
        ],
        title: Text("HOME PAGE"),
      ),
      body: Container(
        child: !isloggedin
            ? CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Container(
                    height: 300,
                    // child: Image(
                    //   image: AssetImage("images/welcome.jpg"),
                    //   fit: BoxFit.contain,
                    // ),
                  ),
                  Container(
                    child: Text(
                      "Hello ${user.displayName} you are Logged in as ${user.email}",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // ignore: deprecated_member_use
                  // RaisedButton(
                  //   padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                  //   onPressed: signOut,
                  //   child: Text('Signout',
                  //       style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 20.0,
                  //           fontWeight: FontWeight.bold)),
                  //   color: Colors.blue,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20.0),
                  //   ),
                  // )
                ],
              ),
      ),

      //sideNav...

      drawer: Drawer(
        child: Container(
          color: Color(0xFF000000),
          child: ListView(
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
                    color: Color(0xFFFFC495),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1,
                color: Color(0xFF282833),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Color(0xFFFFC495),
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: 'Montserrat SemiBold',
                      color: Color(0xFFFFC495)),
                ),
                onTap: () {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
              Divider(
                thickness: 1,
                color: Color(0xFF282833),
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Color(0xFFFFC495),
                ),
                title: Text(
                  'About',
                  style: TextStyle(
                      fontFamily: 'Montserrat SemiBold',
                      color: Color(0xFFFFC495)),
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
              Divider(
                thickness: 1,
                color: Color(0xFF282833),
              ),

              // // /* &&&&&&   Added a test list tile for enterPrice page &&&&&&&&&&&&&&&&&*/
              // ListTile(
              //   leading: Icon(
              //     Icons.monetization_on,
              //     color: Color(0xFFFFC495),
              //   ),
              //   title: Text(
              //     'Test Price page',
              //     style: TextStyle(
              //         fontFamily: 'Montserrat SemiBold',
              //         color: Color(0xFFFFC495)),
              //   ),
              //   onTap: () {
              //     return Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => PaymentsPage(new ChatItem(
              //                 "Name", "Yantriki", "ab", "8888888888", "abb"))));
              //     // app settings
              //     // ...
              //   },
              // ),
              // Divider(
              //   thickness: 1,
              //   color: Color(0xFF282833),
              // ),
              // /* &&&&&&&&&&&&&&&&&&&&& Test list tile ends here &&&&&&&&&&&&&& */
            ],
          ),
        ),
      ),
    );
  }
}

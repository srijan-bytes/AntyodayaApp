import 'package:antyodaya_app/screens/create_post.dart';
import 'package:antyodaya_app/screens/screenNav/profile.dart';
import 'package:antyodaya_app/screens/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  String uid = "";
  String name, email, phone, address;
  bool isloggedin = false;

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

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

  List postsList = [];
  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
    fetchDatabaseList();
  }

  fetchDatabaseList() async {
    dynamic resultant = await DataBaseService().getPostsList();
    if (resultant == null) {
      print('unable to retreive');
    } else {
      setState(() {
        postsList = resultant;
      });
    }
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
        color: Colors.grey,
        child: !isloggedin
            ? CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Container(
                    child: Text(
                      "Hello ${user.displayName} you are Logged in as ${user.email}",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: postsList.length,
                          itemBuilder: (context, index) {
                            String _imageUrl = postsList[index]()['link'];

                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.arrow_drop_down_circle),
                                    title: Text(
                                        "NAME: " + postsList[index]()['name']),
                                    subtitle: Text(
                                      postsList[index]()['description'],
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ),
                                  Container(
                                    height: 400.0,
                                    width: 400.0,
                                    child: getImage(postsList[index]()['link']),
                                  ),
                                  // Container(
                                  //   width: 160,
                                  //   height: 160,
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //         width: 4,
                                  //         color: Theme.of(context)
                                  //             .scaffoldBackgroundColor),
                                  //     // boxShadow: [
                                  //     //   BoxShadow(
                                  //     //       spreadRadius: 2,
                                  //     //       blurRadius: 10,
                                  //     //       color:
                                  //     //           Colors.black.withOpacity(0.1),
                                  //     //       offset: Offset(0, 10))
                                  //     // ],

                                  //     shape: BoxShape.circle,
                                  //   ),

                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      "Location: ",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.start,
                                    children: [
                                      Text('Phone Number: ' +
                                          postsList[index]()['phoneno']),
                                      FlatButton(
                                        onPressed: () {
                                          // Perform some action
                                        },
                                        child: const Text('LOCATE'),
                                      ),
                                    ],
                                  ),
                                  //Image.asset('assets/card-sample-image.jpg'),
                                ],
                              ),
                            );
                          }))
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Upload()));
        },
        label: const Text('Donate'),
        icon: const Icon(Icons.thumb_up),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //sideNav...

      drawer: Drawer(
        child: Container(
          color: Colors.blue,
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

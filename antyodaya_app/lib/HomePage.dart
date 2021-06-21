import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:antyodaya_app/screens/create_post.dart';
import 'package:antyodaya_app/screens/maps/map_screen.dart';
import 'package:antyodaya_app/screens/services/post_card.dart';
import 'package:antyodaya_app/screens/shared/drawer_homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User user;
final _firestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        user = firebaseUser;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          ElevatedButton(
            child: Text("Sign Out"),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal[700],
            ),
            onPressed: () {
              signOut();
            },
          )
        ],
        title: Text("HOME PAGE"),
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/dark_bg.jpg'), fit: BoxFit.cover),
          ),
        ),
        Container(
          //color: Colors.grey,
          child: !isloggedin
              ? CircularProgressIndicator()
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SizedBox(
                        width: 250.0,
                        child: TextLiquidFill(
                          text: 'Hello ${user.displayName} !!',
                          waveColor: Colors.blueAccent,
                          textStyle: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                          boxHeight: 60.0,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MapScreen()));
                        },
                        child: Text("Locate On Map")),
                    PostStream(),
                  ],
                ),
        ),
      ]),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Upload()));
        },
        label: const Text('Donate'),
        icon: const Icon(Icons.thumb_up),
        backgroundColor: Colors.teal[200],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //sideNav...

      drawer: Drawer(
        child: Container(color: Colors.teal[700], child: DrawerHomePage()),
      ),
    );
  }
}

class PostStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlue,
              ),
            );
          }
          final posts = snapshot.data.docs.reversed;
          List<Post_Card> postsWidgets = [];
          for (var post in posts) {
            Map<String, dynamic> data = post.data();
            final postWidget = Post_Card(
              name: data['name'],
              description: data['description'],
              imageurl: data['link'],
              phoneno: data['phoneno'],
              lat: data['latitude'],
              long: data['longitude'],
            );
            postsWidgets.add(postWidget);
          }
          return Expanded(
              child: ListView(
            children: postsWidgets,
          ));
        });
  }
}

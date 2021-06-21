import 'package:antyodaya_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.744421, -71.1698939);
const double CAMERA_ZOOM = 15;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

final _firestore = FirebaseFirestore.instance;
Set<Marker> _markers = Set<Marker>();

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var clients = [];
  bool maptoggle = false;
  bool clientsToggle = false;
  bool resetToggle = false;

  LatLng currentLocation;
  var currentClient;
  var currentBearing;
  GoogleMapController mapController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //set up initial location
    getCurrentLocation();
    //set custom marker
    populateClients();
  }

  void populateClients() async {
    clients = [];
    await _firestore.collection('Posts').get().then((doc) {
      if (doc.docs.isNotEmpty) {
        setState(() {
          clientsToggle = true;
          for (int i = 0; i < doc.docs.length; ++i) {
            clients.add(doc.docs[i].data);
            initMarker(doc.docs[i].data, i);
          }
        });
      }
    });
  }

  initMarker(client, int i) {
    _markers.add(Marker(
        markerId: MarkerId('$i'),
        position: LatLng(client()['latitude'], client()['longitude']),
        infoWindow: InfoWindow(
          title: 'Hello',
        )));
  }

  getCurrentLocation() async {
    Position currentPosition;
    try {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      if (currentPosition != null) {
        setState(() {
          currentLocation =
              LatLng(currentPosition.latitude, currentPosition.longitude);
          maptoggle = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void setMarkerIcons() async {}

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: currentLocation,
    );
    return maptoggle
        ? Scaffold(
            body: SafeArea(
              child: GoogleMap(
                myLocationButtonEnabled: true,
                compassEnabled: false,
                tiltGesturesEnabled: false,
                markers: _markers,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(kMapStyle);
                  mapController = controller;
                },
              ),
            ),
          )
        : Center(
            child: Text(
              'Please Wait...',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          );
  }

  //   setState(() {
  //     _markers.add(Marker(
  //         markerId: MarkerId('sourcePin'),
  //         position: currentLocation,
  //         icon: sourceIcon,
  //         onTap: () {
  //           setState(() {
  //             this.userBadgeSelected = true;
  //           });
  //         }));
  //
  //     _markers.add(Marker(
  //         markerId: MarkerId('destinationPin'),
  //         position: destinationLocation,
  //         icon: destinationIcon,
  //         onTap: () {
  //           setState(() {
  //             this.pinPillPosition = PIN_VISIBLE_POSITION;
  //           });
  //         }));
  //   });
}

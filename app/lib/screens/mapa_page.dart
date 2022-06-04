import 'package:app/models/Arte.dart';
import 'package:app/models/Autor.dart';
import 'package:app/screens/infoartes_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app/services/remote_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  //API
  late List<Arte> artes;
  List<Autor>? autores;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    // fetch data from API
    getData();
  }

  getData() async {
    artes = await RemoteService().getArtes();
    if (artes != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  late Position currentPosition;
  List<Marker> _markers = [];

  var geoLocator = Geolocator();

  location() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;

      LatLng latLatPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
          new CameraPosition(target: latLatPosition, zoom: 18);
      newGoogleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      createMarker();
    } else if (status.isDenied) {
      Map<Permission, PermissionStatus> status =
          await [Permission.location].request();
      location();
      createMarker();
    }
  }

  // void locatePosition() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   currentPosition = position;

  //   LatLng latLatPosition = LatLng(position.latitude, position.longitude);

  //   CameraPosition cameraPosition =
  //       new CameraPosition(target: latLatPosition, zoom: 18);
  //   newGoogleMapController
  //       .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  // }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(38.70723439106229, -9.152428676689576),
    zoom: 14.4746,
  );

  createMarker() {
    for (int i = 0; i < artes.length; i++) {
      print("ola");
      _markers.add(Marker(
          markerId: MarkerId(artes[i].artesNome), //way points
          position: LatLng(artes[i].latitude, artes[i].longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
              title: artes[i].artesNome,
              snippet: artes[i].artesDisc,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InfoArtes(arte: artes[i])));
              })));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        markers: _markers.map((e) => e).toSet(),
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controllerGoogleMap.complete(controller);
          newGoogleMapController = controller;
          // locatePosition();
          location();
          createMarker();
        },
      ),
    );
  }
}

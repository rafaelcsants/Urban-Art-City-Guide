import 'package:app/models/Arte.dart';
import 'package:app/models/ArtebyRota.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app/services/remote_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';

import '../models/Rota.dart';

class TrajetoPage extends StatefulWidget {
  const TrajetoPage({Key? key, required this.rota}) : super(key: key);

  final Rota rota;

  @override
  _TrajetoPageState createState() => _TrajetoPageState(rota);
}

class _TrajetoPageState extends State<TrajetoPage> {
  //API
  Rota rota;
  _TrajetoPageState(this.rota);
  var isLoaded = false;

  List<Arte>? artes;
  late List<ArteByRota> arteByRota;

  @override
  void initState() {
    super.initState();

    // fetch data from API
    // polylinePoints = PolylinePoints();
    getData();
    getData1(rota.rotaId);
    _getPolyline();
  }

  getData() async {
    artes = await RemoteService().getArtes();
    if (artes != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getData1(rotaId) async {
    arteByRota = await RemoteService().getArtesRota(rotaId);
    // if (arteByRota != null) {
      setState(() {
        isLoaded = true;
      });
    // }
  }

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  late Position currentPosition;
  List<Marker> _markers = [];
  List<LatLng> latlng = [];
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  var _partida;
  var _chegada;
  var _waypoint;

  var geoLocator = Geolocator();

  void locatePosition() async {
    LatLng latLatPosition = LatLng(artes![arteByRota[0].artesId - 1].latitude,
        artes![arteByRota[0].artesId - 1].longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 18);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(38.70723439106229, -9.152428676689576),
    zoom: 14.4746,
  );

  void createMarker() async {
    for (int i = 0; i < arteByRota.length; i++) {
      _markers.add(Marker(
        markerId:
            MarkerId(artes![arteByRota[i].artesId - 1].artesNome), //way points
        position: LatLng(artes![arteByRota[i].artesId - 1].latitude,
            artes![arteByRota[i].artesId - 1].longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));}
      _partida  =  PointLatLng(artes![arteByRota[0].artesId - 1].latitude,
            artes![arteByRota[0].artesId - 1].longitude);
      _chegada = PointLatLng(artes![arteByRota[2].artesId - 1].latitude,
            artes![arteByRota[2].artesId - 1].longitude);
      _waypoint = PolylineWayPoint(location: {artes![arteByRota[1].artesId - 1].latitude  , artes![arteByRota[1].artesId- 1].longitude}.toString());
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyAexbvOtmhPG8nPyJwVVf7MJhHDEMYonUc",
        _partida,
        _chegada,
        travelMode: TravelMode.walking,
        wayPoints: [_waypoint]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        isLoaded = true;
      });
    }
    _addPolyLine();
      
      print(_partida);
      print(_chegada);
      print(_waypoint);
  }

    _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyAexbvOtmhPG8nPyJwVVf7MJhHDEMYonUc",
        // PointLatLng(artes![arteByRota![0].artesId - 1].latitude,
        //     artes![arteByRota![0].artesId - 1].longitude),
        _partida,
        _chegada,
        // PointLatLng(artes![arteByRota!.length].latitude,
        //     artes![arteByRota!.length].longitude),
        travelMode: TravelMode.driving,
        wayPoints: [_waypoint]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        isLoaded = true;
      });
    }
    _addPolyLine();
  }


    _addPolyLine() {
    PolylineId id = PolylineId("route");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: _markers.map((e) => e).toSet(),
        polylines: Set<Polyline>.of(polylines.values),
        mapType: MapType.hybrid,
        myLocationEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controllerGoogleMap.complete(controller);
          newGoogleMapController = controller;
          locatePosition();
          createMarker();
        },
      ),
    );
  }
}

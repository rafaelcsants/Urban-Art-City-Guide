import 'dart:async';

import 'package:app/models/Pessoa.dart';
import 'package:app/models/Rota.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/Arte.dart';
import '../models/ArtebyRota.dart';
import '../services/remote_service.dart';

class InfoRota extends StatefulWidget {
  // In the constructor, require a Todo.
  const InfoRota({Key? key, required this.rota}) : super(key: key);

  // Declare a field that holds the Todo.
  final Rota rota;

  @override
  _InfoRotaState createState() => _InfoRotaState(rota);
}

class _InfoRotaState extends State<InfoRota> {
  Rota rota;
  _InfoRotaState(this.rota);
  var isLoaded = false;
  List<ArteByRota>? arteByRota;
  List<Arte>? artes;
  List<Pessoa>? pessoas;

  @override
  void initState() {
    super.initState();

    // fetch data from API
    getData(rota.rotaId);
    getData1();
    getData2();
    // _getPolyline();
  }

  getData2() async {
    pessoas = await RemoteService().getPessoas();
    if (pessoas != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getData(rotaId) async {
    arteByRota = await RemoteService().getArtesRota(rotaId);
    if (arteByRota != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getData1() async {
    artes = await RemoteService().getArtes();
    if (artes != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  void inscricao(rotaId, inscricaoPessoaId) {
    RemoteService().submitInscricao(rotaId, inscricaoPessoaId);
    // print({rotaId, inscricaoPessoaId});
    setState(() {});
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
    LatLng latLatPosition = LatLng(artes![arteByRota![0].artesId - 1].latitude,
        artes![arteByRota![0].artesId - 1].longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 17);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(38.70723439106229, -9.152428676689576),
    zoom: 14.4746,
  );

  void createMarker() async {
    for (int i = 0; i < arteByRota!.length; i++) {
      _markers.add(Marker(
        markerId:
            MarkerId(artes![arteByRota![i].artesId - 1].artesNome), //way points
        position: LatLng(artes![arteByRota![i].artesId - 1].latitude,
            artes![arteByRota![i].artesId - 1].longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }
    _partida = PointLatLng(artes![arteByRota![0].artesId - 1].latitude,
        artes![arteByRota![0].artesId - 1].longitude);
    _chegada = PointLatLng(artes![arteByRota![2].artesId - 1].latitude,
        artes![arteByRota![2].artesId - 1].longitude);
    _waypoint = PolylineWayPoint(
        location: {
      artes![arteByRota![1].artesId - 1].latitude,
      artes![arteByRota![1].artesId - 1].longitude
    }.toString());
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyAexbvOtmhPG8nPyJwVVf7MJhHDEMYonUc", _partida, _chegada,
        travelMode: TravelMode.walking, wayPoints: [_waypoint]);
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

  //   _getPolyline() async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       "AIzaSyAexbvOtmhPG8nPyJwVVf7MJhHDEMYonUc",
  //       // PointLatLng(artes![arteByRota![0].artesId - 1].latitude,
  //       //     artes![arteByRota![0].artesId - 1].longitude),
  //       _partida,
  //       _chegada,
  //       // PointLatLng(artes![arteByRota!.length].latitude,
  //       //     artes![arteByRota!.length].longitude),
  //       travelMode: TravelMode.driving,
  //       wayPoints: [_waypoint]);
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //     setState(() {
  //       isLoaded = true;
  //     });
  //   }
  //   _addPolyLine();
  // }

  _addPolyLine() {
    PolylineId id = PolylineId("route");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(rota.rotaNome),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 750,
                  child: Stack(
                    alignment: AlignmentDirectional(0, -0.35),
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-0.09, -0.18),
                        child:
                            Text(rota.rotaDisc, style: TextStyle(fontSize: 25)),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0.08),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 224, 210, 210),
                            primary: Colors.green,
                            // foreground
                          ),
                          onPressed: () => {
                            inscricao(rota.rotaId, pessoas![0].pessoaId),
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title:
                                          Text("Inscricao feita com sucesso"),
                                    ))
                          },
                          child: Text('Inscrever-me',
                              style: TextStyle(fontSize: 25)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  child: CarouselSlider.builder(
                    itemCount: arteByRota!.length,
                    itemBuilder: (context, index, realIndex) {
                      final urlImage =
                          'http://gau.cm-lisboa.pt/fileadmin/templates/gau/app_v2/img.php?ficheiro_id=${artes![arteByRota![index].artesId - 1].imagem}';
                      return buildImage(urlImage, index);
                    },
                    options: CarouselOptions(
                        height: 350,
                        autoPlay: true,
                        reverse: false,
                        autoPlayAnimationDuration: Duration(seconds: 2)),
                  )),
              Align(
                  alignment: AlignmentDirectional(0, 0.85),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    alignment: AlignmentDirectional(0, 0.8),
                    child: GoogleMap(
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
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        color: Colors.green,
        child: Image.network(
          urlImage,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      );
}

import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../core/config/config.dart';
import '../core/utils/convert_map_icon.dart';
import '../core/utils/map_util.dart';
import '../models/colors.dart';
import '../models/place.dart';

class GuidePage extends StatefulWidget {
  final Place d;

  GuidePage({Key? key, required this.d}) : super(key: key);

  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  late GoogleMapController mapController;

  List<Marker> _markers = [];
  Map<String, dynamic> data = {};
  String distance = '0 km';

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late Uint8List _sourceIcon;
  late Uint8List _destinationIcon;

  Future<void> getData() async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('places')
        .doc(widget.d.timestamp)
        .collection('travel guide')
        .doc(widget.d.timestamp)
        .get();
    setState(() {
      data = snap.data() as Map<String, dynamic>? ?? {};
    });
  }

  Future<void> _setMarkerIcons() async {
    _sourceIcon = await getBytesFromAsset(Config().drivingMarkerIcon, 110);
    _destinationIcon = await getBytesFromAsset(Config().destinationMarkerIcon, 110);
  }

  Future<void> addMarker() async {
    final List<Marker> m = [
      Marker(
        markerId: MarkerId(data['startpoint name']),
        position: LatLng(data['startpoint lat'], data['startpoint lng']),
        infoWindow: InfoWindow(title: data['startpoint name']),
        icon: BitmapDescriptor.fromBytes(_sourceIcon),
      ),
      Marker(
        markerId: MarkerId(data['endpoint name']),
        position: LatLng(data['endpoint lat'], data['endpoint lng']),
        infoWindow: InfoWindow(title: data['endpoint name']),
        icon: BitmapDescriptor.fromBytes(_destinationIcon),
      )
    ];
    setState(() {
      _markers.addAll(m);
    });
  }

  Future<void> computeDistance() async {
    final LatLng p1 = LatLng(data['startpoint lat'], data['startpoint lng']);
    final LatLng p2 = LatLng(data['endpoint lat'], data['endpoint lng']);
    final double _distance = (await MapUtils.mapStyles) as double;
    setState(() {
      distance = '${_distance.toStringAsFixed(2)} km';
    });
  }

  Future<void> _getPolyline() async {
    final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Config().mapAPIKey,
      request: PolylineRequest(
        origin: PointLatLng(data['startpoint lat'], data['startpoint lng']),
        destination: PointLatLng(data['endpoint lat'], data['endpoint lng']),
        mode: TravelMode.driving,
        // nếu cần thêm waypoints:
        // wayPoints: [PolylineWayPoint(location: "Đà Nẵng, Vietnam")],
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      for (var p in result.points) {
        polylineCoordinates.add(LatLng(p.latitude, p.longitude));
      }
      _addPolyLine();
    }
  }

  void _addPolyLine() {
    final PolylineId id = PolylineId("poly");
    final Polyline polyline = Polyline(
      polylineId: id,
      color: Color.fromARGB(255, 40, 122, 198),
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void animateCamera() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(data['startpoint lat'], data['startpoint lng']),
          zoom: 8,
          bearing: 120,
        ),
      ),
    );
  }

  void onMapCreated(controller) {
    controller.setMapStyle(MapUtils.mapStyles);
    setState(() {
      mapController = controller;
    });
  }

  @override
  void initState() {
    super.initState();
    _setMarkerIcons();
    getData().then((value) {
      addMarker().then((value) {
        _getPolyline();
        computeDistance();
        animateCamera();
      });
    });
  }

  Widget panelUI() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "travel guide",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ).tr(),
          ],
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            text: 'estimated cost = '.tr(),
            children: <TextSpan>[
              TextSpan(
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                text: data['price'].toString() ?? '',
              )
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            text: 'distance = '.tr(),
            children: <TextSpan>[
              TextSpan(
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                text: distance,
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8, bottom: 8),
          height: 3,
          width: 170,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'steps',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ).tr(),
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 8),
                height: 3,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: data.isEmpty
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView.separated(
            padding: EdgeInsets.only(bottom: 10),
            itemCount: data['paths'].length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 15,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: ColorList().guideColors[index],
                        ),
                        Container(
                          height: 90,
                          width: 2,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      child: Expanded(
                        child: Text(
                          data['paths'][index] ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget panelBodyUI(h, w) {
    return Container(
      width: w,
      child: GoogleMap(
        initialCameraPosition: Config().initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) => onMapCreated(controller),
        markers: Set.from(_markers),
        polylines: Set<Polyline>.of(polylines.values),
        compassEnabled: false,
        myLocationEnabled: false,
        zoomGesturesEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SlidingUpPanel(
              minHeight: 125,
              maxHeight: MediaQuery.of(context).size.height * 0.80,
              backdropEnabled: true,
              backdropOpacity: 0.2,
              backdropTapClosesPanel: true,
              isDraggable: true,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                  offset: Offset(1, 0),
                ),
              ],
              padding: EdgeInsets.only(top: 15, left: 10, bottom: 0, right: 10),
              panel: panelUI(),
              body: panelBodyUI(h, w),
            ),
            Positioned(
              top: 15,
              left: 10,
              child: Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Icon(Icons.keyboard_backspace),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    data.isEmpty
                        ? Container()
                        : Container(
                      width: MediaQuery.of(context).size.width * 0.80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey, width: 0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
                          bottom: 10,
                          right: 15,
                        ),
                        child: Text(
                          '${data['startpoint name']} - ${data['endpoint name']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            data.isEmpty && polylines.isEmpty
                ? Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:driver_app/commons.dart';
import 'package:driver_app/widgets/trip_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class SubMain extends StatefulWidget {
  const SubMain({Key? key}) : super(key: key);

  @override
  State<SubMain> createState() => _SubMainState();
}

class _SubMainState extends State<SubMain> {

  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.335, -122.032);
  static const LatLng destLocation = LatLng(37.335, -122.070);

  late LatLng initialLocation = LatLng(33.345, 35.846);

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
  
  List<LatLng> polylineCoordinates = [];
  List<LocationData>? currentLocations;

  String? driverCnt = null;

  Set<Marker> markers = Set();
  late Timer timer;
  Map<String, dynamic>? tripInfo = null;

  Future<void> getCurrentLocations() async {

    List<dynamic>? list = null;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie' : Commons.cookie,
    };

    final response = await http.get(
        Uri.parse('http://167.86.102.230/Alnabali/public/android/driver-location'),
        // Send authorization headers to the backend.
        headers: requestHeaders
    );

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    list = responseJson["result"];
    developer.log("map" + list.toString());
    // setState(() {
      driverCnt = list!.length.toString();
    // });
    developer.log("map23" + driverCnt!);

    markers.add(
      Marker(
          markerId: MarkerId("source"),
          position: sourceLocation,
          icon: BitmapDescriptor.defaultMarker

      ),
    );
    markers.add(
      Marker(
          markerId: MarkerId("destination"),
          position: destLocation,
          icon: BitmapDescriptor.defaultMarker,
      ),
    );
    developer.log("map234" + list.runtimeType.toString());

    list.asMap().forEach((key, element) {
      developer.log("map33" + "marker${element['trip_id']}");
      developer.log("map334 " + element['latitude']);
      developer.log("map335 " + element['longitude']);
      initialLocation = LatLng(double.parse(element['latitude']), double.parse(element['longitude']));
      Marker marker = Marker(
                  markerId: MarkerId("marker${element['trip_id']}"),
                  position: LatLng(double.parse(element['latitude']), double.parse(element['longitude'])),
                  icon: currentIcon,
                  onTap: () {
                    getTrip(element['trip_id']).then((value) => getDialog(element['latitude'], element['longitude']));
                    developer.log("tripinfo" + tripInfo.toString());
                    developer.log("markertap3");
                  }
       );
      // setState(() {
        markers.add(marker);
      // });
      developer.log("map338 " + markers.toString());
    });
  }

  Future<void> getDialog(String latitude, String longitude) {
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 330,
            child: SizedBox.expand(
                child: TripDialog(
                  dest_area: tripInfo!["destination_area"],
                  dest_city: tripInfo!['destination_city'],
                  driver_name: tripInfo!['dirver_name'],
                  origin_area: tripInfo!['origin_area'],
                  origin_city: tripInfo!['origin_city'],
                  trip_name: tripInfo!['trip_name'],
                  latitude: latitude,
                  longitude: longitude,
                )
            ),
            margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  Future<bool> getTrip(String trip_id) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie' : Commons.cookie,
    };

    final response = await http.get(
        Uri.parse('http://167.86.102.230/Alnabali/public/android/daily-trip/${trip_id}'),
        // Send authorization headers to the backend.
        headers: requestHeaders
    );

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log("hhhhhh" + responseJson.toString());

    tripInfo = responseJson["result"];

    if (tripInfo!.isNotEmpty) return true;
    return false;
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Commons.APIKEY,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destLocation.latitude, destLocation.longitude)
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/bus_from.png")
        .then((icon) => currentIcon = icon);
  }

  @override
  void initState() {
    setCustomMarkerIcon();
    // getCurrentLocations();
    getPolyPoints();

    // timer = Timer.periodic(const Duration(seconds: 60), (Timer t) => getCurrentLocations());
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: getCurrentLocations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  Center(child: Text("No Driver is running..."));
                }
                return GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(initialLocation!.latitude!, initialLocation!.longitude!),
                      zoom: 13
                  ),
                  polylines: {
                    Polyline(
                        polylineId: PolylineId('route'),
                        points: polylineCoordinates,
                        color: Colors.purple,
                        width: 6
                    ),
                  },
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(14.0),
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: Container(
          //       alignment: Alignment.center,
          //       margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/22),
          //       child: SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.9,
          //         height: MediaQuery.of(context).size.height / 18,
          //         child: const TextField(
          //           decoration: InputDecoration(
          //             hintText: "Search Driver, Trip, Bus No.",
          //             hintStyle: TextStyle(
          //                 color: Colors.black26
          //             ),
          //             filled: true,
          //             fillColor: Colors.white,
          //             contentPadding: EdgeInsets.only(left: 30),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.all(Radius.circular(50)),
          //               borderSide: BorderSide(
          //                 color: Colors.red,
          //               ),
          //             ),
          //             suffixIcon: Icon(
          //               Icons.search,
          //               color: Colors.black45,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/22),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height / 18,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Search Driver, Trip, Bus No.",
                          hintStyle: TextStyle(
                              color: Colors.black26
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(left: 30),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.78,),
                  Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/30),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height / 13,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.orange,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.32,
                            height: MediaQuery.of(context).size.height / 20,
                            margin: EdgeInsets.all(10),
                            child: TextField(
                              style: const TextStyle(
                                fontSize: 13
                              ),
                              decoration: InputDecoration(
                                enabled: false,
                                prefixIcon: Padding(
                                  padding: EdgeInsetsDirectional.only(start: 10,top: 5, bottom: 5),
                                  child: Image.asset("assets/navbar_track.png",),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(1),
                                hintText: "TRACKING",
                                hintStyle: const TextStyle(
                                  color: Colors.red
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                                )
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/trip');
                            },
                            child: Container(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.08, top: 20, bottom: 15),
                                  child: Image.asset("assets/navbar_trip.png"),
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/notification');
                            },
                            child: Container(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.1, top: 20, bottom: 15),
                                  child: Image.asset("assets/navbar_notification.png"),
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                            child: Container(
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.1, top: 20, bottom: 15),
                                child: Image.asset("assets/navbar_user.png"),
                              ),

                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
        ],
      )
    );
  }


}

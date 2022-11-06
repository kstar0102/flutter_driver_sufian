import 'dart:async';
import 'package:driver_app/commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'widgets/button_field.dart';
import 'widgets/input_field.dart';

class SubMain extends StatefulWidget {
  const SubMain({Key? key}) : super(key: key);

  @override
  State<SubMain> createState() => _SubMainState();
}

class _SubMainState extends State<SubMain> {

  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.335, -122.032);
  static const LatLng destLocation = LatLng(37.335, -122.070);
  
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation() {
    Location location = Location();
    location.getLocation().then(
            (value) => currentLocation = value,
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Commons.APIKEY,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destLocation.latitude, destLocation.longitude)
    );
    print(result);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GoogleMap(
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: sourceLocation,
                zoom: 13
              ),
              markers: {
                const Marker(
                    markerId: MarkerId("source"),
                    position: sourceLocation
                ),
                const Marker(
                    markerId: MarkerId("destination"),
                    position: destLocation
                ),
                // const Marker(
                //     markerId: MarkerId("current"),
                //     position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                // )
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId('route'),
                  points: polylineCoordinates,
                  color: Colors.purple,
                  width: 6
                )
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
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

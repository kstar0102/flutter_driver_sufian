import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'widgets/button_field.dart';
import 'widgets/input_field.dart';

class SubMain extends StatefulWidget {
  const SubMain({Key? key}) : super(key: key);

  @override
  State<SubMain> createState() => _SubMainState();
}

class _SubMainState extends State<SubMain> {

  Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // GoogleMap(
            //   mapType: MapType.normal,
            //   initialCameraPosition: _kGooglePlex,
            //   onMapCreated: (GoogleMapController controller) {
            //     _controller.complete(controller);
            //   },
            // ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //     image: AssetImage("assets/bg.png"), fit: BoxFit.cover)
                color: Colors.blue
              ),
              height: MediaQuery.of(context).size.height,
            ),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.8,),
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
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

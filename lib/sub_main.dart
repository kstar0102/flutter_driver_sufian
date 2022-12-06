import 'dart:async';
import 'dart:convert';
import 'package:driver_app/commons.dart';
import 'package:driver_app/home_trips.dart';
import 'package:driver_app/trip_detail.dart';
import 'package:driver_app/widgets/trip_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SubMain extends StatefulWidget {
  const SubMain({Key? key}) : super(key: key);

  @override
  State<SubMain> createState() => _SubMainState();
}

class _SubMainState extends State<SubMain> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String mToken = "";

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setCustomMarkerIcon();
    // getCurrentLocations();
    getPolyPoints();

    timer = Timer.periodic(
        const Duration(seconds: 60), (Timer t) => getCurrentLocations());

    requestPermission();
    getToken().then((value) {
      saveFCMToken(Commons.fcm_token);
    });
    initInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // timer.cancel();
    super.dispose();
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = const DarwinInitializationSettings();

    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        try {
          if (details != null && details.toString().isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeTripsPage(),
                ));
          }
        } catch (e) {}
        return;
      },
    );
    FirebaseMessaging.onMessage.listen((message) async {
      print("===============OnMessage================");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        "channelId",
        "channelName",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: false,
        // sound: RawResourceAndroidNotificationSound('notification'),
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        Commons.fcm_token = token!;
        mToken = token!;
        print('My token is $mToken');
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc("supervisor${Commons.login_id}")
        .set({
          'token': token,
        })
        .then((value) => developer.log("success save"))
        .catchError((e) => developer.log("failed${e.toString()}"));
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                "key=AAAA0wJIbDc:APA91bHIC8j7Tx5BpZ8OImhnieMQlRRgOJe_FhuYfBXpydL4b0QdgTgywqWdC45Van6SwWVfh0sZ_ZhAOeH8wPsIIhVeagS5X8hpLnmLYn_-xCD-pQwNOkgKV4vZp9Lko_lpT00CfpLC",
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              'notification': <String, dynamic>{
                'title': title,
                'body': body,
                'android_channel_id': 'channelId'
              },
              'to': token,
            },
          ));
    } catch (e) {
      if (kDebugMode) {
        print("error push notification" + e.toString());
      }
    }
  }

  saveFCMToken(String fcm_token) async {
    if (fcm_token == "" || fcm_token == null) return;
    Map data = {
      'id': Commons.login_id,
      'fcm_token': fcm_token,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
      // 'Authorization': Commons.token,
      'X-CSRF-TOKEN': Commons.token
    };

    // requestHeaders['cookie'] = Commons.cookie;

    String url = "${Commons.baseUrl}supervisor/save/fcm_token";
    var response =
        await http.post(Uri.parse(url), body: data, headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log("fcmtokenmsg6" + responseJson.toString());
    developer.log("fcmtoken" + Commons.login_id + fcm_token);
    if (response.statusCode == 200) {
      developer.log("fcmtokenmsg7" + "success http request");
      if (responseJson['result'] != "success") {
        Commons.showErrorMessage('Failed to register device');
      }
    }
  }

  Future<void> getCurrentLocations() async {
    List<dynamic>? list = null;

    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse(
            'http://167.86.102.230/Alnabali/public/android/driver-location'),
        // Send authorization headers to the backend.
        headers: requestHeaders);

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
          icon: BitmapDescriptor.defaultMarker),
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
      initialLocation = LatLng(double.parse(element['latitude']),
          double.parse(element['longitude']));
      Marker marker = Marker(
          markerId: MarkerId("marker${element['trip_id']}"),
          position: LatLng(double.parse(element['latitude']),
              double.parse(element['longitude'])),
          icon: currentIcon,
          onTap: () {
            getTrip(element['trip_id']).then((value) =>
                getDialog(element['latitude'], element['longitude']));
            developer.log("tripinfo" + tripInfo.toString());
            developer.log("markertap3");
          });
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
            )),
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
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  Future<bool> getTrip(String trip_id) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse(
            'http://167.86.102.230/Alnabali/public/android/daily-trip/${trip_id}'),
        // Send authorization headers to the backend.
        headers: requestHeaders);

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
        PointLatLng(destLocation.latitude, destLocation.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/bus_from.png")
        .then((icon) => currentIcon = icon);
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
                    target: LatLng(initialLocation!.latitude!,
                        initialLocation!.longitude!),
                    zoom: 13),
                polylines: {
                  Polyline(
                      polylineId: PolylineId('route'),
                      points: polylineCoordinates,
                      color: Colors.purple,
                      width: 6),
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
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 22),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height / 18,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search_placeholder'.tr(),
                      hintStyle: TextStyle(color: Colors.black26),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.78,
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 55),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height / 15,
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
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                              enabled: false,
                              prefixIcon: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    start: 10, top: 5, bottom: 5),
                                child: Image.asset(
                                  "assets/navbar_track.png",
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(1),
                              hintText: 'tracking'.tr(),
                              hintStyle: const TextStyle(color: Colors.red),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)))),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/trip');
                        },
                        child: Container(
                            child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: MediaQuery.of(context).size.width * 0.08,
                              top: 20,
                              bottom: 15),
                          child: Image.asset("assets/navbar_trip.png"),
                        )),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/notification');
                        },
                        child: Container(
                            child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: MediaQuery.of(context).size.width * 0.1,
                              top: 20,
                              bottom: 15),
                          child: Image.asset("assets/navbar_notification.png"),
                        )),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Container(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: MediaQuery.of(context).size.width * 0.1,
                                top: 20,
                                bottom: 15),
                            child: Image.asset("assets/navbar_user.png"),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    ));
  }
}

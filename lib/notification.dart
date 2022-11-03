import 'package:driver_app/commons.dart';
import 'package:driver_app/widgets/notification_panel.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  List<dynamic>? notifications;
  late String today = "01-01-2022";

  getNotification(bool today) async {
    // setToken();

    String? url = null;
    if (today) {
      url = "${Commons.baseUrl}notification/today";
    } else {
      url = "${Commons.baseUrl}notification/all";
    }
    var response = await http.get(Uri.parse(url!),);

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log("notification1" + responseJson.toString());
    if (response.statusCode == 200) {
      notifications = responseJson['result'];
      today = responseJson['today'];
      int? cnt = notifications?.length;
      developer.log("notification2" + cnt.toString());
    } else {
      Fluttertoast.showToast(
          msg: "Server Error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 16.0
      );
    }
  }

  Widget displayNotification() {
    List<Widget> list = <Widget>[];
    list.add(SizedBox(height: 100,));
    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.black,
          height: 1,
          width: MediaQuery.of(context).size.width/4,
        ),
        SizedBox(width: 20,),
        Text("Today, ${today}"),
        SizedBox(width: 20,),
        Container(
          color: Colors.black,
          height: 1,
          width: MediaQuery.of(context).size.width/4,
        ),
      ],
    ));
    list.add(SizedBox(height: 20,));
    notifications?.asMap().forEach((key, notification) {
      String time = notification['updated_at'];
      time = time.split("T")[1];
      time = time.substring(0, 5);
      developer.log("this type is" + time);

      String tripType = "";
      switch (notification['status']) {
        case 1:
          tripType = "pending";
          break;
        case 2:
          tripType = "accept";
          break;
        case 3:
          tripType = "reject";
          break;
        case 4:
          tripType = "start";
          break;
        case 6:
          tripType = "finish";
          break;
        case 8:
          tripType = "cancel";
          break;
        default:
          break;
      }
      //
      list.add(Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              NotificationPanel(
                tripID: "#${notification["trip_id"]}",
                tripName: notification['trip_name'],
                tripType:  tripType,
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/12, top: 15, bottom: 15),
                child: Text(
                  time,
                  style: TextStyle(
                      fontSize: 10
                  ),
                ),
              )
            ],
          )
      ));
    });
    return Column(children: list,);
  }

  @override
  Widget build(BuildContext context) {
    getNotification(true);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg_notification.png"), fit: BoxFit.fill)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: getNotification(true),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          Commons.showSuccessMessage("Waiting...");
                        }
                        return displayNotification();
                      },
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height/12,),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height/30,
                    left: MediaQuery.of(context).size.width/20,
                    right: MediaQuery.of(context).size.width/20,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height / 13,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.orange,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/main');
                        },
                        child: Container(
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.08, top: 20, bottom: 15),
                              child: Image.asset("assets/navbar_track2.png"),
                            )
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

                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height / 20,
                        margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 5),
                        child: TextField(
                          style: const TextStyle(
                              fontSize: 13
                          ),
                          decoration: InputDecoration(
                              enabled: false,
                              prefixIcon: Padding(
                                padding: EdgeInsetsDirectional.only(start: 5,top: 10, bottom: 10),
                                child: Image.asset("assets/navbar_notification2.png",),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.only(right: 5),
                              hintText: "NOTIFICATION",
                              hintStyle: const TextStyle(
                                color: Colors.red,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                              )
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Container(
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.03, top: 20, bottom: 15),
                              child: Image.asset("assets/navbar_user.png"),
                            )
                        ),
                      ),
                    ],
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

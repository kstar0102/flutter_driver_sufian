import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/home_trips_list.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:http/http.dart' as http;


import '../commons.dart';

class TripDetailTrack extends StatefulWidget {

  final String trip_id;
  const TripDetailTrack({Key? key, required this.trip_id}) : super(key: key);

  @override
  State<TripDetailTrack> createState() => _TripDetailTrackState();
}

class _TripDetailTrackState extends State<TripDetailTrack>
    with SingleTickerProviderStateMixin {

  String newStatus = "Pending", oldStatus = "Pending";

  List<dynamic> transaction = [];
  List<String> status = [
    "",
    "Pending",
    "Accept",
    "Reject",
    "Start",
    "Cancel",
    "Finish",
    "Fake"
  ];
  Future<List<dynamic>> getTransaction() async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie' : Commons.cookie,
    };

    final response = await http.get(
        Uri.parse('http://167.86.102.230/Alnabali/public/android/transaction/${widget.trip_id}'),
        headers: requestHeaders
    );

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    transaction = responseJson["result"];
    return transaction;
  }

  @override
  void initState() {
    getTransaction().then((value){
      setState(() {
        newStatus = status[int.parse(value.last['new_status'].toString())];
        oldStatus = status[int.parse(value.last['old_status'].toString())];
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        heightFactor: 2.5,
        child: Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 30
                )
              ]
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 30,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black26,
                          width: 2
                        )
                      ),
                      padding: EdgeInsetsDirectional.all(1),
                      child: Container(
                        width: 23,
                        height: 23,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red,
                              blurRadius: 10
                            )
                          ]
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                    Dash(
                      direction: Axis.vertical,
                      dashColor: Colors.red,
                      dashLength: 5,
                      length: 40,
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.black26,
                              width: 2
                          )
                      ),
                      padding: EdgeInsetsDirectional.all(1),
                      child: Container(
                        width: 23,
                        height: 23,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.red,
                                  blurRadius: 10
                              )
                            ]
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // "Pending",
                              oldStatus,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "Trip has been " + oldStatus,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 10
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width/4,),
                        Text(
                          "12:23 AM",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 8,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // "Pending",
                              newStatus,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "Trip has been " + newStatus,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 10
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width/4,),
                        Text(
                          "12:30 AM",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 8,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            )
        ),
      )
    );
  }
}

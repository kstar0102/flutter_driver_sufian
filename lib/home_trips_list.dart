import 'dart:async';

import 'package:driver_app/commons.dart';
import 'package:driver_app/sub_main.dart';
import 'package:driver_app/trip_detail.dart';
import 'package:driver_app/widgets/trip_info.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/widgets/buttons_tabbar.dart';
import 'package:driver_app/widgets/trip_card.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


enum TripsListType {
  todayTrips,
  pastTrips,
}

class TripsListView extends StatefulWidget {
  final TripsListType listType;
  final int selectedIndex;
  final bool today;

  const TripsListView({
    Key? key,
    required this.listType,
    this.selectedIndex = 0, required this.today,
  }) : super(key: key);

  @override
  State<TripsListView> createState() => _TripsListViewState();
}

class _TripsListViewState extends State<TripsListView> {

  List<dynamic>? trips;

  // var marea = {};
  // var mcity = {};

  getCity() async {
    List<dynamic> cities;

    String url = "${Commons.baseUrl}city/";

    var response = await http.get(Uri.parse(url!),);
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log("msg999" + responseJson.toString());
    if (response.statusCode == 200) {
      cities = responseJson['city'];
      developer.log("hahaha" + cities.toString());

      cities.forEach((city) {
        Commons.mcity[city['id']] = city['city_name_en'];
      });
      developer.log("this is city" + Commons.mcity.toString());
    }
    // return http.get(Uri.parse(url!),);
  }

  getArea() async {
    List<dynamic> cities;

    String url = "${Commons.baseUrl}area";

    var response = await http.get(Uri.parse(url!),);
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log("kukukk" + responseJson.toString());
    if (response.statusCode == 200) {
      cities = responseJson['area'];
      cities.forEach((city) {
        Commons.marea[city['id']] = city['area_name_en'];
      });
      developer.log("this is area" + Commons.marea.toString());
    }
  }

  getTrips(bool today) async {
    // setToken();
    Map data = {
      'driver_name': "all",
      'supervisor': Commons.login_id,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie' : Commons.cookie,
      // 'Authorization': Commons.token,
      'X-CSRF-TOKEN' : Commons.token
    };

    String? url = null;
    if (today) {
      url = "${Commons.baseUrl}daily-trip/today";
    } else {
      url = "${Commons.baseUrl}daily-trip/last";
    }
    var response = await http.post(Uri.parse(url!), body: data, headers: requestHeaders);

    SharedPreferences  sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log("msg666" + responseJson.toString());
    if (response.statusCode == 200) {
      trips = responseJson['result'];
      int? cnt = trips?.length;
      developer.log("msg7" + cnt.toString());
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

  TripInfo getInfoModel(TripStatus type, dynamic trip) {
    return TripInfo(
      status: type,
      tripNo: trip['id'],
      company: CompanyInfo(
        companyName: 'AMAZON',
        tripName: 'Amazon Morning Trip',
      ),
      busNo: trip['bus_no'],
      passengers: trip['bus_size_id'],
      busLine: BusLineInfo(
        fromTime: DateTime(Commons.getYear(trip['start_date']), Commons.getMonth(trip['start_date']),
            Commons.getDay(trip['start_date']), Commons.getHour(trip['start_time']), Commons.getMinute(trip['start_time'])),
        toTime: DateTime(Commons.getYear(trip['end_date']), Commons.getMonth(trip['end_date']),
            Commons.getDay(trip['end_date']), Commons.getHour(trip['end_time']), Commons.getMinute(trip['end_time'])),
        // courseName: "${trip['origin_area']} - ${trip['destination_area']}",
        // cityName: trip['origin_city'],
        courseName: "${trip['origin_area'] ?? 'here'} ",
        cityName: trip['origin_city'] ?? "here",
      ),
    );
  }

  Widget displayTrips(String type) {
    List<Widget> list = <Widget>[];

    trips?.asMap().forEach((key, trip) {
      // developer.log("zzzzzzzz" + Commons.getCity(trip['origin_city']).toString());

      if (trip['status'] == "1") {
          list.add(TripCard( past: true,
              info: getInfoModel(TripStatus.pending, trip),
              trip: trip,
              onPressed: () {}
          ));
      } else if (trip['status'] == "2") { //accept
        list.add(TripCard( past: true,
            trip: trip,
            info: getInfoModel(TripStatus.accepted, trip),
            onPressed: () {}
        ));
      }else if (trip['status'] == "3") { //reject
        list.add(TripCard( past: true,
            trip: trip,
            info: getInfoModel(TripStatus.rejected, trip),
            onPressed: () {}
        ));
      }else if (trip['status'] == "5") { //cancel
        list.add(TripCard( past: true,
            trip: trip,
            info: getInfoModel(TripStatus.canceled, trip),
            onPressed: () {}
        ));
      }else if (trip['status'] == "4") {  //start
        list.add(TripCard( past: true,
            trip: trip,
            info: getInfoModel(TripStatus.started, trip),
            onPressed: () {}
        ));
      }else if (trip['status'] == "6") { //finish
        list.add(TripCard( past: true,
            trip: trip,
            info: getInfoModel(TripStatus.finished, trip),
            onPressed: () {}
        ));
      } else if (trip['status'] == "7") { //fake
        list.add(TripCard( past: true,
            trip: trip,
            info: getInfoModel(TripStatus.fake, trip),
            onPressed: () {}
        ));
      }
      list.add(const SizedBox(height: 35),);
    });
    if (trips?.length == 0) {
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 30),
          child: Text(
            "No data to display",
            style: TextStyle(
              fontSize: 15,
              color: Colors.deepOrange
            ),
          )
      );
    }
    return Column(children: list);
  }

  Widget displaySubTrips(String type) {
    List<Widget> list = <Widget>[];

    trips?.asMap().forEach((key, trip) {
      // developer.log("zzzzzzzz" + Commons.getCity(trip['origin_city']).toString());

      if (type == "pending") {
        if (trip['status'] == "1") {
          list.add(TripCard( past: true,
              trip: trip,
              info: getInfoModel(TripStatus.pending, trip),
              onPressed: () {
                TripDetail(trip: trip,avatar_url: "",);
              }
          ));
        }
        list.add(const SizedBox(height: 20),);
      } else if (type == "accept") {
        if (trip['status'] == "2") { //accept
          list.add(TripCard( past: true,
              trip: trip,
              info: getInfoModel(TripStatus.accepted, trip),
              onPressed: () {}
          ));
        }
        list.add(const SizedBox(height: 20),);
      } else if (type == "reject") {
        if (trip['status'] == "3") { //reject
          list.add(TripCard( past: true,
              trip: trip,
              info: getInfoModel(TripStatus.rejected, trip),
              onPressed: () {}
          ));
        }
        list.add(const SizedBox(height: 20),);
      } else if (type == "cancel") {
        if (trip['status'] == "5") { //cancel
          list.add(TripCard( past: true,
              trip: trip,
              info: getInfoModel(TripStatus.canceled, trip),
              onPressed: () {}
          ));
        }
        list.add(const SizedBox(height: 20),);
      } else if (type == "start") {
        if (trip['status'] == "4") {  //start
          list.add(TripCard( past: true,
              trip: trip,
              info: getInfoModel(TripStatus.started, trip),
              onPressed: () {}
          ));
        }
        list.add(const SizedBox(height: 20),);
      } else if (type == "finish") {
        if (trip['status'] == "6") { //finish
          list.add(TripCard( past: true,
              trip: trip,
              info: getInfoModel(TripStatus.finished, trip),
              onPressed: () {}
          ));
        }
        list.add(const SizedBox(height: 20),);
      } else if (type == "fake") {
        if (trip['status'] == "7") { //fake
          list.add(TripCard( past: true,
              trip: trip,
              info: getInfoModel(TripStatus.fake, trip),
              onPressed: () {}
          ));
        }
        list.add(const SizedBox(height: 35),);
      }
    });
    if (trips?.length == 0) {
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 30),
          child: Text(
            "No data to display",
            style: TextStyle(
                fontSize: 15,
                color: Colors.deepOrange
            ),
          )
      );
    }
    return Column(children: list);
  }
  
  SingleChildScrollView getTab(String type) {
    return SingleChildScrollView(
      child: Column(children: [
        // TripCard( past: true,info: testStarted, onPressed: () {}),
        // const SizedBox(height: 20),
        // TripCard( past: true,info: testStarted, onPressed: () {}),
        FutureBuilder<List<void>>(
          future: Future.wait(
              [
                widget.today ? getTrips(true) : getTrips(false),
                getArea(),
                getCity()
              ]
          ),
          builder: (BuildContext context, AsyncSnapshot<List<void>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint("ConnectionState.waiting");
              return Text("... waiting");
            } else {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'A system error has occurred.',
                      style: TextStyle(
                          color: Colors.red, fontSize: 32),
                    ),
                  ),
                );
              }
              if (!snapshot.hasData) {
                debugPrint(
                    "! snapshot . hasData ${!snapshot.hasData}");
                return CircularProgressIndicator();
              }
              return displaySubTrips(type);
            }
          },

        )
      ]),
    );
  }

  String _getTabTextFromID(int id) {
    if (id == 100) {
      return 'All';
    } else {
      return kTripStatusStrings[id];
    }
  }

  @override
  Widget build(BuildContext context) {

    getCity();
    getArea();
    getTrips(true);
    developer.log("msg8" + displayTrips("all").toString());

    SizeConfig().init(context);

    List<int> tabIDArray = [100, 0, 1, 2, 3, 4, 5, 6];
    var tabCount = 8;
    if (widget.listType == TripsListType.pastTrips) {
      tabIDArray = [100, 4, 5, 6];
      tabCount = 4;
    }

    /// dummy codes for test
    ///


    ///
    var testStarted = TripInfo(
      status: TripStatus.started,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'MCDONALD\'S',
        tripName: 'McDonald\'s Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testPending = TripInfo(
      status: TripStatus.pending,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'AMAZON',
        tripName: 'Amazon Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testAccepted = TripInfo(
      status: TripStatus.accepted,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'MCDONALD\'S',
        tripName: 'McDonald\'s Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testRejected = TripInfo(
      status: TripStatus.rejected,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'AMAZON',
        tripName: 'Amazon Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testFinished = TripInfo(
      status: TripStatus.finished,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'MCDONALD\'S',
        tripName: 'McDonald\'s Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testCanceled = TripInfo(
      status: TripStatus.canceled,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'AMAZON',
        tripName: 'Amazon Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );

    return DefaultTabController(
      length: tabCount,
      child: Column(
        children: <Widget>[
          widget.listType == TripsListType.pastTrips ?
          Row(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Container(
                     margin: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 3),
                     height: 61 * SizeConfig.scaleY,
                     child: Image.asset('assets/images/home_icon2.png'),
                   ),
                   ButtonsTabBar(
                     backgroundColor: kColorPrimaryBlue,
                     borderColor: kColorPrimaryBlue,
                     unselectedBackgroundColor: Colors.transparent,
                     unselectedBorderColor: const Color(0xFFB3B3B3),
                     borderWidth: 1,
                     height: 32,
                     radius: 100,
                     contentPadding: EdgeInsets.only(right: 0.5),
                     //height: 62 * SizeConfig.scaleX,
                     // contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                     labelStyle: const TextStyle(
                       fontFamily: 'Montserrat',
                       fontWeight: FontWeight.w400,
                       fontSize: 10,
                       color: Colors.white,
                     ),
                     unselectedLabelStyle: const TextStyle(
                       fontFamily: 'Montserrat',
                       fontWeight: FontWeight.w400,
                       fontSize: 10,
                       color: Color(0xFFB3B3B3),
                     ),
                     tabs: tabIDArray
                         .map((t) => Tab(
                       child: Container(
                         alignment: Alignment.center,
                         width: 150 * SizeConfig.scaleX,
                         child: Text(_getTabTextFromID(t), style: TextStyle(color: Color(0xFFB3B3B3), ),),
                       ),
                     ))
                         .toList(),
                   ),
                 ],
               ),
             ),
           ]
          ) :
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 3),
                  height: 61 * SizeConfig.scaleY,
                  child: Image.asset('assets/images/home_icon2.png'),
                ),
                ButtonsTabBar(
                  backgroundColor: kColorPrimaryBlue,
                  borderColor: kColorPrimaryBlue,
                  unselectedBackgroundColor: Colors.transparent,
                  unselectedBorderColor: const Color(0xFFB3B3B3),
                  contentPadding: EdgeInsets.only(right: 3),
                  borderWidth: 1,
                  height: 32,
                  radius: 100,
                  //height: 62 * SizeConfig.scaleX,
                  // contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                  labelStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Color(0xFFB3B3B3),
                  ),
                  tabs: tabIDArray
                      .map((t) => Tab(
                    child: Container(
                      alignment: Alignment.center,
                      width: 132 * SizeConfig.scaleX,
                      child: Text(_getTabTextFromID(t), style: TextStyle(color: Color(0xFFB3B3B3)),),
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(children: [
                    // TripCard( past: true,info: testStarted, onPressed: () {}),
                    // const SizedBox(height: 20),
                    // TripCard( past: true,info: testStarted, onPressed: () {}),
                    FutureBuilder<List<void>>(
                      future: Future.wait(
                          [
                            widget.today ? getTrips(true) : getTrips(false),
                            getArea(),
                            getCity()
                          ]
                      ),
                      builder: (BuildContext context, AsyncSnapshot<List<void>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            debugPrint("ConnectionState.waiting");
                            return Center(
                              child: Text("... waiting"),
                            );
                          } else {
                            if (snapshot.hasError) {
                              return Scaffold(
                                body: Center(
                                  child: Text(
                                    'A system error has occurred.',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 32),
                                  ),
                                ),
                              );
                            }
                            if (!snapshot.hasData) {
                              debugPrint(
                                  "! snapshot . hasData ${!snapshot.hasData}");
                              return CircularProgressIndicator();
                            }
                            return displayTrips("all");
                          }
                        },

                    )
                  ]),
                ),
                if (widget.today)
                SingleChildScrollView(
                  child: Column(children: [
                    // TripCard( past: true,info: testStarted, onPressed: () {}),
                    // const SizedBox(height: 20),
                    // TripCard( past: true,info: testStarted, onPressed: () {}),
                    FutureBuilder<List<void>>(
                      future: Future.wait(
                          [
                            widget.today ? getTrips(true) : getTrips(false),
                            getArea(),
                            getCity()
                          ]
                      ),
                      builder: (BuildContext context, AsyncSnapshot<List<void>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          debugPrint("ConnectionState.waiting");
                          return Text("... waiting");
                        } else {
                          if (snapshot.hasError) {
                            return Scaffold(
                              body: Center(
                                child: Text(
                                  'A system error has occurred.',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 32),
                                ),
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            debugPrint(
                                "! snapshot . hasData ${!snapshot.hasData}");
                            return CircularProgressIndicator();
                          }
                          return displaySubTrips("pending");
                        }
                      },
                    )
                  ]),
                ),
                if (widget.today) getTab("accept"),
                if (widget.today) getTab("reject"),
                getTab("finish"),
                getTab("cancel"),
                if (widget.today) getTab("start"),
                getTab("fake"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:ui';

import 'package:driver_app/commons.dart';
import 'package:driver_app/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String userProfileImage = "";

  getUserData() async {

    // requestHeaders['cookie'] = Commons.cookie;

    String url = "${Commons.baseUrl}supervisor/profile/${Commons.login_id}";
    var response = await http.get(Uri.parse(url));

    SharedPreferences  sharedPreferences = await SharedPreferences.getInstance();
    developer.log("jkljkl" + response.body.toString());

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var user = responseJson['driver'];
      if (user['profile_image'] != null) {
        setState(() {
          userProfileImage = user['profile_image'];
        });
      }
    } else {
      Commons.showErrorMessage("Server Error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserData();
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg_profile.png"), alignment: Alignment.topCenter)
                ),
                height: MediaQuery.of(context).size.height,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height/6),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userProfileImage),
                        radius: 55,
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: 10),
                      child: Text(
                        "Sufian Abu Alabban",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: MediaQuery.of(context).size.height/55
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.width/100, bottom: MediaQuery.of(context).size.width/100),
                                  child: Image.asset("assets/time.png", width: MediaQuery.of(context).size.width * 0.07, height: MediaQuery.of(context).size.width * 0.07,),
                                )
                              ),
                              Container(
                                padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.width * 0.01, bottom: MediaQuery.of(context).size.width * 0.01),
                                child: Text(
                                  "10.2",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: MediaQuery.of(context).size.height/60
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsetsDirectional.only(),
                                child: Text(
                                  "Working Hours",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: MediaQuery.of(context).size.height/70
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.01, bottom: MediaQuery.of(context).size.width * 0.01),
                                    child: Image.asset("assets/meter.png", width: MediaQuery.of(context).size.width * 0.07, height: MediaQuery.of(context).size.width * 0.07,),
                                  )
                              ),
                              Container(
                                padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.01, bottom: MediaQuery.of(context).size.width * 0.01),
                                child: Text(
                                  "43.6",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: MediaQuery.of(context).size.height/60
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.05),
                                child: Text(
                                  "Total Distance",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: MediaQuery.of(context).size.height/70
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.01, bottom: MediaQuery.of(context).size.width * 0.01),
                                    child: Image.asset("assets/route.png", width: MediaQuery.of(context).size.width * 0.07, height: MediaQuery.of(context).size.width * 0.07,),
                                  )
                              ),
                              Container(
                                padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.01, bottom: MediaQuery.of(context).size.width * 0.01),
                                child: Text(
                                  "4",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: MediaQuery.of(context).size.height/60
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.05),
                                child: Text(
                                  "Total Trips",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: MediaQuery.of(context).size.height/70
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/12,),
                    Container(
                      child: SizedBox(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/profile_edit');
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.orange,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                            ),
                            fixedSize: Size(MediaQuery.of(context).size.width/1.7, 30),
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10, right: MediaQuery.of(context).size.width/10, top: 10, bottom: 10)
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                            ),
                          ),
                        )
                      ),
                    ),
                    Container(
                      child: SizedBox(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/password_change');
                            },
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.orange,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width/1.7, 30),
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10, right: MediaQuery.of(context).size.width/10, top: 10, bottom: 10)
                            ),
                            child: const Text(
                              "Change Password",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.orange,
                              ),
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/15,),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          showAlertDialog(BuildContext context) {
                            // set up the buttons
                            Widget cancelButton = TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                                ),
                                padding: const EdgeInsets.all(0.0),
                              ),
                              onPressed:  () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyLogin(),));
                                Commons.token = "";
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width/4,
                                height: MediaQuery.of(context).size.height/25,
                                alignment: Alignment.center,
                                child: const Text(
                                  "YES",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                            Widget continueButton = TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                padding: const EdgeInsets.all(0.0),
                              ),
                              onPressed:  () {
                                Navigator.pop(context);
                              },
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [Colors.grey, Colors.white]),
                                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width/4,
                                  height: MediaQuery.of(context).size.height/25,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'NO',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.orange
                                    ),
                                  ),
                                ),
                              ),
                            );

                            // set up the AlertDialog

                            AlertDialog alert = AlertDialog(
                              title: const Center(
                                child: Text(
                                  "Log Out",
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                      child: Image.asset("assets/bus_blue.png", width: 80, height: 80,),
                                    ),
                                    SizedBox(height: 10,),
                                    const Center(
                                      child: Text(
                                        "Are you sure you want to logout?",
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 15
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                cancelButton,
                                continueButton,
                              ],
                              actionsAlignment: MainAxisAlignment.center,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }
                          showAlertDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(MediaQuery.of(context).size.width/1.7, 30),
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                          )
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/logout.png", width: 20, height: 20,),
                            SizedBox(width: 10,),
                            const Text(
                              "LOG OUT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/50,),
                    const Text(
                      "App Version 0100.0",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/11,),
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/30),
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
                                    padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.1, top: 20, bottom: 15),
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
                            Container(
                              width: MediaQuery.of(context).size.width * 0.32,
                              height: MediaQuery.of(context).size.height / 20,
                              margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 10),
                              child: TextField(
                                style: const TextStyle(
                                    fontSize: 13
                                ),
                                decoration: InputDecoration(
                                    enabled: false,
                                    prefixIcon: Padding(
                                      padding: EdgeInsetsDirectional.only(start: 10,top: 10, bottom: 10),
                                      child: Image.asset("assets/navbar_account.png",),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.all(1),
                                    hintText: "ACCOUNT",
                                    hintStyle: const TextStyle(
                                        color: Colors.red
                                    ),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(50))
                                    )
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
}

import 'package:driver_app/commons.dart';
import 'package:flutter/material.dart';

import 'widgets/input_edit_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  String userProfileImage = "";

  final TextEditingController currentController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  getUserData() async {
    String url = "${Commons.baseUrl}supervisor/profile/${Commons.login_id}";
    var response = await http.get(Uri.parse(url));
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var user = responseJson['driver'];
      developer.log(user.toString());

      if (user['profile_image'] != null) {
        if (userProfileImage != "") return;
        setState(() {
          userProfileImage = user['profile_image'];
        });
      }
    } else {
      Commons.showErrorMessage("Server Error!");
    }
  }

  changePassword() async {
    if (currentController.text == "" || newController.text == "" || newController.text != confirmController.text) {
      Commons.showErrorMessage("Input Invalid");
      return;
    }

    Map data = {
      'id': Commons.login_id,
      'current_pwd': currentController.text,
      'new_pwd': newController.text,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie' : Commons.cookie,
      'X-CSRF-TOKEN' : Commons.token
    };
    String url = "${Commons.baseUrl}supervisor/pwd/change";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: data);

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log(responseJson.toString());

    if (response.statusCode == 200) {
      if (responseJson['result'] == 'success') {
        Commons.showSuccessMessage("Changed Successfully.");
        Navigator.pushNamed(context, "/profile");
      } else {
        Commons.showErrorMessage(responseJson["result"].toString());
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
                    SizedBox(height: MediaQuery.of(context).size.height/12,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/5, end: MediaQuery.of(context).size.width/5),
                      child: EditInputField(displayName: "Current Password", myController: currentController),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/5, end: MediaQuery.of(context).size.width/5),
                      child: EditInputField(displayName: "New Password", myController: newController),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/5, end: MediaQuery.of(context).size.width/5),
                      child: EditInputField(displayName: "Confirm Password", myController: confirmController),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height/7,),
                    Container(
                        child: ElevatedButton(
                          onPressed: () {
                              changePassword();
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
                            children: const [
                              SizedBox(width: 10,),
                              Text(
                                "Save",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/15,),
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

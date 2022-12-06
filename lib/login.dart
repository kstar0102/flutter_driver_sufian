import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:driver_app/commons.dart';
import 'package:driver_app/sub_main.dart';
import 'package:driver_app/widgets/button_field.dart';
import 'package:driver_app/widgets/input_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatelessWidget {
  MyLogin({super.key});

  final nameController = TextEditingController();
  final passController = TextEditingController();

  setToken() async {
    developer.log("init");

    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
    };

    final response = await http.get(
        Uri.parse('http://167.86.102.230/Alnabali/public/android/driver/token'),
        // Send authorization headers to the backend.
        headers: requestHeaders);

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    String token = responseJson["token"];
    Commons.token = token;

    // String? rawCookie = response.headers['set-cookie'];
    // if (rawCookie != null) {
    //   developer.log("msg2" + rawCookie);
    //
    //   int index = rawCookie.indexOf(';');
    //   Commons.cookie =
    //   (index == -1) ? rawCookie : rawCookie.substring(0, index);
    //   developer.log("msg3" + Commons.cookie);
    //
    // }
  }

  login(BuildContext context, TextEditingController nameCon,
      TextEditingController passCon) async {
    // setToken();
    if (nameCon.text == "" && passCon.text == "") {
      Commons.showErrorMessage("Input Name and Password!");
      return;
    }
    Map data = {
      'email': nameCon.text,
      'password': passCon.text,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie': Commons.cookie,
      // 'Authorization': Commons.token,
      'X-CSRF-TOKEN': Commons.token
    };

    // requestHeaders['cookie'] = Commons.cookie;

    String url = "${Commons.baseUrl}supervisor/login";
    var response =
        await http.post(Uri.parse(url), body: data, headers: requestHeaders);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log("msg6" + responseJson.toString());
    if (response.statusCode == 200) {
      developer.log("msg7" + "success http request");
      if (responseJson['result'] == "Invalid SuperVisor") {
        Commons.showErrorMessage('Invalid User');
      } else if (responseJson['result'] == "Invalid Password") {
        Commons.showErrorMessage('Invalid Password');
      } else {
        Commons.login_id = responseJson['id'].toString();
        Commons.isLogin = true;

        Navigator.pushNamed(context, "/main");
        // setState( () {
        sharedPreferences.setString("token", Commons.token);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => SubMain()),
            (route) => false);
        // })
      }
    } else {
      Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (Commons.isLogin) {
    //   Navigator.pushNamed(context, "/main");
    // }
    setToken();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bg.png"), fit: BoxFit.cover)),
            height: MediaQuery.of(context).size.height,
            child: Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/login_bus.png",
                    width: MediaQuery.of(context).size.width / 2.8,
                    height: MediaQuery.of(context).size.width / 2.8,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 18),
                  Text(
                    "login".tr(),
                    style: TextStyle(
                      fontSize: 2.7 * MediaQuery.of(context).size.height * 0.01,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 8),
                  InputField(inputType: "username", controller: nameController),
                  SizedBox(height: MediaQuery.of(context).size.height / 20),
                  InputField(inputType: "password", controller: passController),
                  SizedBox(height: MediaQuery.of(context).size.height / 13),
                  ButtonField(
                      buttonType: "login",
                      onPressedCallback: () {
                        login(context, nameController, passController);
                      }),
                  SizedBox(height: MediaQuery.of(context).size.height / 7),
                  GestureDetector(
                      onTap: () {
                        // setToken();
                        Navigator.pushNamed(context, "/forget_password");
                      },
                      child: Text(
                        "forget_password".tr(),
                        style: TextStyle(
                            shadows: const [
                              Shadow(color: Colors.white, offset: Offset(0, -5))
                            ],
                            decoration: TextDecoration.underline,
                            color: Colors.transparent,
                            fontSize:
                                1.2 * MediaQuery.of(context).size.height * 0.01,
                            letterSpacing: 1.2,
                            decorationThickness: 2,
                            decorationColor: Colors.white),
                      )),
                ],
              ),
            )),
      ),
    );
  }
}

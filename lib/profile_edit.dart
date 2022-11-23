import 'dart:io';

import 'package:driver_app/commons.dart';
import 'package:driver_app/widgets/ctm_painter.dart';
import 'package:driver_app/widgets/input_edit_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  String userProfileImage = "";
  late String name, phone, birthday, address;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _image = null;

  Future<void> pickImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final File image = File(pickedFile.path);
    setState(() {
      _image = image;
    });
    if (_image != null) {
      uploadImage();
    }
  }




  Future<void> uploadImage() async {
    String uploadUrl = "${Commons.baseUrl}supervisor/upload/image";
    try{
      List<int> imageBytes = _image!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      // convert file image to Base64 encoding
      var response = await http.post(
          Uri.parse(uploadUrl),
          body: {
            'id': Commons.login_id,
            'image': baseimage,
          },
          headers: {
            'Content-type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
            'Cookie' : Commons.cookie,
            'X-CSRF-TOKEN' : Commons.token
          }
      );
      developer.log("dddddd" + response.body);
      if(response.statusCode == 200){
        var jsondata = json.decode(response.body); //decode json data
        if(jsondata["result"] == "success"){ //check error sent from server
          Commons.showSuccessMessage("Upload successful");
          //if error return from server, show message from server
        }else{
          Commons.showErrorMessage(jsondata["result"]);
        }
      }else{
        Commons.showErrorMessage("Error during connection to server");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    }catch(e){
      Commons.showErrorMessage("Error during converting to Base64");
      //there is error during converting file image to base64 encoding.
    }
  }


  getUserData() async {

    // requestHeaders['cookie'] = Commons.cookie;

    String url = "${Commons.baseUrl}supervisor/profile/${Commons.login_id}";
    var response = await http.get(Uri.parse(url));

    SharedPreferences  sharedPreferences = await SharedPreferences.getInstance();

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var user = responseJson['driver'];
      developer.log(user.toString());

      if (user['profile_image'] != null) {
        if (userProfileImage != "") return;
        setState(() {
          userProfileImage = user['profile_image'];
          // name = user['name'];
          // phone = user['phone'];
          // address = user['address'];
          // birthday = user['birthday'];
        });
      }
      nameController.text = user['name'];
      phoneController.text = user['phone'];
      addressController.text = user['address'] ?? "nothing to display";
      birthController.text = user['birthday'];
    } else {
      Commons.showErrorMessage("Server Error!");
    }
  }

  updateProfile() async {

    Map data = {
      'id': Commons.login_id,
      'name': nameController.text,
      'birthday': birthController.text,
      'phone': phoneController.text,
      'address': addressController.text,
    };
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie' : Commons.cookie,
      'X-CSRF-TOKEN' : Commons.token
    };
    String url = "${Commons.baseUrl}supervisor/profile_edit";
    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: data);

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    developer.log(responseJson.toString());

    if (response.statusCode == 200) {
      if (responseJson['result'] == 'success') {
        Commons.showSuccessMessage("Update Successfully.");
        Navigator.pushNamed(context, "/profile");
      } else if (responseJson['result'] == "Invalid input data") {
        Commons.showErrorMessage("Input Your Information");
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
                        image: AssetImage("assets/bg_editpro.png"), alignment: Alignment.topCenter)
                ),
                height: MediaQuery.of(context).size.height,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 20,
                                height: 40,
                                margin: EdgeInsets.only(top: 45, left: 30),
                                child: CustomPaint(
                                  painter: BackArrowPainter(),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height/25),
                          child: const Text(
                            "EDIT PROFILE",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 17
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width/8,)
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: _image == null ?
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height/15),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userProfileImage),
                            radius: 55,
                          )
                      ) :
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height/15),
                          child: CircleAvatar(
                            // backgroundImage: FileImage(File(uploadimage!.path)),
                            backgroundImage: FileImage(File(_image!.path)),
                            radius: 55,
                          )
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
                      child: EditInputField(displayName: "Name", myController: nameController),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/5, end: MediaQuery.of(context).size.width/5),
                      child: EditInputField(displayName: "Phone", myController: phoneController),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/5, end: MediaQuery.of(context).size.width/5),
                      child: EditInputField(displayName: "Date of Birth", myController: birthController),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/5, end: MediaQuery.of(context).size.width/5),
                      child: EditInputField(displayName: "Address", myController: addressController),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/15,),
                    Container(
                        child: ElevatedButton(
                          onPressed: () {
                              updateProfile();
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
                        height: MediaQuery.of(context).size.height / 15,
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

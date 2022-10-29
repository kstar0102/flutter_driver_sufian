import 'package:driver_app/widgets/input_edit_field.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
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
                    Container(
                      margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height/25),
                      child: Text(
                        "EDIT PROFILE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(top: MediaQuery.of(context).size.height/9),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/avatar.png',),
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
                      child: EditInputField(displayName: "Name"),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/5, end: MediaQuery.of(context).size.width/5),
                      child: EditInputField(displayName: "Phone"),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/5, end: MediaQuery.of(context).size.width/5),
                      child: EditInputField(displayName: "Date of Birth"),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/80,),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width/5, end: MediaQuery.of(context).size.width/5),
                      child: EditInputField(displayName: "Address"),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/15,),
                    Container(
                        child: ElevatedButton(
                          onPressed: () {

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

import 'package:driver_app/widgets/notification_panel.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/bg_notification.png"), fit: BoxFit.fill)
                ),
                height: MediaQuery.of(context).size.height,
              ),
              Column(
                children: [
                  SizedBox(height: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        height: 1,
                        width: MediaQuery.of(context).size.width/4,
                      ),
                      SizedBox(width: 20,),
                      Text("Today, 12-08-2022"),
                      SizedBox(width: 20,),
                      Container(
                        color: Colors.black,
                        height: 1,
                        width: MediaQuery.of(context).size.width/4,
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        NotificationPanel(
                            tripID: "#1234567",
                            tripColor: Colors.green,
                            tripName: "Amazon, Evening's Trip",
                            tripDesc: "Trip has been finished"
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/12, top: 15, bottom: 15),
                          child: Text(
                            "04:30 PM",
                            style: TextStyle(
                              fontSize: 10
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          NotificationPanel(
                              tripID: "#1234567",
                              tripColor: Colors.green,
                              tripName: "Amazon, Evening's Trip",
                              tripDesc: "Trip has been finished"
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/12, top: 15, bottom: 15),
                            child: Text(
                              "04:30 PM",
                              style: TextStyle(
                                  fontSize: 10
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          NotificationPanel(
                              tripID: "#1234567",
                              tripColor: Colors.green,
                              tripName: "Amazon, Evening's Trip",
                              tripDesc: "Trip has been finished"
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/12, top: 15, bottom: 15),
                            child: Text(
                              "04:30 PM",
                              style: TextStyle(
                                  fontSize: 10
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          NotificationPanel(
                              tripID: "#1234567",
                              tripColor: Colors.green,
                              tripName: "Amazon, Evening's Trip",
                              tripDesc: "Trip has been finished"
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/12, top: 15, bottom: 15),
                            child: Text(
                              "04:30 PM",
                              style: TextStyle(
                                  fontSize: 10
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          NotificationPanel(
                              tripID: "#1234567",
                              tripColor: Colors.green,
                              tripName: "Amazon, Evening's Trip",
                              tripDesc: "Trip has been finished"
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            margin: EdgeInsets.only(right: MediaQuery.of(context).size.width/12, top: 15, bottom: 15),
                            child: Text(
                              "04:30 PM",
                              style: TextStyle(
                                  fontSize: 10
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height/12,),
                  Container(
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
                ],
              ),
            ],
          ),
        ),
      );
  }
}

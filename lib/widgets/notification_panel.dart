import 'package:flutter/material.dart';

class NotificationPanel extends StatefulWidget {

  final String tripID;
  final String tripType;
  final String tripName;


  const NotificationPanel({
    Key? key,
    required this.tripID,
    required this.tripName,
    required this.tripType,
  }) : super(key: key);



  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {

  Map<String, Color> mTripColor = {
    "": Colors.black,
    "start": Colors.blue,
    "pending": Colors.orange,
    "accept": Colors.brown,
    "finish": Colors.green,
    "cancel": Colors.purple,
    "reject": Colors.red,
  };

  Map<String, String> mTripDesc = {
    "": "",
    "start": "Trip has been started",
    "pending": "New pending trip",
    "accept": "Trip has been accepted",
    "finish": "Trip has been finished",
    "cancel": "Trip has been cancelled",
    "reject": "Trip has been rejected",
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2,
      height: MediaQuery.of(context).size.height/13,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 15,
                offset: Offset(3,3)
              )
            ]
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: mTripColor[widget.tripType],
                    ),
                    child: Center(
                      child: Text(
                        "TRIP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11
                        ),
                      ),
                    )
                  ),
                  Text(
                    widget.tripID,
                    style: TextStyle(
                      fontSize: 10,
                      color: mTripColor[widget.tripType],
                      fontWeight: FontWeight.w700
                    ),
                  )
                ],
              ),
              SizedBox(width: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      widget.tripName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      mTripDesc[widget.tripType]!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

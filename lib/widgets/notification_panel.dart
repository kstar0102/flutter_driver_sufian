import 'package:flutter/material.dart';

class NotificationPanel extends StatefulWidget {

  final String tripID;
  final Color tripColor;
  final String tripName;
  final String tripDesc;

  const NotificationPanel({Key? key, required this.tripID, required this.tripColor, required this.tripName, required this.tripDesc}) : super(key: key);

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
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
                      color: widget.tripColor,
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
                      color: widget.tripColor,
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
                      widget.tripDesc,
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

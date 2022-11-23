import 'dart:convert';

import 'package:driver_app/trip_detail.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/trip_info.dart';
import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/widgets/trip_busline.dart';
import 'package:driver_app/widgets/gradient_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../commons.dart';


class TripCard extends StatefulWidget {
  final TripInfo info;
  final dynamic trip;
  final VoidCallback onPressed;
  final bool past;

  const TripCard({
    Key? key,
    required this.info,
    required this.onPressed,
    required this.trip,
    required this.past,
  }) : super(key: key);

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {

  late String avatar = "";

  Future<String> getAvatar() async {
    String result = "";

    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Cookie' : Commons.cookie,
    };

    final response = await http.get(
        Uri.parse('http://167.86.102.230/Alnabali/public/android/client/avatar/${widget.trip['client_name']}'),
        // Send authorization headers to the backend.
        headers: requestHeaders
    );

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    result = responseJson["result"];

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    getAvatar().then((value) {
      setState(() {
        avatar = value;
      });
    });
    super.initState();
  }

  Widget _buildCompanyRow() {
    final screenW = MediaQuery.of(context).size.width;
    final avatarRadius = screenW * 0.0924 * 0.5;
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Colors.transparent,
            // backgroundImage: AssetImage(widget.info.company.getCompanyImgPath()),
            backgroundImage: NetworkImage(avatar),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.info.company.companyName,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                    color: kColorPrimaryGrey,
                  ),
                ),
                Text(
                  widget.info.company.tripName,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: widget.info.getStatusColor(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BUS NO.',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Colors.orange,
              ),
            ),
            Text(
              widget.info.busNo,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.orange,
              ),
            ),
            const Text(
              'Passengers',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Colors.orange,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenW * 0.035,
                  child: Image.asset('assets/images/passengers.png', color: Colors.orange,),
                ),
                const SizedBox(width: 4),
                Text(
                  widget.info.passengers.toString(),
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    if (widget.info.status == TripStatus.pending ||
        widget.info.status == TripStatus.accepted ||
        widget.info.status == TripStatus.started) {
      final screenW = MediaQuery.of(context).size.width;
      final btnW = screenW * 0.24;
      final btnH = btnW * 0.25;
      final yesTitle =
      widget.info.status == TripStatus.started ? 'FINISH' : 'ACCEPT';
      final noTitle =
      widget.info.status == TripStatus.started ? 'NAVIGATION' : 'REJECT';

      return SizedBox(
        height: btnH + 34,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: btnW,
              height: btnH,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorPrimaryBlue,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  yesTitle,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
            GradientButton(
              width: btnW,
              height: btnH,
              onPressed: () {},
              title: noTitle,
            ),
          ],
        ),
      );
    } else {
      return const SizedBox(height: 36);
    }
  }

  Widget _buildCardContents() {
    final screenW = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: screenW * 0.364,
              child: Image.asset(widget.info.getStatusImgPath()),
            ),
            Text(
              widget.info.getStatusStr(),
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
        !widget.past ? Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            widget.info.getTripNoStr(),
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: widget.info.getStatusColor(),
            ),
          ),
        ) : Text(""),
        SizedBox(
          width: screenW * 0.741,
          child: Column(
            children: [
              _buildCompanyRow(),
              const SizedBox(height: 2),
              TripBusLine(info: widget.info.busLine, driver_name: widget.trip['dirver_name'], detail: false),
              // _buildButtonsRow(),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cardW = screenW * 0.82;
    //final cardH = cardW * 0.675;

    // return Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     ElevatedButton(
    //       onPressed: () {},
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.white,
    //         foregroundColor: Colors.grey,
    //         elevation: 4,
    //         side: const BorderSide(width: 0.1, color: Colors.grey),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(18), // <-- Radius
    //         ),
    //       ),
    //       child: SizedBox(width: cardW, height: cardH),
    //     ),
    //     _buildCardContents(),
    //   ],
    // );
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) {
                return TripDetail(trip: widget.trip,avatar_url: avatar,);
            },
        ));
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 3, left: 3),
            width: cardW,
            //height: cardH,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildCardContents(),
          ),
          widget.info.status == TripStatus.pending ? Container(
            width: 30,
            height: 30,
            color: Colors.white,
            child: Icon(Icons.edit_note, size: 25, color: Colors.orange,),
          ) : Container(width: 30, height: 30,)
        ],
      )
    );
  }
}

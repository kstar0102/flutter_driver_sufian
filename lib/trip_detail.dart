import 'package:driver_app/commons.dart';
import 'package:driver_app/widgets/trip_card.dart';
import 'package:driver_app/widgets/trip_detail_card.dart';
import 'package:driver_app/widgets/trip_info.dart';
import 'package:flutter/material.dart';

class TripDetail extends StatefulWidget {

  final dynamic trip;

  const TripDetail({Key? key, this.trip}) : super(key: key);

  @override
  State<TripDetail> createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {

  TripInfo getInfoModel(TripStatus type) {
    return TripInfo(
      status: type,
      tripNo: widget.trip['id'],
      company: CompanyInfo(
        companyName: 'AMAZON',
        tripName: 'Amazon Morning Trip',
      ),
      busNo: widget.trip['bus_no'],
      passengers: widget.trip['bus_size_id'],
      busLine: BusLineInfo(
        fromTime: DateTime(Commons.getYear(widget.trip['start_date']), Commons.getMonth(widget.trip['start_date']),
            Commons.getDay(widget.trip['start_date']), Commons.getHour(widget.trip['start_time']), Commons.getMinute(widget.trip['start_time'])),
        toTime: DateTime(Commons.getYear(widget.trip['end_date']), Commons.getMonth(widget.trip['end_date']),
            Commons.getDay(widget.trip['end_date']), Commons.getHour(widget.trip['end_time']), Commons.getMinute(widget.trip['end_time'])),
        // courseName: "${widget.trip['origin_area']} - ${widget.trip['destination_area']}",
        // cityName: widget.trip['origin_city'],
        courseName: "${Commons.marea[int.parse(widget.trip['origin_area'])] ?? 'here'} ",
        cityName: Commons.mcity[int.parse(widget.trip['origin_city'])] ?? "here",
        // courseName: "code here",
        // cityName: "code here",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    TripStatus tripStatus = TripStatus.pending;
    if (widget.trip['status'] == "1") {
      tripStatus = TripStatus.pending;
    } else if (widget.trip['status'] == "2") { //accept
      tripStatus = TripStatus.accepted;
    }else if (widget.trip['status'] == "3") { //reject
      tripStatus = TripStatus.rejected;
    }else if (widget.trip['status'] == "8") { //cancel
      tripStatus = TripStatus.canceled;
    }else if (widget.trip['status'] == "4") {  //start
      tripStatus = TripStatus.started;
    }else if (widget.trip['status'] == "6") { //finish
      tripStatus = TripStatus.finished;
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg_trip.png",),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter
        )
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 25),
                child: Text(
                  "TRIP #${widget.trip['id']}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    decoration: TextDecoration.none
                  ),
                ),
            ),
            Container(
              child: Image.asset("assets/bus_tripdetail.png", scale: 3,),
            ),
            TripDetailCard(
                info: getInfoModel(tripStatus),
                onPressed: () {},
                trip: widget.trip,
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}


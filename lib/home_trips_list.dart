import 'package:driver_app/widgets/trip_info.dart';
import 'package:flutter/material.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/widgets/buttons_tabbar.dart';
import 'package:driver_app/widgets/trip_card.dart';

enum TripsListType {
  todayTrips,
  pastTrips,
}

class TripsListView extends StatefulWidget {
  final TripsListType listType;
  final int selectedIndex;

  const TripsListView({
    Key? key,
    required this.listType,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  State<TripsListView> createState() => _TripsListViewState();
}

class _TripsListViewState extends State<TripsListView> {
  String _getTabTextFromID(int id) {
    if (id == 100) {
      return 'All';
    } else {
      return kTripStatusStrings[id];
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    List<int> tabIDArray = [100, 0, 1, 2, 3, 4, 5];
    var tabCount = 7;
    if (widget.listType == TripsListType.pastTrips) {
      tabIDArray = [100, 2, 4, 5];
      tabCount = 4;
    }

    /// dummy codes for test
    var testStarted = TripInfo(
      status: TripStatus.started,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'MCDONALD\'S',
        tripName: 'McDonald\'s Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testPending = TripInfo(
      status: TripStatus.pending,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'AMAZON',
        tripName: 'Amazon Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testAccepted = TripInfo(
      status: TripStatus.accepted,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'MCDONALD\'S',
        tripName: 'McDonald\'s Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testRejected = TripInfo(
      status: TripStatus.rejected,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'AMAZON',
        tripName: 'Amazon Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testFinished = TripInfo(
      status: TripStatus.finished,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'MCDONALD\'S',
        tripName: 'McDonald\'s Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );
    var testCanceled = TripInfo(
      status: TripStatus.canceled,
      tripNo: 123455,
      company: CompanyInfo(
        companyName: 'AMAZON',
        tripName: 'Amazon Morning Trip',
      ),
      busNo: '32-145489',
      passengers: 25,
      busLine: BusLineInfo(
        fromTime: DateTime(2022, 10, 8, 16, 0),
        toTime: DateTime(2022, 10, 10, 16, 30),
        courseName: 'KHALDA - ALNEYMAT ST.',
        cityName: 'AMMAN',
      ),
    );

    return DefaultTabController(
      length: tabCount,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                margin:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 61 * SizeConfig.scaleY,
                child: Image.asset('assets/images/home_icon2.png'),
              ),
              ButtonsTabBar(
                backgroundColor: kColorPrimaryBlue,
                borderColor: kColorPrimaryBlue,
                unselectedBackgroundColor: Colors.transparent,
                unselectedBorderColor: const Color(0xFFB3B3B3),
                borderWidth: 1,
                radius: 100,
                //height: 62 * SizeConfig.scaleX,
                // contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                labelStyle: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Colors.white,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Color(0xFFB3B3B3),
                ),
                tabs: tabIDArray
                    .map((t) => Tab(
                  child: Container(
                    alignment: Alignment.center,
                    width: 132 * SizeConfig.scaleX,
                    child: Text(_getTabTextFromID(t)),
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                Column(children: [
                  TripCard(info: testStarted, onPressed: () {}),
                  const SizedBox(height: 20),
                  TripCard(info: testStarted, onPressed: () {}),
                ]),
                Center(
                  child: TripCard(info: testPending, onPressed: () {}),
                ),
                Center(
                  child: TripCard(info: testAccepted, onPressed: () {}),
                ),
                Center(
                  child: TripCard(info: testRejected, onPressed: () {}),
                ),
                Center(
                  child: TripCard(info: testStarted, onPressed: () {}),
                ),
                Center(
                  child: TripCard(info: testFinished, onPressed: () {}),
                ),
                Center(
                  child: TripCard(info: testCanceled, onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

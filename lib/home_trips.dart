import 'package:flutter/material.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/home_trips_list.dart';

class HomeTripsPage extends StatefulWidget {
  const HomeTripsPage({Key? key}) : super(key: key);

  @override
  State<HomeTripsPage> createState() => _HomeTripsPageState();
}

class _HomeTripsPageState extends State<HomeTripsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final primaryTabBarHMargin = 150 * SizeConfig.scaleX;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 130 * SizeConfig.scaleY,
            margin: EdgeInsets.only(
              left: primaryTabBarHMargin,
              right: primaryTabBarHMargin,
              top: 50 * SizeConfig.scaleY,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFB3B3B3),
              borderRadius: BorderRadius.circular(100),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: kColorPrimaryBlue,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                fontSize: 32 * SizeConfig.scaleY,
              ),
              tabs: const [
                Tab(text: 'TODAY TRIPS'),
                Tab(text: 'PAST TRIPS'),
              ],
            ),
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // TODAY TRIPS view
                TripsListView(listType: TripsListType.todayTrips, today: true),

                // PAST TRIPS view
                TripsListView(listType: TripsListType.pastTrips, today: false),
              ],
            ),
          ),
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height / 20,
                    margin: EdgeInsets.only(left: 20, top: 10, bottom: 10,),
                    child: TextField(
                      style: const TextStyle(
                          fontSize: 13
                      ),
                      decoration: InputDecoration(
                          enabled: false,
                          prefixIcon: Padding(
                            padding: EdgeInsetsDirectional.only(start: 10,top: 10, bottom: 10),
                            // padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 10),
                            child: Image.asset("assets/navbar_trip.png", color: Colors.red,),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(1),
                          hintText: "TRIPS",
                          hintStyle: const TextStyle(
                              color: Colors.red
                          ),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50))
                          )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/notification');
                    },
                    child: Container(
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.08, top: 20, bottom: 15),
                          child: Image.asset("assets/navbar_notification.png"),
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Container(
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: MediaQuery.of(context).size.width * 0.1, top: 20, bottom: 15),
                          child: Image.asset("assets/navbar_user.png"),
                        )
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}

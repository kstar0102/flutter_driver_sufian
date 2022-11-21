import 'package:flutter/material.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/home_trips_list.dart';

class TripDetailPending extends StatefulWidget {
  const TripDetailPending({Key? key}) : super(key: key);

  @override
  State<TripDetailPending> createState() => _TripDetailPendingState();
}

class _TripDetailPendingState extends State<TripDetailPending>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50))
        ),
        child: Column(
          
        )
      ),
    );
  }
}

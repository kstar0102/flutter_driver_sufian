import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

// trip status enum.
enum TripStatus {
  pending,
  accepted,
  rejected,
  started,
  finished,
  canceled,
}

// trip status strings.
const List<String> kTripStatusStrings = [
  'Pending',
  'Accepted',
  'Rejected',
  'Started',
  'Finished',
  'Canceled',
];

// trip status colors.
const List<Color> kTripStatusColors = [
  Color(0xFFFBB03B),
  Color(0xFFA67C52),
  Color(0xFFED1C24),
  Color(0xFF29ABE2),
  Color(0xFF39B54A),
  Color(0xFFFF00FF),
];

///-----------------------------------------------------------------------------
/// CompanyInfo
///-----------------------------------------------------------------------------

class CompanyInfo {
  String companyName;
  String tripName;

  CompanyInfo({
    required this.companyName,
    required this.tripName,
  });

  String getCompanyImgPath() {
    final lowerStr = companyName.toLowerCase();
    return 'assets/images/company_$lowerStr.png';
  }
}

///-----------------------------------------------------------------------------
/// BusLineInfo
///-----------------------------------------------------------------------------

class BusLineInfo {
  DateTime fromTime;
  DateTime toTime;
  String courseName;
  String cityName;

  BusLineInfo({
    required this.fromTime,
    required this.toTime,
    required this.courseName,
    required this.cityName,
  });

  String getFromDateStr() {
    final DateFormat formatter = DateFormat('MMM d y (E)');
    return formatter.format(fromTime);
  }

  String getFromTimeStr() {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(fromTime);
  }

  String getToDateStr() {
    final DateFormat formatter = DateFormat('MMM d y (E)');
    return formatter.format(toTime);
  }

  String getToTimeStr() {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(toTime);
  }

  String getDurTimeStr() {
    final Duration duration = toTime.difference(fromTime);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));

    return '${duration.inHours}:$twoDigitMinutes Min';
  }
}

///-----------------------------------------------------------------------------
/// TripInfo
///-----------------------------------------------------------------------------

class TripInfo {
  TripStatus status;
  int tripNo;
  CompanyInfo company;
  String busNo;
  int passengers;
  BusLineInfo busLine;

  TripInfo({
    this.status = TripStatus.pending,
    required this.tripNo,
    required this.company,
    required this.busNo,
    required this.passengers,
    required this.busLine,
  });

  String getStatusImgPath() {
    final indexStr = status.index;
    return 'assets/images/trip_status$indexStr.png';
  }

  String getStatusStr() {
    return kTripStatusStrings[status.index];
  }

  Color getStatusColor() {
    return kTripStatusColors[status.index];
  }

  String getTripNoStr() {
    return 'Trip # $tripNo';
  }
}

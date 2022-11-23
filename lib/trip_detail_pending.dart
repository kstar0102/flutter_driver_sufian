
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:driver_app/widgets/constants.dart';
import 'package:driver_app/home_trips_list.dart';

import 'widgets/ctm_painter.dart';

const List<String> list = <String>['Pending', 'Cancel', 'Reject', 'Fake'];
const List<String> busSizeList = <String>['10', '20', '30', '40'];


enum SingingCharacter { notChange, pending, cancel, fake }


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
  String dropdownValue = list.first;
  String busSizeValue = busSizeList.first;

  SingingCharacter? _character = SingingCharacter.notChange;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/bg_trip.png",
              ),
              fit: BoxFit.fill
            )
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 20,
                      height: 40,
                      margin: EdgeInsets.only(top: 35, left: 30),
                      child: CustomPaint(
                        painter: BackArrowPainter(),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/5,),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      "TRIP #12345",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          decoration: TextDecoration.none
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width/3,),
                ],
              ),
              SizedBox(height: 50,),
              Center(
                child: Container(
                    height: MediaQuery.of(context).size.height / 1.25,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: 30
                          )
                        ]
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "STATUS",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                              value: dropdownValue,
                              isExpanded: true,
                              buttonHeight: 30,
                              buttonDecoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  color:  list.length == 0 ? Colors.black26 : Colors.transparent
                              ),
                              iconSize: 20,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.deepOrangeAccent, size: 30,),
                              style: const TextStyle(color: Colors.black54),
                              disabledHint: Text("Pending", style: TextStyle(color: Colors.black54, fontSize: 11),),
                              items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      child: Text(value, style: TextStyle(color: Colors.black54, fontSize: 11),),
                                      value: value,
                                    );
                                  }
                              ).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              }
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.emergency, color: Colors.red, size: 7,
                                ),
                                Text(
                                  "CHANGE STATUS",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 25,
                              child: ListTile(
                                horizontalTitleGap: -5,
                                visualDensity: VisualDensity(horizontal: 0,vertical: 0),
                                contentPadding: EdgeInsets.all(0),
                                title: const Text('Don\'t Change', style: TextStyle(fontSize: 11, color: Colors.black45)),
                                leading: Radio<SingingCharacter>(
                                  activeColor: Colors.deepOrangeAccent,
                                  value: SingingCharacter.notChange,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                              child: ListTile(
                                horizontalTitleGap: -5,
                                contentPadding: EdgeInsets.all(0),
                                title: const Text('Set as Pending', style: TextStyle(fontSize: 11, color: Colors.black45)),
                                leading: Radio<SingingCharacter>(
                                  activeColor: Colors.deepOrangeAccent,
                                  value: SingingCharacter.pending,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                              child: ListTile(
                                horizontalTitleGap: -5,
                                contentPadding: EdgeInsets.all(0),
                                title: const Text('Set as Canceled', style: TextStyle(fontSize: 11, color: Colors.black45)),
                                leading: Radio<SingingCharacter>(
                                  activeColor: Colors.deepOrangeAccent,
                                  value: SingingCharacter.cancel,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                              child: ListTile(
                                horizontalTitleGap: -5,
                                contentPadding: EdgeInsets.all(0),
                                title: const Text('Set as Fake', style: TextStyle(fontSize: 11, color: Colors.black45)),
                                leading: Radio<SingingCharacter>(
                                  activeColor: Colors.deepOrangeAccent,
                                  value: SingingCharacter.fake,
                                  groupValue: _character,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.emergency, color: Colors.red, size: 7,
                                ),
                                Text(
                                  "BUS SIZE",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                              value: busSizeValue,
                              isExpanded: true,
                              buttonHeight: 30,
                              buttonDecoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  color:  busSizeList.length == 0 ? Colors.black26 : Colors.transparent
                              ),
                              iconSize: 20,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.deepOrangeAccent, size: 30,),
                              style: const TextStyle(color: Colors.black54),
                              disabledHint: Text("No Size", style: TextStyle(color: Colors.black54, fontSize: 11),),
                              items: busSizeList.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      child: Text(value, style: TextStyle(color: Colors.black54, fontSize: 11),),
                                      value: value,
                                    );
                                  }
                              ).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  busSizeValue = value!;
                                });
                              }
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.emergency, color: Colors.red, size: 7,
                                ),
                                Text(
                                  "BUS NO.",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26)
                          ),
                          child: Text(
                            "12-32654",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 11
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 5),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.emergency, color: Colors.red, size: 7,
                                ),
                                Text(
                                  "DRIVER",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26)
                          ),
                          child: Text(
                            "Sufan Abu Laban",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 11
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 5),
                            child: Row(
                              children: [
                                Text(
                                  "DETAILS",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                          width: double.infinity,
                          height: 80,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26)
                          ),
                          child: Text(
                            "",
                            style: TextStyle(
                                fontSize: 12
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: OutlinedButton(
                            onPressed: () {

                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                side: const BorderSide(
                                  color: Colors.orange,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width/1.7, 30),
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/10, right: MediaQuery.of(context).size.width/10, top: 10, bottom: 10)
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ),
                      ],
                    )
                ),
              ),
            ],
          )
        )
    );
  }
}

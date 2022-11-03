
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EditInputField extends StatefulWidget {
  final String displayName;
  final TextEditingController myController;
  const EditInputField({Key? key, required this.displayName, required this.myController}) : super(key: key);
  @override
  State<EditInputField> createState() => _EditInputFieldState();
}

class _EditInputFieldState extends State<EditInputField> {

  // _selectDate(BuildContext context) async {
  //   DateTime newSelectedDate = await showDatePicker(
  //       context: context,
  //       initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
  //       firstDate: DateTime(2000),
  //       lastDate: DateTime(2040),
  //       builder: (BuildContext context, Widget child) {
  //         return Theme(
  //           data: ThemeData.dark().copyWith(
  //             colorScheme: ColorScheme.dark(
  //               primary: Colors.deepPurple,
  //               onPrimary: Colors.white,
  //               surface: Colors.blueGrey,
  //               onSurface: Colors.yellow,
  //             ),
  //             dialogBackgroundColor: Colors.blue[500],
  //           ),
  //           child: child,
  //         );
  //       });
  //
  //   if (newSelectedDate != null) {
  //     _selectedDate = newSelectedDate;
  //     _textEditingController
  //       ..text = DateFormat.yMMMd().format(_selectedDate)
  //       ..selection = TextSelection.fromPosition(TextPosition(
  //           offset: _textEditingController.text.length,
  //           affinity: TextAffinity.upstream));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    bool isSecure = false;
    bool isPhone = false;
    if (widget.displayName == "Phone") {
      isPhone = true;
    }
    bool isBirth = false;
    if (widget.displayName == "Date of Birth" || widget.displayName == "New Password" ) {
      isBirth = true;
    }
    bool isPassword = false;
    if (widget.displayName == "Current Password" || widget.displayName == "Confirm Password" ) {
      isBirth = true;
      isPassword = true;
      isSecure = true;
    }
    if (widget.displayName == "New Password") {
      isSecure = true;
    }
    SizedBox general = SizedBox(
      child: Column(
        children: [
          isBirth ? Container(
            // isPassword ? EdgeInsetsDirectional.only(end: MediaQuery.of(context).size.width/3, bottom: 2) : EdgeInsetsDirectional.only(end: MediaQuery.of(context).size.width/2.6, bottom: 2),
            margin: isPassword ? EdgeInsetsDirectional.only(end: MediaQuery.of(context).size.width/3, bottom: 2) : EdgeInsetsDirectional.only(end: MediaQuery.of(context).size.width/2.6, bottom: 2),
            child: Text(
              widget.displayName,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
          ) :
          Container(
            margin: EdgeInsetsDirectional.only(end: MediaQuery.of(context).size.width/2.2, bottom: 2),
            child: Text(
              widget.displayName,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 30/1.7,
                height: 35,
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange,
                              width: 1
                          ),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50), topLeft: Radius.circular(50)
                          )
                      ),
                      filled: true,
                      fillColor: Colors.orange
                  ),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width-30)/1.7,
                height: 35,
                child: TextField(
                  obscureText: isSecure,
                  controller: widget.myController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50), topRight: Radius.circular(50),
                        ),
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50), topRight: Radius.circular(50),
                        ),
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10)
                  ),
                  // onTap: ,
                ),
              )
            ],
          ),
        ],
      ),
    );
    SizedBox phone = SizedBox(
      child: Column(
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(end: MediaQuery.of(context).size.width/2.2, bottom: 2),
            child: Text(
              widget.displayName,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 100/1.7,
                height: 35,
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange,
                              width: 1
                          ),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50), topLeft: Radius.circular(50)
                          )
                      ),
                      filled: true,
                      fillColor: Colors.orange,
                      hintText: "+962",
                      contentPadding: EdgeInsets.only(left: 15, right: 10, top: 10, ),
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 13
                      )
                  ),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width-100)/1.7,
                height: 35,
                child: TextField(
                  controller: widget.myController,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50), topRight: Radius.circular(50),
                        ),
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(50), topRight: Radius.circular(50),
                        ),
                        borderSide: BorderSide(
                          color: Colors.orange,
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(10)
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
    SizedBox retVal = SizedBox();
    retVal = isPhone ? phone : general;
    return retVal;
  }
}

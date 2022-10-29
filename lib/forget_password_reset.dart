import 'package:flutter/material.dart';

import 'widgets/button_field.dart';
import 'widgets/input_field.dart';

class ForgetPasswordReset extends StatefulWidget {
  const ForgetPasswordReset({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordReset> createState() => _ForgetPasswordResetState();
}

class _ForgetPasswordResetState extends State<ForgetPasswordReset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Back',
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: Image.asset("assets/btn_back.png", width: 30, height: 30,),
        // child: const Icon(Icons.navigate_before),
      ),
      body: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/bg.png"), fit: BoxFit.cover)
            ),
            height: MediaQuery.of(context).size.height,
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/10),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/message_success.png",
                    width: MediaQuery.of(context).size.width/2.8,
                    height: MediaQuery.of(context).size.width/2.8,
                    alignment: Alignment.center,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height/18
                  ),
                  Text(
                    "FORGET PASSWORD",
                    style: TextStyle(
                      fontSize: 2.7 * MediaQuery.of(context).size.height * 0.01,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height/28
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: 1.8 * MediaQuery.of(context).size.height * 0.01,
                            color: Colors.white
                        ),
                        text: "Enter your new password below"
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height/8
                  ),
                  const InputField(inputType: "new_password"),
                  SizedBox(
                      height: MediaQuery.of(context).size.height/25
                  ),
                  const InputField(inputType: "confirm_password"),
                  SizedBox(
                      height: MediaQuery.of(context).size.height/18
                  ),
                  ButtonField(
                      buttonType: "reset",
                      onPressedCallback: () {
                      }
                  ),

                ],
              ),
            )
        ),
      ),
    );
  }
}

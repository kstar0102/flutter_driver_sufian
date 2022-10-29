
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {

  final String inputType;

  const InputField({Key? key, required this.inputType}) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    TextInputType textInputType = TextInputType.text;
    bool isObscure = false;
    String displayName = "";

    switch (widget.inputType) {
      case "username":
        textInputType = TextInputType.text;
        displayName = "USERNAME";
        break;
      case "password":
        textInputType = TextInputType.text;
        displayName = "PASSWORD";
        isObscure = true;
        break;
      case "new_password":
        textInputType = TextInputType.text;
        displayName = "NEW PASSWORD";
        isObscure = true;
        break;
      case "confirm_password":
        textInputType = TextInputType.text;
        displayName = "CONFIRM PASSWORD";
        isObscure = true;
        break;
      case "mobile":
        textInputType = TextInputType.number;
        displayName = "MOBILE NUMBER";
        break;
      default :
        break;
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height/19,
      width: MediaQuery.of(context).size.width/1.4,
      child: TextField(
        keyboardType: textInputType,
        obscureText: isObscure,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          label: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              displayName
            ),
          ),
          labelStyle: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.white, width: 1.5)
          ),
        ),
        style: const TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}

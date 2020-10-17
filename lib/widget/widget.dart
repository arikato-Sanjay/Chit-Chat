import 'package:flutter/material.dart';

Widget AppBarMain(BuildContext context){
  return AppBar(
    title: Text("Chit Chat"),
  );
}

InputDecoration textFieldDecoration(String hintText){
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      )
  );
}
import 'package:chit_chat/screens/SignUpScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'SignInScreen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool signIn = true;

  @override
  Widget build(BuildContext context) {
    if(signIn){
      return SignIn(switchScreen);
    } else{
      return SignUp(switchScreen);
    }
  }

  void switchScreen(){
    setState(() {
      signIn = !signIn;
    });
  }
}

import 'package:chit_chat/backendservices/HelperFunctions.dart';
import 'package:chit_chat/backendservices/authentication.dart';
import 'package:chit_chat/backendservices/databases.dart';
import 'package:chit_chat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ChatListScreen.dart';

class SignIn extends StatefulWidget {

  final Function switcher;
  SignIn(this.switcher);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();
  bool isLoading = false;
  AuthenticationMethods authenticationMethods = new AuthenticationMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailTEC,
                        validator: (input){
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(input)
                              ? null : "Enter valid mailId";
                        },
                        style: TextStyle(
                            color: Colors.white
                        ),
                          decoration: InputDecoration(
                            labelText: "Enter email-Id",
                            labelStyle: new TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide:  BorderSide(color: Colors.white ),
                            ),
                          )
                      ),
                      SizedBox(height: 8,),
                      TextFormField(
                        controller: passwordTEC,
                        obscureText: true,
                        validator: (input){
                          return input.isEmpty || input.length<6 ? "Please Enter Password" : null;
                        },
                        style: TextStyle(
                            color: Colors.white
                        ),
                          decoration: InputDecoration(
                            labelText: "Enter Password",
                            labelStyle: new TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: new OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                              borderSide:  BorderSide(color: Colors.white ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    forgetPassword();
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Text("Forgot Password:(", style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                        ),)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xff97ABFF),
                              const Color(0xff123597)
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign In", style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 22),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            const Color(0xff97ABFF),
                            const Color(0xff123597)
                          ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign In with Google", style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                  ),),
                ),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("New to Chit Chat? ", style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),),
                    GestureDetector(
                      onTap: (){
                        widget.switcher();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Register now", style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.underline
                        ),),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signIn(){

    if(formKey.currentState.validate()){

      SharedPreferencesFunctions.saveUserEmail(emailTEC.text);
      databaseMethods.getUserDataUsingEmail(emailTEC.text).then((val){
        snapshot = val;
        SharedPreferencesFunctions.saveUserName(snapshot.documents[0]
            .data["name"]);
      });

      setState(() {
        isLoading = true;
      });

      authenticationMethods.signInWithEAndP(emailTEC.text, passwordTEC.text).
          then((value){
            if(value != null){
              SharedPreferencesFunctions.saveUserLogInState(true);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatListScreen()
              ));
            }
      });
    }
  }

  forgetPassword(){
    if(emailTEC.text.isNotEmpty) {
      authenticationMethods.resetPassword(emailTEC.text).then((value) {
        SnackBar(content: Text(
            "Password Reset Link has been sent"),
        );
        print("link sent");
      });
    } else {
      SnackBar(content: Text(
          "Email field can't be empty"),
      );
    }
  }

}

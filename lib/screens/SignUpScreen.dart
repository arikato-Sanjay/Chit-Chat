import 'package:chit_chat/backendservices/HelperFunctions.dart';
import 'package:chit_chat/backendservices/authentication.dart';
import 'package:chit_chat/backendservices/databases.dart';
import 'package:chit_chat/screens/ChatListScreen.dart';
import 'package:chit_chat/widget/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {

  final Function switcher;
  SignUp(this.switcher);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool loading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTEC = new TextEditingController();
  TextEditingController emailTEC = new TextEditingController();
  TextEditingController passwordTEC = new TextEditingController();

  AuthenticationMethods authenticationMethods = new AuthenticationMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(context),
      body: loading ? Container(
        child: Center(
            child: CircularProgressIndicator()),
      ):
      SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: usernameTEC,
                        validator: (input){
                          return input.isEmpty || input.length<3 ? "Username too short" : null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Enter Username",
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
                        controller: emailTEC,
                        validator: (input){
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(input)
                              ? null : "Enter valid mailId";
                        },
                        style: TextStyle(color: Colors.white),
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
                        style: TextStyle(color: Colors.white),
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
                SizedBox(
                  height: 14,
                ),
                GestureDetector(
                  onTap: (){
                    signUpNow();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff97ABFF),
                          const Color(0xff123597)
                        ]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Sign Up with Google",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already a member? ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: (){
                        widget.switcher();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "SignIn now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ], // <Widget>[]
            ),
          ),
        ),
      ),
    );
  }

  signUpNow(){
    if(formKey.currentState.validate()){

      Map<String, String> userData = {
        "name" : usernameTEC.text,
        "email" : emailTEC.text
      };

      SharedPreferencesFunctions.saveUserName(usernameTEC.text);
      SharedPreferencesFunctions.saveUserEmail(emailTEC.text);

      setState(() {
        loading = true;
      });

      authenticationMethods.signUpWithEAndP(emailTEC.text, passwordTEC.text).then((e){
        //print("$e");

        databaseMethods.uploadUserData(userData);
        SharedPreferencesFunctions.saveUserLogInState(true);

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatListScreen()
        ));
      });
    }
  }
}

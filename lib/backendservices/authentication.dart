import 'package:chit_chat/usersupporter/users.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationMethods{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Users _users(FirebaseUser user){
    return user!=null ? Users(userId: user.uid) : null;
  }

  Future signInWithEAndP(String email, String password) async{
    try{
     AuthResult result = await _firebaseAuth.signInWithEmailAndPassword
        (email: email, password: password);
     FirebaseUser firebaseUser = result.user;
     return _users(firebaseUser);
    } catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEAndP(String mail, String password) async {
    try{
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword
        (email: mail, password: password);
      FirebaseUser firebaseUser = result.user;
      return _users(firebaseUser);
    } catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String mail) async{
    try{
      return await _firebaseAuth.sendPasswordResetEmail(email: mail);
    } catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return _firebaseAuth.signOut();
    } catch(e){
      print(e.toString());
    }
  }
}
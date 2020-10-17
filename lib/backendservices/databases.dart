import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserData(String username){
    return Firestore.instance.collection("chitchatters")
        .where("name", isEqualTo: username).getDocuments().catchError((e){
          print(e.toString());
    });
  }

  getUserDataUsingEmail(String userEmail){
    return Firestore.instance.collection("chitchatters")
        .where("email", isEqualTo: userEmail).getDocuments().catchError((e){
      print(e.toString());
    });
  }

  uploadUserData(userData){
    Firestore.instance.collection("chitchatters").add(userData).catchError((e){
      print(e.toString);
    });
  }
  
  createChatRoom(String chatRoomID, chatRoomDataMapping){
    Firestore.instance.collection("chatroom").document(chatRoomID)
        .setData(chatRoomDataMapping).catchError((e){
          print(e.toString());
    });
  }

  addMessages(String chatRommId, conversationMap){
    Firestore.instance.collection("chatroom")
        .document(chatRommId)
        .collection("messages")
        .add(conversationMap).catchError((e){
          print(e.toString());
    });
  }

  getMessages(String chatRommId) async{
    return await Firestore.instance.collection("chatroom")
        .document(chatRommId)
        .collection("messages")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }
  
  getChatList(String username) async{
    return await Firestore.instance.collection("chatroom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
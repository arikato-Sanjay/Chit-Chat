import 'package:chit_chat/backendservices/HelperFunctions.dart';
import 'package:chit_chat/backendservices/authentication.dart';
import 'package:chit_chat/backendservices/constant.dart';
import 'package:chit_chat/backendservices/databases.dart';
import 'package:chit_chat/screens/ChatRoomScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'SearchUserScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  AuthenticationMethods authenticationMethods = new AuthenticationMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatListStream;
  QuerySnapshot querySnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chit Chat"),
        actions: [
          GestureDetector(
            onTap: (){
              authenticationMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate())
              );},
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
            child: chatList(),
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchUser()
          ));
        },
      ),
    );
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async{
    Constants.ownUsername = await SharedPreferencesFunctions.getUserName();
    databaseMethods.getChatList(Constants.ownUsername).then((list){
      setState(() {
        chatListStream = list;
      });
    });
  }

  Widget chatList(){
    return StreamBuilder(
      stream: chatListStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return Slidable(
                key: ValueKey(index),
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: "Delete Chat",
                    color: Colors.red,
                    icon: Icons.delete,
                    closeOnTap: false,
                    onTap: (){
                      Firestore.instance.collection("chatroom")
                          .document("${snapshot.data.documents[index]
                          .data["chatRoomId"]}").delete();
                      print("${snapshot.data.documents[index]
                          .data["chatRoomId"]}");
                      Toast.show("Chat Deleted Successfully", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    },
                  )
                ],
                child: ChatListTile(
                  username: snapshot.data.documents[index].data["chatRoomId"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(Constants.ownUsername, ""),
                  chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                ),
              );
            }) : Container();
      },
    );
  }
}

class ChatListTile extends StatelessWidget {
  final String username;
  final String chatRoomId;
  ChatListTile({this.username,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationRoomScreen(
            chatRoomId, username.toString().replaceAll("_", "")
              .replaceAll(Constants.ownUsername, ""),)
        ));
      },
      child: Container(
        color: Colors.black54,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${username.substring(0,1).toUpperCase()}", style:
                TextStyle(
                  color: Colors.black,
                  fontSize: 20
                ),),
            ),
            SizedBox(width: 10,),
            Text(username, style: TextStyle(
              color: Colors.white,
              fontSize: 18
            ),)
          ],
        ),
      ),
    );
  }
}


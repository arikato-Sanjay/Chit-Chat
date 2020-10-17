import 'package:chit_chat/backendservices/constant.dart';
import 'package:chit_chat/backendservices/databases.dart';
import 'package:chit_chat/screens/ChatRoomScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchUser extends StatefulWidget {
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  TextEditingController searchTEC = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot querySnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chit Chat"),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.black45,
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: searchTEC,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          decoration: InputDecoration(
                              hintText: "Search....",
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none),
                        )),
                        GestureDetector(
                          onTap: () {
                            searchUser();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  const Color(0x36FFFFF),
                                  const Color(0x0FFFFFF)
                                ]),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Image.asset("assets/images/122132.png"),)
                        )
                      ],
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            itemCount: querySnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return userTile(
                userName: querySnapshot.documents[index].data["name"],
                userEmail: querySnapshot.documents[index].data["email"],
              );
            })
        : Container();
  }

  searchUser() {
    String chatterName = searchTEC.text;
    if (chatterName.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserData(chatterName).then((value) {
        querySnapshot = value;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  //sending user to the chat room using push replacement
  redirectingToChatRoom(String userName) {
    List<String> users = [userName, Constants.ownUsername];
    String chatRoomId = getChatRoomId(userName, Constants.ownUsername);
    Map<String, dynamic> chatRoomDataMapping = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    String recipient = searchTEC.text;
    DatabaseMethods().createChatRoom(chatRoomId, chatRoomDataMapping);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>
            ConversationRoomScreen(chatRoomId,recipient)
        )
    );
  }

  Widget userTile({String userName, String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              redirectingToChatRoom(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(32)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Message",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }
}



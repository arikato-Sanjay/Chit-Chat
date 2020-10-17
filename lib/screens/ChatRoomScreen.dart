import 'package:chit_chat/backendservices/constant.dart';
import 'package:chit_chat/backendservices/databases.dart';
import 'package:flutter/material.dart';

class ConversationRoomScreen extends StatefulWidget {
  final String chatRoomId;
  final String recipient;
  ConversationRoomScreen(this.chatRoomId,@required this.recipient);

  @override
  _ConversationRoomScreenState createState() => _ConversationRoomScreenState();
}

class _ConversationRoomScreenState extends State<ConversationRoomScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTEC = new TextEditingController();
  Stream messgaesStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.recipient}"),
        ),
      body: Container(
        child: Stack(
          children: [
            MessageList(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(40)),
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageTEC,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Send Message...",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    )),
                    GestureDetector(
                        onTap: () {
                          sendMessage();
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
                          child: Image.asset("assets/images/sendpic.png"),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MessageList() {
    return StreamBuilder(
      stream: messgaesStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessagesTile(
                      snapshot.data.documents[index].data["message"],
                      snapshot.data.documents[index].data["sender"] ==
                          Constants.ownUsername);
                })
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageTEC.text.isNotEmpty) {
      Map<String, dynamic> messgaeMap = {
        "message": messageTEC.text,
        "sender": Constants.ownUsername,
        "timeStamp": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addMessages(widget.chatRoomId, messgaeMap);
      setState(() {
        messageTEC.text = "";
      });
    }
  }

  @override
  void initState() {
    databaseMethods.getMessages(widget.chatRoomId).then((val) {
      setState(() {
        messgaesStream = val;
      });
    });
    super.initState();
  }
}

class MessagesTile extends StatelessWidget {
  final String message;
  final bool sender;

  MessagesTile(this.message, this.sender);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: sender ? 4 : 20, right: sender ? 20 : 4),
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width,
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 26, vertical: 18),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: sender
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)]),
            borderRadius: sender
                ? BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25))
                : BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

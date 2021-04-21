import 'package:chat21_flutter/model/messageModel.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:chat21_flutter/controller/firebaseController.dart';
import 'package:chat21_flutter/controller/chat21Controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:intl/intl.dart';

/////UI設計參考
/////https://www.freecodecamp.org/news/build-a-chat-app-ui-with-flutter/

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  String name;
  String imageUrl;
  String recevierId;
  String recevierIdFullname;
  String senderId;
  // String senderIdFullname;
  String channelType;
  ChatDetailPage({
    @required this.name,
    @required this.channelType,
    @required this.imageUrl,
    @required this.recevierId,
    @required this.recevierIdFullname,
    @required this.senderId,
    // @required this.senderIdFullname,
  });
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  StreamSubscription<Event> firebaseDBSubscription;
  final TextEditingController _chatController = new TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> lists = [];

  void _submitText(
      String text,
      String firebaseIdToken,
      String senderId,
      String senderFullname,
      String recipientId,
      String recipientFullname,
      String messageText,
      String channelType,
      String type,
      String attributes,
      String metadata) {
    sendMessage(
        firebaseIdToken,
        senderId,
        senderFullname,
        recipientId,
        recipientFullname,
        messageText,
        channelType,
        type,
        attributes,
        metadata);
    print(text);
  }

  void _submitText2(
    String text,
  ) {
    print(text);
  }

  final dbRef = FirebaseDatabase.instance
      .reference()
      .child("apps")
      .child("tilechat")
      .child("users");
  @override
  void initState() {
    super.initState();
    firebaseDBSubscription = dbRef
        .child(widget.senderId)
        .child("messages")
        .child(widget.recevierId)
        .onValue
        .listen((Event event) {
      if (event.snapshot.value != null) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    firebaseDBSubscription.cancel();
  }

  File imageFile;
  @override
  Widget build(BuildContext context) {
    var account = Provider.of<FirebaseController>(context);
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child("apps")
        .child("tilechat")
        .child("users")
        .child(account.userprovider.uid)
        .child("messages")
        .child(widget.recevierId);
    final dbcontact = FirebaseDatabase.instance
        .reference()
        .child("apps")
        .child("tilechat")
        .child("contacts");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageUrl),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.recevierIdFullname,
                        // widget.recevierIdFullname,
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: FutureBuilder(
              future: dbRef.once(),
              builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                if (snapshot.hasData) {
                  lists.clear();
                  Map<dynamic, dynamic> values = snapshot.data.value;
                  values.forEach((key, values) {
                    lists.add(new MessageModel.fromJson(
                        key, values, account.userprovider.uid));
                  });
                  lists.sort((a, b) => (a.timestamp).compareTo(b.timestamp));
                  //////Scroll to bottom method https://www.programmersought.com/article/72374377373/
                  ///https://smarx.com/posts/2020/08/automatic-scroll-to-bottom-in-flutter/
                  if (lists.length > 0)
                    Timer(
                        Duration(milliseconds: 1000),
                        () => _scrollController.jumpTo(
                            _scrollController.position.maxScrollExtent));

                  return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      itemCount: lists.length,
                      padding: EdgeInsets.only(top: 16),
                      itemBuilder: (context, index) {
                        var date = DateTime.fromMillisecondsSinceEpoch(
                            lists[index].timestamp);
                        var formattedDate = DateFormat.jm().format(date);
                        if (lists[index].sender != "system") {
                          return new FutureBuilder(
                              future:
                                  dbcontact.child(lists[index].sender).once(),
                              builder: (context,
                                  AsyncSnapshot<DataSnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  var fname = snapshot.data.value["firstname"];
                                  var lname = snapshot.data.value["lastname"];
                                  String fullname = fname + lname;
                                  return Container(
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 10,
                                          bottom: 10),
                                      child: Align(
                                          alignment:
                                              (lists[index].messageType ==
                                                      "receiver"
                                                  ? Alignment.topLeft
                                                  : Alignment.topRight),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                // lists[index].sender,
                                                (lists[index].messageType ==
                                                        "receiver"
                                                    ? fullname
                                                    : ""),
                                                // senderIdFullname,
                                                style: TextStyle(fontSize: 6),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: (lists[index]
                                                              .messageType ==
                                                          "receiver"
                                                      ? Colors.grey.shade200
                                                      : Colors.blue[200]),
                                                ),
                                                padding: EdgeInsets.all(16),
                                                child: Text(
                                                  lists[index].messageContent,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                              Text(
                                                formattedDate,
                                                style: TextStyle(fontSize: 6),
                                              )
                                            ],
                                          )));
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                        } else {
                          return Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 10, bottom: 10),
                              child: Align(
                                  alignment:
                                      (lists[index].messageType == "receiver"
                                          ? Alignment.topLeft
                                          : Alignment.topRight),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        // lists[index].sender,
                                        (lists[index].messageType == "receiver"
                                            ? lists[index].sender
                                            : ""),
                                        // senderIdFullname,
                                        style: TextStyle(fontSize: 6),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: (lists[index].messageType ==
                                                  "receiver"
                                              ? Colors.grey.shade200
                                              : Colors.blue[200]),
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          lists[index].messageContent,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(fontSize: 6),
                                      )
                                    ],
                                  )));
                        }
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
                IconButton(icon: Icon(Icons.image), onPressed: () {}),
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16.0),
                        border: OutlineInputBorder(),
                        hintText: 'Type something...'),
                    controller: _chatController,
                    onSubmitted: _submitText2,
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => {
                          _submitText(
                              _chatController.text,
                              account.token2,
                              account.userprovider.uid,
                              account.userprovider.uid,
                              widget.name,
                              widget.name,
                              _chatController.text,
                              widget.channelType,
                              "text",
                              " ",
                              " "),
                          _chatController.clear()
                        }),
              ],
            ))
      ]),
    );
  }
}

import 'dart:async';

import 'package:chat21_flutter/widgets/conversationList.dart';
import 'package:flutter/material.dart';
import 'package:chat21_flutter/model/chatModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:chat21_flutter/controller/firebaseController.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MessageView extends StatefulWidget {
  String uid;
  MessageView({
    @required this.uid,
  });
  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  StreamSubscription<Event> firebaseDBSubscription;

  final dbRef = FirebaseDatabase.instance
      .reference()
      .child("apps")
      .child("tilechat")
      .child("users");
  final dbcontact = FirebaseDatabase.instance
      .reference()
      .child("apps")
      .child("tilechat")
      .child("contacts");
  final dbgroup = FirebaseDatabase.instance
      .reference()
      .child("apps")
      .child("tilechat")
      .child("groups");

  List<ChatModel> lists = [];

  @override
  void initState() {
    super.initState();
    firebaseDBSubscription = dbRef
        .child(widget.uid)
        .child("conversations")
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

  Widget build(BuildContext context) {
    var account = Provider.of<FirebaseController>(context);

    return Scaffold(
      body: FutureBuilder(
          future: dbRef
              .child(account.userprovider.uid)
              .child("conversations")
              .once(),
          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
            if (snapshot.hasData) {
              lists.clear();
              Map<dynamic, dynamic> values = snapshot.data.value;
              values.forEach((key, values) {
                lists.add(new ChatModel.fromJson(key, values));
              });
              lists.sort((a, b) => (b.timestamp).compareTo(a.timestamp));
              return new ListView.builder(
                  itemCount: lists.length,
                  padding: EdgeInsets.only(top: 16),
                  itemBuilder: (context, index) {
                    var date = DateTime.fromMillisecondsSinceEpoch(
                        lists[index].timestamp);
                    var formattedDate = DateFormat.yMd().add_jm().format(date);
                    if (lists[index].channel_type == "direct") {
                      return new FutureBuilder(
                          future: dbcontact
                              .child(lists[index].recipient_fullname)
                              .once(),
                          builder:
                              (context, AsyncSnapshot<DataSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              var fname = snapshot.data.value["firstname"];
                              var lname = snapshot.data.value["lastname"];
                              String fullname = fname + lname;
                              return ConversationList(
                                recevierId: lists[index].recipient_fullname,
                                recevierIdFullname: fullname,
                                senderId: account.userprovider.uid,
                                messageText: lists[index].last_message_text,
                                time: formattedDate,
                                imageUrl: "https://i.pinimg.com/originals/c1/65/1f/c1651f598d212acdfe551f103548e495.png",
                                channelType: lists[index].channel_type,
                                isMessageRead:
                                    (index == 0 || index == 3) ? true : false,
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                    } else if (lists[index].channel_type == "group") {
                      return new FutureBuilder(
                          future: dbgroup
                              .child(lists[index].recipient_fullname)
                              .once(),
                          builder:
                              (context, AsyncSnapshot<DataSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              var fullname = snapshot.data.value["name"];
                              return ConversationList(
                                recevierId: lists[index].recipient_fullname,
                                recevierIdFullname: fullname,
                                senderId: account.userprovider.uid,
                                messageText: lists[index].last_message_text,
                                time: formattedDate,
                                imageUrl: "https://i.pinimg.com/originals/c1/65/1f/c1651f598d212acdfe551f103548e495.png",
                                channelType: lists[index].channel_type,
                                isMessageRead:
                                    (index == 0 || index == 3) ? true : false,
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                    }
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

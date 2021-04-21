import 'package:flutter/cupertino.dart';

class MessageModel {
  String messageContent;
  String messageType;
  String userUid;
  int timestamp;
  String sender;
  MessageModel({
    @required this.messageContent,
    @required this.messageType,
    @required this.timestamp,
    @required this.sender,
  });

  MessageModel.fromJson(var key, var value, var userUid) {
    this.messageContent = value['text'];
    if (value['sender'] != userUid)
      this.messageType = "receiver";
    else
      this.messageType = "sender";
    this.timestamp = value['timestamp'];
    this.sender = value['sender'];
  }
}

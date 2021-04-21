import 'package:flutter/cupertino.dart';

class ChatModel {
  String recipient_fullname;
  String last_message_text;
  String imageURL;
  String channel_type;
  int timestamp;
  ChatModel(
      {@required this.recipient_fullname,
      @required this.last_message_text,
      this.imageURL,
      @required this.channel_type,
      @required this.timestamp});
  ChatModel.fromJson(var key, var value) {
    this.recipient_fullname = key;
    this.last_message_text = value['last_message_text'];
    this.imageURL = value['imageURL'];
    this.channel_type = value['channel_type'];
    this.timestamp = value['timestamp'];
  }
}

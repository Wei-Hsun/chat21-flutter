import 'package:chat21_flutter/view/chatDetailView.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConversationList extends StatefulWidget {
  String recevierId;
  String recevierIdFullname;
  String senderId;
  // String senderIdFullname;
  String messageText;
  String imageUrl;
  String time;
  String channelType;
  bool isMessageRead;
  ConversationList(
      {@required this.recevierId,
      @required this.recevierIdFullname,
      @required this.senderId,
      @required this.messageText,
      this.imageUrl,
      @required this.time,
      @required this.channelType,
      this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage(
            channelType: widget.channelType,
            recevierId: widget.recevierId,
            recevierIdFullname: widget.recevierIdFullname,
            senderId: widget.senderId,
            name: widget.recevierId,
            imageUrl: widget.imageUrl,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Color(0xff669999),
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.recevierIdFullname,
                            style: TextStyle(fontSize: 10),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: widget.isMessageRead
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:chat21_flutter/view/messageView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat21_flutter/controller/firebaseController.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var account = Provider.of<FirebaseController>(context);
    String uid = account.userprovider.uid;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xff669999),
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text(
          'Message',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  content: Text("Are you sure to exit current account."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, "/login", ModalRoute.withName('/')),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        elevation: 0.0,
      ),
      body: MessageView(
        uid: uid,
      ),
    );
  }
}

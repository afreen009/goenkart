import 'package:after_layout/after_layout.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page/splash.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _register() {
    _firebaseMessaging
        .getToken()
        .then((token) => print("your token is here $token"));
  }

  void getMessage() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        setState(() {
          _message = message['notification']['title'];
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        setState(() {
          _message = message['notification']['title'];
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on message $message');
        setState(() {
          _message = message['notification']['title'];
          //   Navigator.push(
          //  context,
          //  MaterialPageRoute(
          //   builder: (context) => Offers()
          //  ));
        });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
    print(_message);
    _register();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Goenkart',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF02BB9F),
          primaryColorDark: const Color(0xFF167F67),
          accentColor: const Color(0xFF02BB9F),
        ),
        home: Splash(),
      ),
    );
  }
}


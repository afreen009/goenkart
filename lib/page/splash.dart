import 'package:after_layout/after_layout.dart';
import 'package:goenkart/onboardingScreeen.dart';
import 'package:goenkart/webview.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    if (!await _checkUpdate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool _seen = (prefs.getBool('seen') ?? false);

      if (_seen) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => new WebViewWebPage()));
      } else {
        await prefs.setBool('seen', true);
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (context) => new OnboardingScreen()));
      }
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
      ),

    );
  }

  Future<bool> _checkUpdate() async {
    try { //ok
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailable) {
        showDialog(context: context, child: Text("Update available"));
      }
      return updateInfo.updateAvailable;
    } catch (e) {
      print(e);
      return false;
    }
  }
}


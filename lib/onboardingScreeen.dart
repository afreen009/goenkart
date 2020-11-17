import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'local_notications_helper.dart';
import 'webview.dart';



class OnboardingScreen extends StatefulWidget {
  //making list of pages needed to pass in IntroViewsFlutter constructor.
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final notifications = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    final settingsAndroid = AndroidInitializationSettings('launch_image');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewWebPage()),
      );
  final pages = [
    PageViewModel(
      textStyle: TextStyle(color:Colors.black),
        pageColor:  Colors.black12,
        // iconImageAssetPath: 'assets/air-hostess.png',
        bubble: Icon(Icons.smart_button_outlined,color: Colors.white,),
        bubbleBackgroundColor: Colors.red,
        body: Text(
          'Shopping app for amazing products',
          style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 25)
        ),
        
        title: Text(
          '',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 70),
        ),
        titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Center(
          child: Container(
            child: Image.asset(
              'assets/transparent1.png',
              height: 1000.0,
              width: 1000.0,
              fit: BoxFit.cover,
              // alignment: Alignment.center,
            ),
          ),
        )),
    PageViewModel(
      pageColor:  Colors.blue[200],
      iconImageAssetPath: 'assets/transparent2.png',
      body: Text(
        '',
        style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
      ),
      title: Text('We are a group of woman enterprenuers in Goa',style: TextStyle(color: Colors.white70),),
      mainImage: Image.asset(
        'assets/transparent2.png',
        height: 600.0,
          width: 600.0,
          fit: BoxFit.cover,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Colors.blueGrey[400],
      iconImageAssetPath: 'assets/transparent3.png',
      body: Text(
        '',
        style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
      ),
      title: Text('Everything you need is just a click away',style: TextStyle(color: Colors.white70)),
      mainImage: Image.asset(
        'assets/transparent3.png',
        height: 600.0,
          width: 600.0,
          fit: BoxFit.cover,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Colors.amber,
      iconImageAssetPath: 'assets/transparent4.png',
      body: Text(
        '',
        style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
      ),
      title: Text('Quick deliveries with secure payment',style: TextStyle(color: Colors.white70)),
      mainImage: Image.asset(
        'assets/transparent4.png',
        height: 600.0,
          width: 600.0,
          fit: BoxFit.cover,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoenKart', //title of app
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), //ThemeData
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: true,
          showBackButton: true,
          pageButtonsColor: Colors.black,
          onTapSkipButton: () {
            showOngoingNotification(notifications,
                  title: 'Welcome to Goenkart!', body: 'Your joining us has so hyped up!!');
            Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewWebPage()));
          },
          onTapDoneButton: () {
            showOngoingNotification(notifications,
                  title: 'Welcome to Goenkart!', body: 'Your joining us has so hyped up!!');
            Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewWebPage()));
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ), //IntroViewsFlutter
      ), //Builder
    ); //Material App
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:goenkart/page/second_page.dart';
// import 'local_notications_helper.dart';
// import 'webview.dart';

// class OnboardingScreen extends StatefulWidget {
//   @override
//   _OnboardingScreenState createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final notifications = FlutterLocalNotificationsPlugin();
//   final int _numPages = 4;
//   final PageController _pageController = PageController(initialPage: 0);
//   int _currentPage = 0;

//   List<Widget> _buildPageIndicator() {
//     List<Widget> list = [];
//     for (int i = 0; i < _numPages; i++) {
//       list.add(i == _currentPage ? _indicator(true) : _indicator(false));
//     }
//     return list;
//   }

//   Widget _indicator(bool isActive) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 150),
//       margin: EdgeInsets.symmetric(horizontal: 8.0),
//       height: 8.0,
//       width: isActive ? 24.0 : 16.0,
//       decoration: BoxDecoration(
//         color: isActive ? Colors.black : Colors.amber,
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//       ),
//     );
//   }
// @override
//   void initState() {
//     super.initState();
//     final settingsAndroid = AndroidInitializationSettings('launch_image');
//     final settingsIOS = IOSInitializationSettings(
//         onDidReceiveLocalNotification: (id, title, body, payload) =>
//             onSelectNotification(payload));

//     notifications.initialize(
//         InitializationSettings(settingsAndroid, settingsIOS),
//         onSelectNotification: onSelectNotification);
//   }

//   Future onSelectNotification(String payload) async => await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => WebViewExample()),
//       );
//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: AnnotatedRegion<SystemUiOverlayStyle>(
//     value: SystemUiOverlayStyle.light,
//     child: Container(
//       height: MediaQuery.of(context).size.height,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             child: PageView(
//               physics: ClampingScrollPhysics(),
//               controller: _pageController,
//               onPageChanged: (int page) {
//                 setState(() {
//                   _currentPage = page;
//                 });
//               },
//               children: <Widget>[
//                 Image(
//                   image: AssetImage(
//                     'assets/IMG-20201009-WA0049.jpg',
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//                 Image(
//                   image: AssetImage(
//                     'assets/IMG-20201009-WA0054.jpg',
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//                 Image(
//                   image: AssetImage(
//                     'assets/IMG-20201009-WA0056.jpg',
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//                 Image(
//                   image: AssetImage(
//                     'assets/IMG-20201009-WA0057.jpg',
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 80,
//             right: 10,
//                           child: Container(
//               alignment: Alignment.centerRight,
//               child: FlatButton(
//                 onPressed: () {
//                   print('inside skip');
//                   setState(() {
//                 showOngoingNotification(notifications,
//                   title: 'Welcome to Goenkart!', body: 'Your joining us has so hyped up!!');
//               });
//                   Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => WebViewExample()));
//                 },
//                 child: Chip(
//                   backgroundColor: Colors.amber,
//                                     label: Text(
//                     'Skip',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 20.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 100,
//             left: 10,
//             right: 10,
//                           child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: _buildPageIndicator(),
//             ),
//           ),
//           _currentPage != _numPages - 1
//               ? Align(
//                 alignment: FractionalOffset.bottomRight,
//                 child: FlatButton(
//                   onPressed: () {
//                     _pageController.nextPage(
//                       duration: Duration(milliseconds: 500),
//                       curve: Curves.ease,
//                     );
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Chip(
//                         backgroundColor: Colors.black,
//                                                         label: Text(
//                           'Next',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 22.0,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 10.0),
//                       Icon(
//                         Icons.arrow_forward,
//                         color: Colors.black,
//                         size: 30.0,
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//               : Text(''),
//         ],
//       ),
//     ),
//         ),
//         bottomSheet: _currentPage == _numPages - 1
//       ? Container(
//           height: 90.0,
//           width: double.infinity,
//           color: Colors.amber,
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 print('inside skip');
//                 showOngoingNotification(notifications,
//                   title: 'Welcome to Goenkart!', body: 'Your joining us has so hyped up!!');
//               });
//               Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => WebViewExample()));
//             },
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.only(bottom: 30.0),
//                 child: Text(
//                   'Get started',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         )
//       : Text(''),
//       );
//   }
// }

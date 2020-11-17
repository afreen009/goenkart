
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:goenkart/connectivity.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewWebPage extends StatefulWidget {

 @override

 _WebViewWebPageState createState() => _WebViewWebPageState();

}

class _WebViewWebPageState extends State<WebViewWebPage> {
  
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
    Future<bool> getStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      debugPrint("network available using mobile");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      debugPrint("network available using wifi");
      return true;
    } else {
      debugPrint("network not available");
      return false;
    }
  }
@override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    getStatus();
  }
 Future<bool> _onBack() async {

   bool goBack;

   var value = await webView.canGoBack();  // check webview can go back

   if (value) {

     webView.goBack(); // perform webview back operation

     return false;
   } else {

     await showDialog(

       context: context,
       builder: (context) => new AlertDialog(
         title: new Text('Confirmation ', style: TextStyle(color: Colors.purple)),

         // Are you sure?

         content: new Text('Do you want exit app ? '),

         // Do you want to go back?

         actions: <Widget>[

           new FlatButton(

             onPressed: () {

               Navigator.of(context).pop(false);

               setState(() {

                 goBack = false;

               });

             },

             child: new Text('No'), // No

           ),

           new FlatButton(

             onPressed: () {
               SystemNavigator.pop();
              //  Navigator.of(context).pop();

               setState(() {

                 goBack = true;

               });

             },

             child: new Text('Yes'), // Yes

           ),

         ],

       ),

     );
     if (goBack) Navigator.pop(context);   // If user press Yes pop the page

     return goBack;

   }

 }

 // URL to load

 var url = "https://goenkart.com/";
   bool show=false;

 var listeningUrl = "https://www.linkedin.com/in/omeryilmaz86/";


 // Webview progress

 double progress = 0;

 InAppWebViewController webView;


 @override

 Widget build(BuildContext context) {
   String string;
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.none:
        string = "Offline";
        break;
      case ConnectivityResult.mobile:
        string = "Online";
        break;
      case ConnectivityResult.wifi:
        string = "Online";
    }
   return WillPopScope(

     onWillPop: _onBack,

     child: Scaffold(

         body: string == 'Online' ?SafeArea(
                    child: Container(

               child: Stack(

                   children: <Widget>[

               // Should be removed while showing

             Align(
               alignment: Alignment.center,
                            child: InAppWebView(

                 initialUrl: url,
                 
                 initialHeaders: {},
                 onDownloadStart: pageLoading(url, true),
                //  onLoadStop: pageLoading(url,false),
                 initialOptions: InAppWebViewGroupOptions(
  crossPlatform: InAppWebViewOptions(
      debuggingEnabled: true,
      useShouldOverrideUrlLoading: true
  ),
),
shouldOverrideUrlLoading: (controller, request) async {
  var url = request.url;
  var uri = Uri.parse(url);

  if (!["http", "https", "file",
    "chrome", "data", "javascript",
    "about"].contains(uri.scheme)) {
    if (await canLaunch(url)) {
      // Launch the App
      await launch(
        url,
      );
      // and cancel the request
      return ShouldOverrideUrlLoadingAction.CANCEL;
    }
  }

  return ShouldOverrideUrlLoadingAction.ALLOW;
},

                 onWebViewCreated: (InAppWebViewController controller) {

                     webView = controller;

                 },
                 onLoadStart: (InAppWebViewController controller, String url) {

                },
                onLoadStop:
                  (InAppWebViewController controller, String url) async {
                },
                onProgressChanged: (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
                },
                //  onLoadStart: (InAppWebViewController controller, String url) {

                //      // Listen Url change

                //      if(url == listeningUrl){

                //        Navigator.of(context, rootNavigator: true)

                //            .push(MaterialPageRoute(

                //            builder: (context) => new SecondPage()));

                //      }

                //  },

                //  onProgressChanged:

                //        (InAppWebViewController controller, int progress) {

                //      setState(() {

                //        this.progress = progress / 100;

                //      });

                //  },

               ),
             ),
             Align(
              alignment: Alignment.center,
              child: _buildProgressBar()
            ),
           ].where((Object o) => o != null).toList())),
                    
         ) :internetError()
         ),

   );  //Remove null widgets

 }
  // pageFinishedLoading(String url) {
  //   setState(() {
  //     show = false;
  //   });
  // }
 pageLoading(String url,bool condition) {
   if(condition==true){
     setState(() {
      show = true;
      new Future.delayed(const Duration(seconds: 3), () {
                    setState(() => show = false);
                  });
    });
   }
   else if(condition== false){
     setState(() {
      show = false;
    });
   }
    
  }
  Widget internetError() {
   return Scaffold(
                            appBar: AppBar(
                              automaticallyImplyLeading:false,
              backgroundColor: Colors.amber,
                    ),
                    body: Container(height : MediaQuery.of(context).size.height,child: Center(child: Image.asset('assets/snail-removebg-preview.png')),));
 }
    Widget _buildProgressBar() {
    if (progress != 1.0) {
      return CircularProgressIndicator();
// You can use LinearProgressIndicator also
//      return LinearProgressIndicator(
//        value: progress,
//        valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
//        backgroundColor: Colors.blue,
//      );
    }
    return Container();
  }
}
  

class SecondPage extends StatelessWidget {

 @override

 Widget build(BuildContext context) {

   return Scaffold(

     appBar: AppBar(

       title: Text("Second Page"),

     ),

     body: Container(

       child: Center(

         child: Text("Hey,there!"),

       ),

     ),

   );

 }

}

// const String kNavigationExamplePage = '''
// <!DOCTYPE html><html>
// <head><title>Navigation Delegate Example</title></head>
// <body>
// <p>
// The navigation delegate is set to block navigation to the youtube website.
// </p>
// <ul>
// <ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
// <ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
// <ul><a href="https://www.google.com/">https://nodejs.org/en</a></ul>
// </ul>
// </body>
// </html>
// ''';

// class WebViewExample extends StatefulWidget {
//   @override
//   _WebViewExampleState createState() => _WebViewExampleState();
// }

// WebViewController controllerGlobal;

// // ignore: missing_return
// Future<bool> _exitApp(BuildContext context) async {
//   if (await controllerGlobal.canGoBack()) {
//     print("onwill goback");
//     controllerGlobal.goBack();
//   } else {
//     Scaffold.of(context).showSnackBar(
//       const SnackBar(content: Text("No back history item")),
//     );
//     return Future.value(false);
//   }
// }

// class _WebViewExampleState extends State<WebViewExample> {
//   bool _visible = false;
//    Map _source = {ConnectivityResult.none: false};
//    String url = 'https://www.goenkart.com/';
//   MyConnectivity _connectivity = MyConnectivity.instance;
//     Future<bool> getStatus() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       debugPrint("network available using mobile");
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       debugPrint("network available using wifi");
//       return true;
//     } else {
//       debugPrint("network not available");
//       return false;
//     }
//   }
  
//   final Completer<WebViewController> _controller =
//   Completer<WebViewController>();
//   bool _isLoading;
//   final _key = UniqueKey();
//   String useragent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.106 Safari/537.36";

//   @override
//   void initState() {
//     super.initState();
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//     _isLoading=true;
//     _connectivity.initialise();
//     setState(() {
//       url = 'https://www.goenkart.com/';
//     });
//     _connectivity.myStream.listen((source) {
//       setState(() => _source = source);
//     });
//     getStatus();
//     _visible = false;
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }
//   _onDragStart(BuildContext context, DragStartDetails start) {
    
//     print(start.globalPosition.toString());
//     RenderBox getBox = context.findRenderObject();
//     var local = getBox.globalToLocal(start.globalPosition);
//     print(local.dx.toString() + "|" + local.dy.toString());
//     setState(() {
//       _visible = !_visible;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     String string;
//     switch (_source.keys.toList()[0]) {
//       case ConnectivityResult.none:
//         string = "Offline";
//         break;
//       case ConnectivityResult.mobile:
//         string = "Online";
//         break;
//       case ConnectivityResult.wifi:
//         string = "Online";
//     }
//     Future<bool> status =  getStatus();
//     print(status);
//     return WillPopScope(
//       onWillPop: () => _exitApp(context),
//       child: string == 'Online' ?SafeArea(
//               child: Scaffold(
//             body: Builder(builder: (BuildContext context) {
//           return Stack(
//               children: [
//               NavigationControls(_controller.future),
//               // SampleMenu(_controller.future),
//               WebView(
//         key: _key,
//         initialUrl: url,
//         userAgent: useragent,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           _controller.complete(webViewController);
//         },
//         onPageStarted: (started)async{
//           (await _controller.future).evaluateJavascript("document.getElementsByClassName('footer-container')[0].style.display='none';");
//               (await _controller.future).evaluateJavascript("document.getElementById('st_notification_1').style.display='none';");
//               (await _controller.future).evaluateJavascript("document.getElementById('sidebar_box').style.display='none';");
//           setState(() {
//         _isLoading = true;
//           });
//         },
//         onPageFinished: (finish) {
//               setState(() {
//                 _isLoading = false;
//               });
//             },
          
//         // ignore: prefer_collection_literals
//         javascriptChannels: <JavascriptChannel>[
//           _toasterJavascriptChannel(context),
//         ].toSet(),
//         navigationDelegate: (NavigationRequest request) async {
//         //   if (request.url.startsWith('https://www.goenkart.com/')) {
//         // print('blocking navigation to $request}');
//         // return NavigationDecision.navigate;
//         //   }
//            if (request.url.startsWith('https://www.youtube.com/')) {
//         print('blocking navigation to $request}');
//         return NavigationDecision.navigate;
//           }
//           else if (request.url.startsWith('tel:')) {
//         print('blocking navigation to $request}');
//         makeMyRequest();
//         return NavigationDecision.prevent;
//         }
//         else if (request.url.startsWith('mailto:')) {
//         // makeMyRequest();
//         launch('mailto:goenkartgoa@gmail.com');
//         return NavigationDecision.prevent;
//         }
//           else if (request.url.startsWith('whatsapp://send/')) {
//         print('blocking navigation to $request}');
//         launchWhatsApp();
//         return NavigationDecision.prevent;
//         }
//         else if (request.url.startsWith('https://www.google.com/')) {
//         print('blocking navigation to $request}');
//         return NavigationDecision.prevent;
//         }
//         print('allowing navigation to $request');
//         return NavigationDecision.navigate;
//           },
//         ),
//         _isLoading ? Center(
//           child: Container(
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//               color: Colors.brown[300],
//           borderRadius: BorderRadius.all(Radius.circular(8.0)),),
//             child: Center(
//                     child: SpinKitCircle(color: Colors.white),
//                   ),
//           ),
//         )
//             : Stack(),
//              _visible ? Container(
//                  width: MediaQuery.of(context).size.width,
//                  height: MediaQuery.of(context).size.height,
//                  color: Colors.white70,
//                  child: Center(
//           child: Container(
//         width: 250.0,
//         height: 400.0,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(width: 0.5),
//           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//         top: 0,
//         left: 0,
//         child: Container(
//           decoration: BoxDecoration(
//           color: Colors.amber[400],
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
//         ), width: 250,height: 60,
//         ),
//               ),
//               Positioned(
//         top: 10,
//         left: 10,
//                         child: Row(
//           children: [
//             CircleAvatar(backgroundColor: Colors.white, child: Container(width: 80/2,child: Center(child: Image.asset('assets/launch.png',fit: BoxFit.cover,)))),
//             SizedBox(width: 5),
//             Text('GoenKart',style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),),
//           ],
//         ),
//               ),
//               Positioned(right:15,top: 10,child: GestureDetector(onTap:(){setState(() {
//                 _visible = !_visible;
//               });},child: Icon(Icons.cancel))),
//               Positioned(left:15,top: 80,child: Text('Socialmedia',style: TextStyle(fontWeight: FontWeight.bold))),
//               Positioned(left:15,top: 105,child: GestureDetector(onTap:(){setState(() {
//         launch('https://www.youtube.com');
//               });},child: Container(width: 100/2,child: Image.asset('assets/youtube.png',fit: BoxFit.cover,)))),
//               Positioned(right:15,top: 105,child: GestureDetector(onTap: (){
//         setState(() {
//           launchfb();
//         });
//               },child: Container(width: 100/2,child: Image.asset('assets/facebook.png',fit: BoxFit.cover,)))),
//               Positioned(left:100,top: 105,child: GestureDetector(onTap:(){
//         setState(() {
//           launchinsta();
//         });
//               },child: Container(width: 100/2,child: Image.asset('assets/instagram.png',fit: BoxFit.fitHeight,)))),
//               Positioned(left:100,top: 180,child: GestureDetector(onTap:(){
//         setState(() {
//           launch('https://twitter.com/');
//         });
//               },child: Container(width: 100/2,child: Image.asset('assets/twitter.png',fit: BoxFit.fitHeight,)))),
//               Positioned(right:15,top: 180,child: GestureDetector(onTap:(){
//         setState(() {
//           launch('https://in.linkedin.com/');
//         });
//               },child: Container(width: 100/2,child: Image.asset('assets/linkedin.png',fit: BoxFit.fitHeight,)))),
//               Positioned(left:15,top: 180,child: GestureDetector(onTap:(){
//         setState(() {
//           launch('https://www.snapchat.com/');
//         });
//               },child: Container(width: 100/2,child: Image.asset('assets/snapchat.png',fit: BoxFit.fitHeight,)))),
//               Positioned(left:15,bottom: 120,child: Text('Contact Us',style: TextStyle(fontWeight: FontWeight.bold))),
//               Positioned(left:15,bottom: 60,child: GestureDetector(onTap:(){
//         setState(() {
//           makeMyRequest();
//         });
//               },child: Container(width: 100/2,child: Image.asset('assets/call.png',fit: BoxFit.fitHeight,)))),
//                Positioned(right:15,bottom: 60,child: GestureDetector(onTap:(){
//         setState(() {
//           launchWhatsApp();
//         });
//               },child: Container(width: 100/2,child: Image.asset('assets/whatsapp.png',fit: BoxFit.fitHeight,)))),
//               Positioned(left:100,bottom: 60,child: GestureDetector(onTap:(){
//         setState(() {
//           launch('mailto:');
//         });
//               },child: Container(width: 100/2,child: Image.asset('assets/email.png',fit: BoxFit.fitHeight,)))),
//               Positioned(bottom:0,child: Container(decoration: BoxDecoration(
//           color: Colors.grey[400],
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
//         ), width: 250,height: 40,child: Center(child: Text('Privacy Policy & Terms And Conditions',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),),),
//           ],
//         ),
//               ),
//             ),
//                ):Stack(),
//             Positioned(
//           top: 80,
//           right: -15,
//                                 child: GestureDetector(
//                                   onHorizontalDragStart: (DragStartDetails start) =>
//         _onDragStart(context, start),
//                                   onTap:(){setState(() {
//                                     _visible = !_visible;
//                                   });},
//                                                                                                     child: Container(
//         width: 25.0,
//         height: 100.0,
//         decoration: BoxDecoration(
//           color: Colors.white60,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
//         ),
//               ),
//                                 ),
//             ),
//               ],
//             );
//         }),
//             // floatingActionButton: favoriteButton(),
//           ),
//       ): internetError(),
//                             );
//                           }
                        
//                           JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//                             return JavascriptChannel(
//                                 name: 'Toaster',
//                                 onMessageReceived: (JavascriptMessage message) {
//                                   Scaffold.of(context).showSnackBar(
//                                     SnackBar(content: Text(message.message)),
//                                   );
//                                 });
//                           }
                        
//                           Widget favoriteButton() {
//                             print("inside");
//                             return FutureBuilder<WebViewController>(
//                                 future: _controller.future,
//                                 builder: (BuildContext context,
//                                     AsyncSnapshot<WebViewController> controller) {
//                                   if (controller.hasData) {
//                                     return FloatingActionButton(
//                                       onPressed: () async {
//                                        setState(() {
//                                          print(!_visible);
//             _visible = !_visible;
//           });
//                                       },
//                                       child: const Icon(Icons.favorite),
//                                       tooltip: 'Toggle Opacity',
//                                     );
//                                   }
//                                   return Container();
//                                 });
//                           }

//  Widget internetError() {
//    return Scaffold(
//                             appBar: AppBar(
//                               automaticallyImplyLeading:false,
//               backgroundColor: Colors.amber,
//                     ),
//                     body: Container(height : MediaQuery.of(context).size.height,child: Center(child: Image.asset('assets/snail-removebg-preview.png')),));
//  }
//                         }
        
// void launchWhatsApp() async {
//   String url() {
//     if (Platform.isIOS) {
//       return "whatsapp://wa.me/918884333033z/?text= hello";
//     } else {
//       return "whatsapp://send?phone=918884333033z&text= hello";
//     }
//   }

//   if (await canLaunch(url())) {
//     await launch(url());
//   } else {
//     throw 'Could not launch ${url()}';
//   }
// }
// void launchfb() async {
//   String url() {
//     return "fb://";
//   }
//   if (await canLaunch(url())) {
//     await launch(url());
//   } else {
//     throw 'Could not launch ${url()}';
//   }
// }
// void launchinsta() async {
//   String url() {
//     return "https://www.instagram.com/";
//   }

//   if (await canLaunch(url())) {
//     await launch(url());
//   } else {
//     throw 'Could not launch ${url()}';
//   }
// }
// //https://www.instagram.com/media?id=id_here
// //instagram://
//   makeMyRequest() async {
//     launch("tel:918884333033");
//   // int subscriptionId = 1; // sim card subscription Id
//   // String code = "*21#"; // ussd code payload
//   // try {
//   //   String ussdSuccessMessage = await UssdService.makeRequest(subscriptionId, code);
//   //   print("succes! message: $ussdSuccessMessage");
//   // } on PlatformException catch (e) {
//   //   print("error! code: ${e.code} - message: ${e.message}");
//   // }
// }
// enum MenuOptions {
//   showUserAgent,
//   listCookies,
//   clearCookies,
//   addToCache,
//   listCache,
//   clearCache,
//   navigationDelegate,
// }

// class SampleMenu extends StatelessWidget {
//   SampleMenu(this.controller);

//   final Future<WebViewController> controller;
//   final CookieManager cookieManager = CookieManager();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: controller,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> controller) {
//         return PopupMenuButton<MenuOptions>(
//           onSelected: (MenuOptions value) {
//             switch (value) {
//               case MenuOptions.showUserAgent:
//                 _onShowUserAgent(controller.data, context);
//                 break;
//               case MenuOptions.listCookies:
//                 _onListCookies(controller.data, context);
//                 break;
//               case MenuOptions.clearCookies:
//                 _onClearCookies(context);
//                 break;
//               case MenuOptions.addToCache:
//                 _onAddToCache(controller.data, context);
//                 break;
//               case MenuOptions.listCache:
//                 _onListCache(controller.data, context);
//                 break;
//               case MenuOptions.clearCache:
//                 _onClearCache(controller.data, context);
//                 break;
//               case MenuOptions.navigationDelegate:
//                 _onNavigationDelegateExample(controller.data, context);
//                 break;
//             }
//           },
//           itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//             PopupMenuItem<MenuOptions>(
//               value: MenuOptions.showUserAgent,
//               child: const Text('Show user agent'),
//               enabled: controller.hasData,
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.listCookies,
//               child: Text('List cookies'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCookies,
//               child: Text('Clear cookies'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.addToCache,
//               child: Text('Add to cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.listCache,
//               child: Text('List cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.clearCache,
//               child: Text('Clear cache'),
//             ),
//             const PopupMenuItem<MenuOptions>(
//               value: MenuOptions.navigationDelegate,
//               child: Text('Navigation Delegate example'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _onShowUserAgent(
//       WebViewController controller, BuildContext context) async {
//     // Send a message with the user agent string to the Toaster JavaScript channel we registered
//     // with the WebView.
//     controller.evaluateJavascript(
//         'Toaster.postMessage("User Agent: " + navigator.userAgent);');
//   }

//   void _onListCookies(
//       WebViewController controller, BuildContext context) async {
//     final String cookies =
//     await controller.evaluateJavascript('document.cookie');
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           const Text('Cookies:'),
//           _getCookieList(cookies),
//         ],
//       ),
//     ));
//   }

//   void _onAddToCache(WebViewController controller, BuildContext context) async {
//     await controller.evaluateJavascript(
//         'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
//     Scaffold.of(context).showSnackBar(const SnackBar(
//       content: Text('Added a test entry to cache.'),
//     ));
//   }

//   void _onListCache(WebViewController controller, BuildContext context) async {
//     await controller.evaluateJavascript('caches.keys()'
//         '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
//         '.then((caches) => Toaster.postMessage(caches))');
//   }

//   void _onClearCache(WebViewController controller, BuildContext context) async {
//     await controller.clearCache();
//     Scaffold.of(context).showSnackBar(const SnackBar(
//       content: Text("Cache cleared."),
//     ));
//   }

//   void _onClearCookies(BuildContext context) async {
//     final bool hadCookies = await cookieManager.clearCookies();
//     String message = 'There were cookies. Now, they are gone!';
//     if (!hadCookies) {
//       message = 'There are no cookies.';
//     }
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//     ));
//   }

//   void _onNavigationDelegateExample(
//       WebViewController controller, BuildContext context) async {
//     final String contentBase64 =
//     base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
//     controller.loadUrl('data:text/html;base64,$contentBase64');
//   }

//   Widget _getCookieList(String cookies) {
//     if (cookies == null || cookies == '""') {
//       return Container();
//     }
//     final List<String> cookieList = cookies.split(';');
//     final Iterable<Text> cookieWidgets =
//     cookieList.map((String cookie) => Text(cookie));
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       mainAxisSize: MainAxisSize.min,
//       children: cookieWidgets.toList(),
//     );
//   }
// }



// class NavigationControls extends StatelessWidget {
//   const NavigationControls(this._webViewControllerFuture)
//       : assert(_webViewControllerFuture != null);

//   final Future<WebViewController> _webViewControllerFuture;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<WebViewController>(
//       future: _webViewControllerFuture,
//       builder:
//           (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//         final bool webViewReady =
//             snapshot.connectionState == ConnectionState.done;
//         final WebViewController controller = snapshot.data;
//         controllerGlobal = controller;

//         return Row(
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                 if (await controller.canGoBack()) {
//                   controller.goBack();
//                 } else {
//                   Scaffold.of(context).showSnackBar(
//                     const SnackBar(content: Text("No back history item")),
//                   );
//                   return;
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward_ios,color: Colors.white,),
//               onPressed: !webViewReady
//                   ? null
//                   : () async {
//                 if (await controller.canGoForward()) {
//                   controller.goForward();
//                 } else {
//                   Scaffold.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text("No forward history item")),
//                   );
//                   return;
//                 }
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.replay,color: Colors.white,),
//               onPressed: !webViewReady
//                   ? null
//                   : () {
//                 controller.reload();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
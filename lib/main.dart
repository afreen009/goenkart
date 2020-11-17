import 'package:flutter/material.dart';

import 'my_app.dart';

// void main () {
//   runApp(MaterialApp(
//     home: MyApp(),
//     debugShowCheckedModeBanner: false,
//   ));
// }
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}


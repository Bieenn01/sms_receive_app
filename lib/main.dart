import 'package:flutter/material.dart';
import 'package:sms_receive_app/device_info.dart';
import 'package:sms_receive_app/list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sms_receive_app/sms.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      initialRoute: '/home',
      routes: {
        '/home' :(context) => const MyWidget(),
        '/app-info': (context) => DeviceInfoPage(),
        '/sms-receiver': (context) => SmsReceiver(),
        
      },
    );
  }
}
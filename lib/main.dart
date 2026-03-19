import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:city/screens/splash_screen.dart';
import 'notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';  // ✅ not hive/hive.dart
import 'package:city/model/hive.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await NotificationService.initialize();

  await Hive.initFlutter();                  // ✅ now works correctly
  Hive.registerAdapter(BookedServiceAdapter());
  await Hive.openBox<BookedService>('bookedServices');

  runApp(const MyCityConnectApp());
}

class MyCityConnectApp extends StatelessWidget {
  const MyCityConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCityConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
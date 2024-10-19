import 'package:awon_pro/admin/AdminHomePage.dart';
import 'package:awon_pro/admin/AdminLogin.dart';
import 'package:awon_pro/registerpages/LoginPage.dart';
import 'package:awon_pro/registerpages/welcomePage.dart';
import 'package:awon_pro/volunteerPage/HPage.dart';
import 'package:awon_pro/volunteerPage/Home.dart';
import 'package:awon_pro/volunteerPage/QRCodePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awon Application',
      theme: ThemeData(
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Welcomepage(),
      //home: Home(),
    );
  }
}

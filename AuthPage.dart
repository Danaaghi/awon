// ignore_for_file: prefer_const_constructors

import 'package:awon_pro/registerpages/LoginPage.dart';
import 'package:awon_pro/registerpages/welcomePage.dart';
import 'package:awon_pro/volunteerPage/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authpage extends StatelessWidget {
  const Authpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Home();
        } else {
          return Welcomepage();
        }
      },
    ));
  }
}

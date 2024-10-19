// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, use_super_parameters, file_names

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:awon_pro/colors.dart';
import 'package:awon_pro/volunteerPage/HPage.dart';
import 'package:awon_pro/volunteerPage/ProfilePage.dart';
import 'package:awon_pro/volunteerPage/QRCodePage.dart';
import 'package:awon_pro/volunteerPage/VolunteerRankingApp.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HPage(),
    QRCodePage(),
    VolunteerRankingApp(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white, //background for the entire page
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: AppColors.AwonWhite,
        color: AppColors.darkblue,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.qr_code_rounded,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.emoji_events, //.leaderboard
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person_2_outlined,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
      body: _pages[_currentIndex], //Display the Selected page
    );
  }
}

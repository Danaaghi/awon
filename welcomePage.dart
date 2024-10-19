// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_import

import 'package:awon_pro/AuthPage.dart';
import 'package:awon_pro/admin/AdminLogin.dart';
import 'package:awon_pro/colors.dart';
import 'package:flutter/material.dart';
import 'package:arabic_font/arabic_font.dart';

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('/Users/danait/StudioProjects/awon_pro/assets/images/1.png'),
          fit: BoxFit.cover,
        ),
      ),
      //child: SizedBox(height: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 500),
          ElevatedButton(
            onPressed: () {
              // التنقل إلى صفحة تسجيل الدخول
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Authpage(), // استبدل بصفحة تسجيل الدخول الخاصة بك
                ),
              );
            },
            child: Text(
              ' تسجيل الدخول ',
              style: ArabicTextStyle(
                color: Colors.white,
                fontSize: 16,
                arabicFont: 'changa',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFA8c082),
              padding: EdgeInsets.symmetric(
                  horizontal: 48.0, vertical: 16.0), // الحشو
              shadowColor: AppColors.lightgreen.withOpacity(0.9),
              elevation: 3,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          OutlinedButton(
            onPressed: () {
              // التنقل إلى صفحة إنشاء حساب
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AdminLogin(), // استبدل بصفحة إنشاء حساب الخاصة بك
                ),
              );
            },
            child: Text(
              ' تسجيل كـمسؤول',
              style: ArabicTextStyle(
                color: Colors.white,
                fontSize: 16,
                arabicFont: 'changa',
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Color(0xFF194173),
              padding: EdgeInsets.symmetric(
                  horizontal: 50.0, vertical: 16.0), // الحشو
              elevation: 3,
              shadowColor: AppColors.lightgreen.withOpacity(0.9),
              side: BorderSide(
                color: Color(0xFFA8c082),
                width: 2.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

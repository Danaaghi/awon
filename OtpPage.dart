// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:arabic_font/arabic_font.dart';
import 'package:awon_pro/colors.dart';
import 'package:awon_pro/registerpages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() {
    // Get current user
    _user = _auth.currentUser;
  }

  Future<void> sendOtp() async {
  if (_user != null && !_user!.emailVerified) {
    try {
      await _user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'لقد تم إرسال رسالة التحقق إلى بريدك الإلكتروني ${_user!.email}'),
      ));
    } catch (e) {
      // استبدال Snackbar بـ showErrorDialog
      showErrorDialog('حدث خطأ أثناء إرسال رمز التحقق: $e');
    }
  } else {
    // استبدال Snackbar بـ showErrorDialog
    showErrorDialog('عذرًا، يبدو أن المستخدم غير مسجل الدخول أو أن البريد الإلكتروني تم التحقق منه مسبقًا');
  }
}
void showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.lightblue,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Changa',
            ),
            textAlign: TextAlign.right, // توجيه النص إلى اليمين
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق الحوار
            },
            child: const Text(
              'حسناً',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Changa',
              ),
            ),
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // الحصول على حجم الشاشة

    return Scaffold(
      backgroundColor: AppColors.AwonWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.20),
        child: AppBar(
          iconTheme: const IconThemeData(
              color: AppColors.AwonWhite), // تغيير لون السهم هنا
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: AppColors.darkblue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(800, 100),
              bottomRight: Radius.elliptical(800, 100),
            ),
          ),
          flexibleSpace: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '! شكرًا لتسجيلك',
                  textAlign: TextAlign.center,
                  style: ArabicTextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    arabicFont: 'changa',
                  ),
                ),
                Text(
                  ' تأكد من بريدك الإلكتروني لتفعيل الحساب',
                  textAlign: TextAlign.center,
                  style: ArabicTextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    arabicFont: 'changa',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: 100),
            Text(
              ': البريد الإلكتروني \n ${_user?.email ?? "عذرًا، لا يوجد مستخدم مسجل الدخول"}',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.right,
            ),
            Divider(
              color: AppColors.lightblue,
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                sendOtp(); // Call sendOtp method
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.lightblue,
                padding: EdgeInsets.symmetric(
                    horizontal: 70.0, vertical: 16.0), // الحشو
                elevation: 3,
                shadowColor: AppColors.lightgreen.withOpacity(0.9),
                side: BorderSide(
                  color: AppColors.darkblue,
                  width: 2.0,
                ),
              ),
              child: const Text(
                'أرسل رسالة التحقق',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.AwonWhite,
                ),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.lightblue,
                padding: EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 16.0), // الحشو
                elevation: 3,
                shadowColor: AppColors.lightgreen.withOpacity(0.9),
                side: BorderSide(
                  color: AppColors.darkblue,
                  width: 2.0,
                ),
              ),
              child: const Text(
                'العودة إلى تسجيل الدخول',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.AwonWhite,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

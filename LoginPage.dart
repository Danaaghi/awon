// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:awon_pro/ForgotPwPage.dart';
import 'package:awon_pro/registerpages/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awon_pro/colors.dart';
import 'package:awon_pro/volunteerPage/Home.dart';
import 'package:arabic_font/arabic_font.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final bool _isLoggedIn = false;
  bool _isPasswordObscured = true;
  String? errorMessage; // Stores the last error message

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    Future.delayed(Duration.zero, () {
      if (_isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    });
  }

 Future<void> signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        Navigator.pop(context);
        showErrorDialog('يرجى التحقق من بريدك الإلكتروني أولاً.');
        return; // إنهاء العملية إذا لم يتم التحقق
      }

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print('Firebase Auth Error Code: ${e.code}');

      if (e.code == 'invalid-credential') {
        errorMessage = 'كلمة المرور او البريد الالكتروني غير صحيح ';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'الرجاء كتابة البريد الالكتروني ';
      } else if (e.code == 'missing-password') {
        errorMessage = 'الرجاء كتابة كلمة المرور';
      } else {
        errorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى';
      }

      showErrorDialog(errorMessage!);
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Color(0xFF194173),
            size: 30.0,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFFfafafa),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('/Users/danait/StudioProjects/awon_pro/assets/images/2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 260),
                  buildTextField(
                      'البريد الالكتروني', _emailController, screenWidth),
                  SizedBox(height: 10),
                  buildPasswordField(
                      'كلمة المرور', _passwordController, screenWidth),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPwPage()),
                            );
                          },
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: ArabicTextStyle(
                              fontSize: 16,
                              color: AppColors.lightgreen,
                              arabicFont: 'changa',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: signUserIn,
                    child: Text(
                      'تسجيل الدخول',
                      style: ArabicTextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          arabicFont: 'changa'),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide.none,
                      ),
                      shadowColor: AppColors.lightgreen.withOpacity(0.9),
                      elevation: 3,
                      backgroundColor: AppColors.lightgreen,
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.25,
                          vertical: 15.0), // تعديل الحشو حسب عرض الشاشة
                      textStyle:
                          ArabicTextStyle(fontSize: 16, arabicFont: 'changa'),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                        child: Text(
                          'اضغط هنا',
                          style: ArabicTextStyle(
                            fontSize: 16,
                            color: AppColors.lightgreen,
                            arabicFont: 'changa',
                          ),
                        ),
                      ),
                      Text(
                        " ليس لديك حساب ؟",
                        style: ArabicTextStyle(
                          color: AppColors.AwonWhite,
                          fontWeight: FontWeight.bold,
                          arabicFont: 'changa',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, TextEditingController controller, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: ArabicTextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              arabicFont: 'changa'),
        ),
        SizedBox(height: 8.0),
        Container(
          width: 300, // استخدم 90% من عرض الشاشة
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFa0bcdf),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField(
      String label, TextEditingController controller, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: ArabicTextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              arabicFont: 'changa'),
        ),
        SizedBox(height: 8.0),
        Container(
          width: 300, // استخدم 90% من عرض الشاشة
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            controller: controller,
            obscureText: _isPasswordObscured,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.lightblue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: IconButton(
                icon: Icon(
                  _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

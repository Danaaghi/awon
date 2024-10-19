import 'package:awon_pro/admin/AdminHomePage.dart';
import 'package:flutter/material.dart';
import 'package:awon_pro/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arabic_font/arabic_font.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  Future<void> _login() async {
  String email = _usernameController.text.trim();
  String password = _passwordController.text.trim();

  // Check for empty fields
  if (email.isEmpty || password.isEmpty) {
    showErrorDialog('يرجى ملء جميع الحقول');
    return;
  }

  try {
    // Fetching credentials from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Admins')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Navigate to the Admin Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage()),
      );
    } else {
      // Show error if credentials do not match
      showErrorDialog('البريد الإلكتروني أو كلمة المرور غير صحيحة');
    }
  } catch (e) {
    // Handle specific errors
    if (e is FirebaseException) {
      // Optionally handle Firestore-specific errors
      showErrorDialog('خطأ في الاتصال بقاعدة البيانات: ${e.message}');
    } else {
      // General error message
      showErrorDialog('حدث خطأ غير متوقع: ${e.toString()}');
    }

    // Specific check for invalid email
   
   
  }
}
void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:  AppColors.lightblue,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white ,
                fontFamily: 'Changa'
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'حسناً',
               
                style: TextStyle(
                color: Colors.white,
                fontFamily: 'Changa')
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
            image: AssetImage('assets/images/2.png'),
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
                      'البريد الالكتروني', _usernameController, screenWidth),
                  SizedBox(height: 10),
                  buildPasswordField(
                      'كلمة المرور', _passwordController, screenWidth),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _login, // Call login function
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
                      backgroundColor: Color(0xFFA8C082),
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.25,
                          vertical: 15.0),
                    ),
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
          width: 300,
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
          width: 300,
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

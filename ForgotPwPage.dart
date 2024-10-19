// ignore_for_file: sort_child_properties_last, use_build_context_synchronously 

import 'dart:core'; 
import 'package:arabic_font/arabic_font.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart'; 
import '../colors.dart'; // استيراد ملف الألوان 

class ForgotPwPage extends StatefulWidget { 
  const ForgotPwPage({super.key}); 

  @override 
  State<ForgotPwPage> createState() => ForgotPwPageState(); 
} 

class ForgotPwPageState extends State<ForgotPwPage> { 
  final _emailController = TextEditingController(); 

  @override 
  void dispose() { 
    _emailController.dispose(); 
    super.dispose(); 
  } 

  Future<void> forgetPassword() async { 
   if (_emailController.text.isEmpty) { 
  showDialog( 
    context: context, 
    builder: (context) { 
      return AlertDialog( 
        backgroundColor: AppColors.lightblue,
        content: Container(
          padding: const EdgeInsets.all(0), // إضافة حشوة حول النص
          child: const Text(
            'ادخل البريد الالكتروني', 
            style: TextStyle(color: Colors.white), // تعيين لون النص إلى الأبيض
            textAlign: TextAlign.center, // محاذاة النص إلى المنتصف
          ),
        ),
      ); 
    }, 
  ); 
  return; 
}

    try { 
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim()); 
      showDialog( 
  context: context, 
  builder: (context) { 
    return AlertDialog( 
      backgroundColor: AppColors.lightblue, // خلفية الحوار
      content: Container(
       // تغيير لون الخلفية إلى لون داكن
        padding: const EdgeInsets.all(16.0), // إضافة بعض الحشوة
        child: const Text(
          ' تم ارسال رابط اعادة تعيين كلمة المرور على البريد الالكتروني  ',
          style: TextStyle(color: Colors.white), // تعيين لون النص إلى الأبيض
          textAlign: TextAlign.center, // محاذاة النص إلى اليمين
        ),
      ), 
    ); 
  }, 
);
    } on FirebaseAuthException catch (e) {
  print('Caught FirebaseAuthException: ${e.code}'); // طباعة رمز الاستثناء
  String errorMessage;

  switch (e.code) {
    case 'invalid-email':
      errorMessage = 'الرجاء كتابة البريد الالكتروني بشكل صحيح ';
      break;
    case 'user-not-found':
      errorMessage = 'لا يوجد حساب مرتبط بهذا البريد الإلكتروني.';
      break;
    case 'too-many-requests':
      errorMessage = 'تم تقديم طلبات كثيرة. حاول لاحقًا.';
      break;
    default:
      errorMessage = 'حدث خطأ. الرجاء المحاولة مره اخرى.';
  }

    showDialog( 
  context: context, 
  builder: (context) { 
    return AlertDialog( 
      backgroundColor: AppColors.lightblue,
      content: Text(
        errorMessage, 
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center, // تحديد لون النص إلى الأبيض
      ), 
    ); 
  }, 
);

    } catch (e) { 
      print('Exception: $e'); 
      showDialog( 
        context: context, 
        builder: (context) { 
          return AlertDialog( 
            backgroundColor: AppColors.lightblue,
            content: const Text('حدث خطأ غير متوقع.'),
          ); 
        }, 
      ); 
    }
  } 

  @override 
  Widget build(BuildContext context) { 
    final screenSize = MediaQuery.of(context).size; 
    final screenWidth = MediaQuery.of(context).size.width; 

    return Scaffold( 
      backgroundColor: AppColors.AwonWhite, 
      appBar: PreferredSize( 
        preferredSize: Size.fromHeight(screenSize.height * 0.20), 
        child: AppBar( 
          iconTheme: const IconThemeData(color: AppColors.AwonWhite), 
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
                  '! نسيت كلمة المرور', 
                  style: ArabicTextStyle( 
                    fontSize: 30, 
                    color: Colors.white, 
                    arabicFont: 'changa', 
                  ), 
                ), 
              ], 
            ), 
          ), 
        ), 
      ), 
       body: SingleChildScrollView( // Add this line
      child: Column( 
        children: [ 
          SizedBox(height: 50), 
          const Padding( 
            padding: EdgeInsets.symmetric(horizontal: 30.0), 
            child: Text( 
              'عزيزنا المتطوع، يرجى إدخال بريدك الإلكتروني حتى نتمكن من إرسال رابط إعادة تعيين كلمة المرور إليك\nتأكد من إدخال بريدك الإلكتروني الصحيح لمساعدتنا في مساعدتك. شكرًا لك', 
              textAlign: TextAlign.center, 
              style: ArabicTextStyle( 
                fontSize: 15, 
                arabicFont: ArabicFont.changa, 
              ), 
            ), 
          ), 
          Divider(color: AppColors.darkblue), 
          Padding( 
            padding: const EdgeInsets.all(25.0), 
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center, 
              children: <Widget>[ 
                TextField( 
                  controller: _emailController, 
                  style: const ArabicTextStyle( 
                    color: AppColors.textColor, 
                    arabicFont: 'changa'
                  ), 
                  textAlign: TextAlign.right, 
                  decoration: InputDecoration( 
                    hintText: '----@gmail.com', 
                    filled: true, 
                    fillColor: Colors.white, 
                    prefixIcon: Container( 
                      margin: const EdgeInsets.all(12.0), 
                      child: const Icon( 
                        Icons.email, 
                        color: AppColors.lightgreen, 
                      ), 
                    ), 
                    hintStyle: const ArabicTextStyle( 
                      color: Colors.black38, 
                      arabicFont: 'changa'
                    ), 
                    contentPadding: const EdgeInsets.symmetric( 
                      horizontal: 20.0, 
                      vertical: 15.0
                    ), 
                  ), 
                ), 
              ], 
            ),
          ), 

          const SizedBox(height: 10), 
          ElevatedButton( 
            onPressed: forgetPassword, 
            child: const Text( 
              'إعادة تعيين كلمة المرور', 
              style: ArabicTextStyle( 
                color: Colors.white, 
                fontSize: 16, 
                arabicFont: 'changa'
              ), 
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
                horizontal: screenWidth * 0.23, 
                vertical: 13.0
              ), 
              textStyle: const ArabicTextStyle(fontSize: 16, arabicFont: 'changa'), 
            ), 
          ), 
        ], 
      ), 
    )); 
  } 
}

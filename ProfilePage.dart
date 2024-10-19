// ignore_for_file: avoid_print

import 'package:awon_pro/ForgotPwPage.dart';
import 'package:awon_pro/registerpages/welcomePage.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../colors.dart';
import 'package:arabic_font/arabic_font.dart';


import '../registerpages/LoginPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  String email = '';
  String userName = '';
  String Lastname = '';
  int? age; // متغير لتخزين العمر
  bool isEditingFirstName = false;
  bool isEditingLastName = false;

  // عناصر للتحكم في حقول النص
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      if (userId != null) {
        var userDocument = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();
        if (userDocument.exists) {
          setState(() {
            email = userDocument['email'];
            userName = userDocument[
                'first_name']; // Ensure this field name matches your Firestore structure
            Lastname = userDocument['last_name'];
            age = userDocument[
                'age']; // تأكد من أن هذا الحقل موجود في قاعدة البيانات
            firstNameController.text = userName; // تعيين قيمة الاسم الأول
            lastNameController.text = Lastname; // تعيين قيمة الاسم الأخير
          });
        } else {
          print("عذرًا، يبدو أن المستند غير موجود.");
        }
      } else {
        print("عذرًا، لا يوجد أي مستخدم مسجّل دخول");
      }
    } catch (e) {
      print("حدث خطأ أثناء جلب بيانات المستخدم: $e");
    }
  }

  Future<void> updateUserData() async {
    if (userId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'first_name': firstNameController.text,
          'last_name': lastNameController.text,
          'age': age,
        });
        print("تم تحديث البيانات بنجاح");
      } catch (e) {
        print("حدث خطأ أثناء تحديث البيانات: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.AwonWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenSize.height * 0.20),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColors.darkblue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(800, 100),
              bottomRight: Radius.elliptical(800, 100),
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.AwonWhite,
                ),
                const SizedBox(height: 15),
                Text(
                  userName.isNotEmpty
                      ? '$userName $Lastname'
                      : 'جارٍ التحميل ...',
                  style: const ArabicTextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    arabicFont: 'changa',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  ':المعلومات الشخصية',
                  textAlign: TextAlign.right,
                  style: ArabicTextStyle(
                      arabicFont: 'changa', fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: AppColors.darkblue,
                thickness: 2,
              ),
              // خانة البريد الإلكتروني
              TextFormField(
                style: const ArabicTextStyle(
                    color: AppColors.textColor, arabicFont: 'changa'),
                textAlign: TextAlign.right,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: email.isNotEmpty ? email : 'جارٍ التحميل...',
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
                      color: Colors.black38, arabicFont: 'changa'),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameController,
                      readOnly: !isEditingFirstName,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'الاسم الأول',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.lightgreen,
                          ),
                        ),
                        hintStyle: const ArabicTextStyle(
                            color: Colors.black38, arabicFont: 'changa'),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isEditingFirstName ? Icons.save : Icons.edit),
                    color: AppColors.lightgreen,
                    onPressed: () {
                      setState(() {
                        if (isEditingFirstName) {
                          userName = firstNameController.text;
                          updateUserData(); // حفظ البيانات في قاعدة البيانات هنا
                        }
                        isEditingFirstName = !isEditingFirstName;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // خانة الاسم الأخير
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
                      readOnly: !isEditingLastName,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'الاسم الأخير',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.lightgreen,
                          ),
                        ),
                        hintStyle: const ArabicTextStyle(
                            color: Colors.black38, arabicFont: 'changa'),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isEditingLastName ? Icons.save : Icons.edit),
                    color: AppColors.lightgreen,
                    onPressed: () {
                      setState(() {
                        if (isEditingLastName) {
                          Lastname = lastNameController.text;
                          updateUserData(); // حفظ البيانات في قاعدة البيانات هنا
                        }
                        isEditingLastName = !isEditingLastName;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // خانة العمر
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: age,
                      hint: const Text('العمر', textAlign: TextAlign.center),
                      items: List.generate(45, (index) => index + 16)
                          .map((age) => DropdownMenuItem(
                                value: age,
                                child: Center(
                                  child: Text(
                                    '$age',
                                    style: const ArabicTextStyle(
                                      color: AppColors.textColor,
                                      arabicFont: 'changa',
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          age = value;
                          updateUserData(); // حفظ العمر في قاعدة البيانات هنا
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Container(
                          margin: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.date_range,
                            color: AppColors.lightgreen,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical:
                                10.0), // إضافة padding لجعل المحتوى في المنتصف
                      ),
                      dropdownColor: Colors.white, // تغيير لون القائمة
                      isExpanded: true, // تأكد من توسيع العنصر ليشمل المساحة
                      alignment: Alignment.center, // جعل العناصر في المنتصف
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Divider(
                color: AppColors.darkblue,
                thickness: 2,
              ),

              const SizedBox(height: 10),

              // خانة تعديل كلمة المرور
              TextFormField(
                readOnly: true,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPwPage(),
                    ),
                  );
                },
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'تعديل كلمة المرور',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12.0),
                    child: const Icon(
                      Icons.lock,
                      color: AppColors.lightgreen,
                    ),
                  ),
                  hintStyle: const ArabicTextStyle(
                    fontSize: 16,
                    arabicFont: 'changa',
                  ).apply(color: AppColors.textColor),
                ),
              ),
              const SizedBox(height: 10),

              // خانة تسجيل الخروج
              TextFormField(
                readOnly: true,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'تسجيل خروج',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12.0),
                    child: const Icon(
                      Icons.output,
                      color: Colors.red,
                    ),
                  ),
                  hintStyle: const ArabicTextStyle(
                    fontSize: 16,
                    arabicFont: 'changa',
                  ).apply(color: AppColors.textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_super_parameters, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names, library_private_types_in_public_api

import 'dart:math';

import 'package:arabic_font/arabic_font.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../colors.dart';
import 'RegistrationPage.dart'; // استيراد ملف الألوان

class HPage extends StatefulWidget {
  const HPage({Key? key}) : super(key: key);

  @override
  State<HPage> createState() => _HPageState();
}

Future<Map<String, dynamic>> getUserInfo() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    final firstName = docSnapshot.get('first_name') ?? 'No First Name';
    final lastName = docSnapshot.get('last_name') ?? 'No Last Name';
    final totalHours = docSnapshot.get('totalHours') ?? 0;
    final qrData = docSnapshot.get('qrData') ?? 'لم تسجل في جمعية بعد ';

    return {
      'first_name': firstName,
      'last_name': lastName,
      'totalHours': totalHours,
      'qrData': qrData,
    };
  }
  return {
    'first_name': 'No',
    'last_name': 'Name',
    'totalHours': 0,
    'qrData': 'لم تسجل في جمعية بعد '
  };
}

class _HPageState extends State<HPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Get screen size

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.AwonWhite,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenSize.height * 0.20),
          child: AppBar(
            automaticallyImplyLeading: false, // Remove the back button
            flexibleSpace: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              decoration: const BoxDecoration(
                color: AppColors.darkblue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(800, 100),
                  bottomRight: Radius.elliptical(800, 100),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'اهلًا بك في عَوْن',
                    style: ArabicTextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      arabicFont: 'Changa',
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '!حيث يمكنك التطوع بسهولة',
                    style: ArabicTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                      arabicFont: 'Changa',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            elevation: 0,
          ),
        ),
        body: const Column(
          children: [
            Expanded(
              child: BodyContent(),
            ),
          ],
        ),
      ),
    );
  }
}

class BodyContent extends StatefulWidget {
  const BodyContent({Key? key}) : super(key: key);

  @override
  _BodyContentState createState() => _BodyContentState();
}

class _BodyContentState extends State<BodyContent> {
  bool isGridView = true;

  void toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No data found.'));
        } else {
          final userInfo = snapshot.data!;
          String welcomeMessage = ' ${userInfo['qrData']}';
          double progress =
              (userInfo['totalHours'] != 0) ? userInfo['totalHours'] / 100 : 0;

          final screenSize = MediaQuery.of(context).size;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05, vertical: 10.0),
                child: Container(
                  width: double.infinity,
                  height: screenSize.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: AppColors.lightblue.withOpacity(0.6),
                        offset: const Offset(4, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.lightblue.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
  width: 100, // عرض الدائرة
  height: 100, // ارتفاع الدائرة
  child: Stack(
    alignment: Alignment.center, // لضبط النص في المنتصف
    children: [
      CircularProgressIndicator(
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.lightgreen),
        value: progress,
        strokeWidth: 8, // عرض الخط
      ),
      Text(
        '${(progress * 100).toStringAsFixed(0)}%',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  ),
),

                      const SizedBox(width: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Text(
                            welcomeMessage,
                            style: const ArabicTextStyle(
                              arabicFont: ArabicFont.changa,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'عدد الساعات المنجزة: ${userInfo['totalHours']} ساعة',
                            style: const ArabicTextStyle(
                              arabicFont: ArabicFont.changa,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const Divider(color: AppColors.lightblue),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.05, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: toggleView,
                      icon: Icon(
                        isGridView ? Icons.list_sharp : Icons.grid_view,
                        color: AppColors.lightgreen,
                        size: 24,
                      ),
                    ),
                    const Text(
                      'الجمعيات',
                      style: ArabicTextStyle(
                        fontSize: 20,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.normal,
                        arabicFont: 'Changa',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('associations')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No data found.'));
                    }

                    final documents = snapshot.data!.docs;

                    return isGridView
                        ? GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.05,
                                vertical: 10.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final document = documents[index];
                              final data =
                                  document.data() as Map<String, dynamic>;
                              final title = data['name'] ?? 'لا يوجد اسم';
                              final city =
                                  data['city'] ?? 'لم يتم تحديد موقع الجمعية';
                              final description = data['description'] ??
                                  'لم يتم تحديد وصف الجمعية';
                              final documentId =
                                  document.id; // الحصول على documentId
                              final startDate =
                                  (data['startDate'] as Timestamp?)?.toDate() ??
                                      DateTime.now();
                              final endDate =
                                  (data['endDate'] as Timestamp?)?.toDate() ??
                                      DateTime.now();

                              return GridItem(
                                name: title,
                                city: city,
                                description: description,
                                documentId: documentId,
                                startDate:
                                    startDate, // القيمة الخاصة بتاريخ البداية
                                endDate: endDate,
                              );
                            },
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.05,
                                vertical: 10.0),
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final document = documents[index];
                              final data =
                                  document.data() as Map<String, dynamic>;
                              final title = data['name'] ?? 'لا يوجد اسم';
                              final city =
                                  data['city'] ?? 'لم يتم تحديد موقع الجمعية';
                              final description = data['description'] ??
                                  'لم يتم تحديد وصف الجمعية';
                              final documentId =
                                  document.id; // الحصول على documentId
                              final startDate =
                                  (data['startDate'] as Timestamp?)?.toDate() ??
                                      DateTime.now();
                              final endDate =
                                  (data['endDate'] as Timestamp?)?.toDate() ??
                                      DateTime.now();

                              return ListTile(
                                title: Text(
                                  title,
                                  textAlign: TextAlign.right,
                                  style: const ArabicTextStyle(
                                    fontSize: 16,
                                    arabicFont: 'Changa',
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    
                                    const SizedBox(height: 4),
                                    Text(
                                      city,
                                      textAlign: TextAlign.right,
                                      style: ArabicTextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                        arabicFont: 'Changa',
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 8), // مسافة إضافية بين العناصر
                                    // إضافة تاريخ البداية والنهاية
                                    Text(
                                      'تاريخ البدء: ${DateFormat('yyyy-MM-dd').format(startDate)} | تاريخ الانتهاء: ${DateFormat('yyyy-MM-dd').format(endDate)}',
                                      textAlign: TextAlign.right,
                                      style: ArabicTextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                        arabicFont: 'Changa',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.all(8),
                                leading: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegistrationPage(
                                          title: title,
                                          city: city,
                                          description: description,
                                          documentId: documentId,
                                          startDate:
                                              startDate, // القيمة الخاصة بتاريخ البداية
                                          endDate: endDate,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.lightgreen,
                                  ),
                                  child: const Text(
                                    'تسجيل',
                                    style: ArabicTextStyle(
                                      fontSize: 14,
                                      color: AppColors.AwonWhite,
                                      arabicFont: 'Changa',
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                  height: 10, color: Colors.grey[300]);
                            },
                          );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class GridItem extends StatelessWidget {
  final String name;
  final String city;
  final String description;
  final String documentId;
  final DateTime startDate; // إضافة تاريخ البداية
  final DateTime endDate;

  const GridItem({
    Key? key,
    required this.name,
    required this.city,
    required this.description,
    required this.documentId,
    required this.startDate, // إضافة معامل تاريخ البداية
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationPage(
              title: name,
              city: city,
              description: description,
              documentId: documentId,
              startDate: startDate, // القيمة الخاصة بتاريخ البداية
              endDate: endDate,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.AwonWhite,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightblue.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: const ArabicTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          arabicFont: 'Changa',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        city,
                        style: ArabicTextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          arabicFont: 'Changa',
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      Text(
                        'تاريخ البدء: ${DateFormat('yyyy-MM-dd').format(startDate)}',
                        style: ArabicTextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          arabicFont: 'Changa',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تاريخ الانتهاء: ${DateFormat('yyyy-MM-dd').format(endDate)}',
                        style: ArabicTextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          arabicFont: 'Changa',
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationPage(
                                title: name,
                                city: city,
                                description: description,
                                documentId: documentId,
                                startDate:
                                    startDate, // القيمة الخاصة بتاريخ البداية
                                endDate: endDate,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightgreen,
                        ),
                        child: const Text(
                          'تسجيل',
                          style: ArabicTextStyle(
                            fontSize: 14,
                            color: AppColors.AwonWhite,
                            arabicFont: 'Changa',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

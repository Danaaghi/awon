import 'package:arabic_font/arabic_font.dart';
import 'package:awon_pro/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RegistrationPage extends StatelessWidget {
  final String title;
  final String city;
  final String description;
  final String documentId;
  final DateTime startDate; // إضافة تاريخ البداية
  final DateTime endDate;

  const RegistrationPage({
    super.key,
    required this.title,
    required this.city,
    required this.description,
    required this.documentId,
    required this.startDate, // إضافة معامل تاريخ البداية
    required this.endDate,
  });

  Future<bool> registerVolunteer() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user signed in');
      }

      final fullName = await fetchCurrentUserFullName(user.uid);
      if (fullName == null) {
        throw Exception('User first name not found');
      }

      final docRef =
          FirebaseFirestore.instance.collection('associations').doc(documentId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('Association not found');
      }

      final data = docSnapshot.data();
      final volunteers = data?['volunteers'] as List<dynamic>?;

      // Check if the user is already registered
      if (volunteers != null &&
          volunteers.any((v) => v['user_Id'] == user.uid)) {
        return false; // User is already registered
      }

      // Proceed with registration if not already registered
      await docRef.update({
        'volunteers': FieldValue.arrayUnion([
          {
            'user_Id': user.uid,
            'name': fullName,
            'date': Timestamp.now(),
          }
        ]),
      });

      final qrData = data?['qrData'];
      if (qrData != null) {
        await docRef.update({
          'Users': FieldValue.arrayUnion([
            {
              'qrData': qrData,
            }
          ]),
        });
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .update({
          'qrData': qrData,
        });
      }

      return true; // Registration successful
    } catch (e) {
      print('Error registering volunteer: $e');
      return false; // Registration failed
    }
  }

  Future<String?> fetchCurrentUserFullName(String uid) async {
    try {
      final docSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      String firstName = docSnapshot.get('first_name');
      String lastName = docSnapshot.get('last_name');

      return '$firstName $lastName'; // إرجاع الاسم الكامل
    } catch (e) {
      print('Error fetching user full name: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_sharp,
              color: AppColors.AwonWhite,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: AppColors.darkblue,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 0,
              ),
              Icon(
                Icons.check_circle,
                color: AppColors.AwonWhite,
                size: 200,
              ),
              SizedBox(height: 20),
              Text(
                ': أنـت الان تـسـجـــل فـي ',
                style: ArabicTextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  arabicFont: 'Changa',
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
              Divider(
                color: AppColors.lightgreen,
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'جمعية : $title\n',
                            style: ArabicTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              arabicFont: 'Changa',
                              color: AppColors.AwonWhite,
                            ),
                          ),
                          TextSpan(
                            text: 'المدينة : $city\n',
                            style: ArabicTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              arabicFont: 'Changa',
                              color: AppColors.AwonWhite,
                            ),
                          ),
                          TextSpan(
                            text: 'الوصف : $description\n',
                            style: ArabicTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              arabicFont: 'Changa',
                              color: AppColors.AwonWhite,
                            ),
                          ),
                          TextSpan(
                            text:
                                'تاريخ البدء: ${DateFormat('yyyy-MM-dd').format(startDate)}\n',
                            style: ArabicTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              arabicFont: 'Changa',
                              color: AppColors.AwonWhite,
                            ),
                          ),
                          TextSpan(
                            text:
                                'تاريخ الانتهاء: ${DateFormat('yyyy-MM-dd').format(endDate)}',
                            style: ArabicTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              arabicFont: 'Changa',
                              color: AppColors.AwonWhite,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 4,
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        bool success = await registerVolunteer();
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم التسجيل بنجاح!'),
                              backgroundColor: AppColors.lightgreen,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('أنت مسجل بالفعل في هذه الجمعية'),
                              backgroundColor: AppColors.lightgreen,
                            ),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.darkblue,
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 12.0), // الحشو
                        elevation: 3,
                        shadowColor: AppColors.lightgreen.withOpacity(0.9),
                        side: BorderSide(
                          color: AppColors.lightgreen,
                          width: 2.0,
                        ),
                      ),
                      child: Text(
                        'سجل الآن',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

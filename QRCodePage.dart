// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:awon_pro/colors.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;

  void _processQrData(String? qrData) async {
    if (_isProcessing || qrData == null || qrData.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    cameraController.stop();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      await _showDialog('User not signed in.');
      _resetProcess();
      return;
    }

    try {
      final associationsRef = FirebaseFirestore.instance.collection('associations');
      final associativeSnapshot = await associationsRef.where('qrData', isEqualTo: qrData).get();

      if (associativeSnapshot.docs.isEmpty) {
        await _showDialog('عذرًا ، يبدو ان لا يوجد جمعية بهذا الباركود');
        _resetProcess();
        return;
      }

      final associationDoc = associativeSnapshot.docs.first;
      final volunteerList = associationDoc['volunteers'] as List;
      final isRegistered = volunteerList.any((volunteer) => volunteer['user_Id'] == userId);

      if (!isRegistered) {
        await _showDialog('أنت غير مسجل في هذه الجمعية');
        _resetProcess();
        return;
      }

      final userRef = FirebaseFirestore.instance.collection('Users').doc(userId);
      DocumentSnapshot userDoc = await userRef.get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

      final isCheckedIn = userData?['status'] == 'checked_in';
      final checkInTime = userData?['checkInTime']?.toDate();

      if (isCheckedIn) {
        final checkOutTime = DateTime.now();
      
        if (checkInTime != null) {
          final isNewDay = checkOutTime.day != checkInTime.day ||
                           checkOutTime.month != checkInTime.month || 
                           checkOutTime.year != checkInTime.year;
      
          double sessionHours;
          String message;
          if (isNewDay) {
            sessionHours = 1.0;
            message = "عزيزنا المتطوع ، يبدو أنك لم تقم بتسجيل الخروج بالأمس. يؤسفنا ان نبلغك لجودة حساب الساعات تم ضبط ساعات تطوعك تلقائيًا على ساعة واحده ";
          } else {
            sessionHours = checkOutTime.difference(checkInTime).inMinutes / 60.0;
            message = "تم تسجيل الخروج !\n اجمالي الساعات لهذةالفترة ${sessionHours.toStringAsFixed(2)}.";
          }

          final previousTotalHours = (userData?['totalHours'] ?? 0) is int
    ? (userData?['totalHours'] ?? 0).toDouble()
    : (userData?['totalHours'] ?? 0.0) as double;

          final newTotalHours = previousTotalHours + sessionHours;

          await userRef.update({
            'checkOutTime': checkOutTime,
            'status': 'checked_out',
            'hours': sessionHours,
            'totalHours': newTotalHours,
          });

          await _showDialog('$message\n الساعات الاجماليه  ${newTotalHours.toStringAsFixed(2)}');
        } else {
          await _showDialog('Check-in time missing, unable to calculate session.');
        }
      } else {
        await userRef.set({
          'qrData': qrData,
          'checkInTime': DateTime.now(),
          'status': 'checked_in'
        }, SetOptions(merge: true));

        await _showDialog('تم تسجيل الدخول ');
      }

    } catch (e) {
      print('Error: $e');
      await _showDialog('Error: $e');
    } finally {
      _resetProcess();
    }
  }

  void _resetProcess() {
    setState(() {
      _isProcessing = false;
    });
    cameraController.start();
  }

 Future<void> _showDialog(String message) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:  AppColors.lightblue, // لون الخلفية
        title: Directionality(
          textDirection: TextDirection.rtl, // تحديد اتجاه النص
          child: Text(
            'رسالة',
            style: const TextStyle(
              color: Colors.white, // لون العنوان
            ),
          ),
        ),
        content: Directionality(
          textDirection: TextDirection.rtl, // تحديد اتجاه النص
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white, // لون الرسالة
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'موافق',
              style: TextStyle(color: Colors.white), // لون نص الزر
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.AwonWhite,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              height: MediaQuery.of(context).size.height * 0.23,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.darkblue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.elliptical(800, 100),
                  bottomRight: Radius.elliptical(800, 100),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.qr_code_scanner,
                      size: 50,
                      color: AppColors.AwonWhite,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "QR امسح رمز ",
                      style: ArabicTextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        arabicFont: 'changa',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: MobileScanner(
                    controller: cameraController,
                    onDetect: (barcode) {
                      for (final qrData in barcode.barcodes) {
                        _processQrData(qrData.rawValue);
                      }
                    },
                  ),
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

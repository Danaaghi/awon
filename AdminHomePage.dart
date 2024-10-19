import 'package:awon_pro/admin/GenerateBarcode.dart';
import 'package:awon_pro/admin/createAssociation.dart';
import 'package:awon_pro/colors.dart';
import 'package:awon_pro/registerpages/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:arabic_font/arabic_font.dart';
import 'package:awon_pro/admin/ViewAssociations.dart';
import 'package:flutter/services.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.darkblue,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  'اهلًا بك في عَوْن',
                  style: ArabicTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    arabicFont: 'Changa',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                height: 700,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: AppColors.AwonWhite,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      // خانة إنشاء جمعية
                      _buildCard(
                        context,
                        'إنشاء جمعية',
                        Icons.library_add_rounded,
                        CreateAssociation(),
                      ),
                      SizedBox(height: 20),

                      // خانة عرض الجمعيات
                      _buildCard(
                        context,
                        'عرض الجمعيات',
                        Icons.view_list_rounded,
                        ViewAssociations(),
                      ),
                      SizedBox(height: 20),

                      // خانة إنشاء باركود
                      _buildCard(
                        context,
                        'إنشاء باركود',
                        Icons.qr_code_2_rounded,
                        GenerateBarcode(),
                      ),
                      SizedBox(height: 20),

                      // خانة تسجيل خروج
                      _buildCard(
                        context,
                        'تسجيل خروج',
                        Icons.output_rounded,
                        Welcomepage(),
                        isLogout: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, IconData icon, Widget page,
      {bool isLogout = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            //height: 70, // تحديد ارتفاع موحد للكارد
            width: 245, // يمكنك تعديل العرض حسب الحاجة
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    10), // تعديل قيمة نصف القطر حسب الحاجة
                side: BorderSide(
                  color: AppColors.darkblue, // لون الحدود
                ),
              ),
              color: AppColors.AwonWhite,
              elevation: 5,
              shadowColor: AppColors.lightblue,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  title,
                  style: ArabicTextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    arabicFont: 'changa',
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.AwonWhite,
              border: Border.all(
                color: AppColors.darkblue, // لون الحدود
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkblue.withOpacity(0.5), // لون الظل
                  blurRadius: 6.0, // مدى تلطخ الظل
                  spreadRadius: 1.0, // مدى انتشار الظل
                  offset: Offset(0, 2), // موضع الظل (يمين، أسفل)
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isLogout ? Colors.red : AppColors.lightgreen,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

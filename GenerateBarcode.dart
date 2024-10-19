import 'package:arabic_font/arabic_font.dart';
import 'package:awon_pro/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
//import 'package:share/share.dart';

class GenerateBarcode extends StatefulWidget {
  @override
  _GenerateBarcodeState createState() => _GenerateBarcodeState();
}

class _GenerateBarcodeState extends State<GenerateBarcode> {
  String? selectedAssociation;
  String? qrData;
  List<String> associations = [];

  @override
  void initState() {
    super.initState();
    _fetchAssociations();
  }

  void _fetchAssociations() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('associations').get();
    setState(() {
      associations = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  void _generateBarcode() {
    if (selectedAssociation != null) {
      setState(() {
        qrData = selectedAssociation; // يمكنك تغيير هذا إلى أي بيانات تريدها
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  ' إنشاء رمز الاستجابة السريع',
                  style: ArabicTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    arabicFont: 'Changa',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: screenSize.height * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColors.AwonWhite,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.darkblue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            hint: Text(
                              'اختر جمعية',
                              style: TextStyle(color: Colors.black),
                            ),
                            value: selectedAssociation,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedAssociation = newValue;
                                qrData =
                                    null; // إعادة تعيين qrData عند تغيير الجمعية
                              });
                            },
                            dropdownColor: AppColors.AwonWhite,
                            isExpanded: true,
                            items: associations.map((String association) {
                              return DropdownMenuItem<String>(
                                value: association,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    association,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            underline: SizedBox.shrink(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: _generateBarcode,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.darkblue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50.0, vertical: 16.0),
                          elevation: 3,
                          shadowColor: AppColors.lightgreen.withOpacity(0.9),
                          side: BorderSide(
                            color: Color(0xFFA8c082),
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          'إنشاء باركود',
                          style: ArabicTextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            arabicFont: 'changa',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (qrData != null) ...[
                        Text(
                          'الباركود :',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.lightgreen, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          child: PrettyQr(
                            data: qrData!,
                            size: 200,
                            roundEdges: true,
                          ),
                        ),
                        SizedBox(height: 10),
                       
                      ],
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
}

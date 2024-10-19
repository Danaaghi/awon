// ignore_for_file: library_private_types_in_public_api

import 'package:arabic_font/arabic_font.dart';
import 'package:awon_pro/admin/AdminHomePage.dart';
import 'package:awon_pro/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CreateAssociation extends StatefulWidget {
  @override
  _CreateAssociationState createState() => _CreateAssociationState();
}

class _CreateAssociationState extends State<CreateAssociation> {
  final TextEditingController nameOfassociation = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  String? qrData;

  @override
  void dispose() {
    nameOfassociation.dispose();
    description.dispose();
    capacityController.dispose();
    cityController.dispose();
    super.dispose();
  }

  Future<void> addUserDetails() async {

  String name = nameOfassociation.text.trim();
  int capacity = int.tryParse(capacityController.text.trim()) ?? 0;
  String city = cityController.text.trim();
  String descriptionOfassociation = description.text.trim();

  // Check for empty fields or invalid capacity
  if (name.isEmpty || descriptionOfassociation.isEmpty || 
      capacity <= 0 || city.isEmpty || startDate == null || endDate == null) {
    showErrorDialog('يرجى ملء جميع الحقول');
    return; // Exit the function if validation fails
  }

  try {
    // Check if an association already exists with the same start date
    QuerySnapshot existingAssociations = await FirebaseFirestore.instance
        .collection('associations')
        .where('startDate', isEqualTo: Timestamp.fromDate(startDate!))
        .get();

    if (existingAssociations.docs.isNotEmpty) {
      showErrorDialog('يوجد جمعية بالفعل بنفس تاريخ البدء ، الرجاء اختيار تاريخ اخر');
      return; // Exit the function if a conflict is found
    }

    // Store the data including startDate and endDate in Firestore
    DocumentReference docRef = await FirebaseFirestore.instance.collection('associations').add({
      'name': name,
      'description': descriptionOfassociation,
      'city': city,
      'capacity': capacity,
      'qrData': name, // Save the name used for QR code
      'startDate': Timestamp.fromDate(startDate!),
      'endDate': Timestamp.fromDate(endDate!),
    });

    setState(() {
      qrData = name; // Update qrData to generate QR code
    });

     await showSuccessDialog('تم إنشاء الجمعية بنجاح');

    // Navigate to AdminHomePage after the dialog is dismissed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminHomePage()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('حدث خطأ عند حفظ البيانات: $e')),
    );
  }
}
Future<void> showSuccessDialog(String message) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.lightblue,
        title: Center(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Changa',
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
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


void showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor:  AppColors.lightblue,
        title: Center(
          child: Text(
            message,
            textAlign: TextAlign.right, // Align text to the right
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Changa',
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
              textAlign: TextAlign.right, // Align button text to the right (optional)
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


  void _selectStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.darkblue, // لون شريط العنوان
            hintColor: AppColors.darkblue, // لون العنصر المحدد
            colorScheme: ColorScheme.light(
                primary: AppColors.darkblue), // تخصيص لون الثيم
            buttonTheme:
                ButtonThemeData(textTheme: ButtonTextTheme.primary), // تخصيص زر
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  void _selectEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.darkblue,
            hintColor: AppColors.darkblue,
            colorScheme: ColorScheme.light(primary: AppColors.darkblue),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Get screen size

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
                  'إنشاء جمعية تطوعية',
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
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                height: screenSize.height * 0.9,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 5),
                      _buildTextField("اسم الجمعية", nameOfassociation),
                      SizedBox(height: 5),
                      _buildTextField("وصف الجمعية", description),
                      SizedBox(height: 5),
                      _buildTextField("عدد المتطوعين", capacityController,
                          keyboardType: TextInputType.number),
                      SizedBox(height: 5),
                      _buildTextField("المدينة", cityController,
                          keyboardType: TextInputType.text),
                      SizedBox(height: 5),
                      Text(
                        'تاريخ البدء',
                        textAlign: TextAlign.right,
                        style: ArabicTextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkblue,
                          arabicFont: 'changa',
                        ),
                      ),
                      SizedBox(height: 8.0),
                      _buildDateField(startDate, _selectStartDate),
                      SizedBox(height: 20),
                      Text(
                        'تاريخ الانتهاء',
                        textAlign: TextAlign.right,
                        style: ArabicTextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkblue,
                          arabicFont: 'changa',
                        ),
                      ),
                      SizedBox(height: 8.0),
                      _buildDateField(endDate, _selectEndDate),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: addUserDetails,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Color(0xFF194173),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 16.0),
                              elevation: 3,
                              shadowColor:
                                  AppColors.lightgreen.withOpacity(0.9),
                              side: BorderSide(
                                color: Color(0xFFA8c082),
                                width: 2.0,
                              ),
                            ),
                            child: Text(
                              'حفظ',
                              style: ArabicTextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                arabicFont: 'changa',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
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

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: ArabicTextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: AppColors.darkblue,
            arabicFont: 'changa',
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.lightgreen,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(DateTime? date, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
            text: date != null ? DateFormat('yyyy-MM-dd').format(date) : '',
          ),
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFA8c082)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
  
  
}

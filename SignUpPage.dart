// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, library_private_types_in_public_api, non_constant_identifier_names

import 'package:arabic_font/arabic_font.dart';
import 'package:awon_pro/OtpPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awon_pro/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _EmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _AgeContoller = TextEditingController();
  final Timestamp initialCheckInTime = Timestamp.now(); // or any other logic to set this
  final Timestamp initialCheckOutTime = Timestamp.now(); // initial value might be null
  final int initialHours = 0;
  final String initialStatus = 'unchecked';
  final String qrData ='';


  int? selectedAge;
  String? _birthDateError;

  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Auth

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _EmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _AgeContoller.dispose();

  }

  Future<void> signUp() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
  showErrorDialog('يبدو أن كلمة المرور وتأكيد كلمة المرور غير متطابقتين');
  return; // Exit the function if the passwords don't match
}

   
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _EmailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Add user details
        await addUserDetails(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          int.parse(_AgeContoller.text.trim()),
          _EmailController.text.trim(),
          initialCheckInTime,
          initialCheckOutTime,
          initialHours,
          initialStatus ,
          qrData
          // Ensure this is correctly set
        );

await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.lightblue,
        title: Center(
          child: Text(
            'تم انشاء الحساب بنجاح',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.right, // توجيه النص إلى اليمين
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'حسناً',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );

        Navigator.pushReplacement(
          
          context,
          MaterialPageRoute(builder: (context) => OtpPage()),
        );
      }catch (e) {
  // Check for specific Firebase Auth errors
  if (e is FirebaseAuthException) {
    print('Firebase Auth Error Code: ${e.code}');
    switch (e.code) {
      case 'invalid-email':
        showErrorDialog('الرجاء ادخال بريد الكتروني صحيح');
        break;
      case 'email-already-in-use':
        showErrorDialog('البريد الإلكتروني مستخدم بالفعل');
        break;
      case 'operation-not-allowed':
        showErrorDialog('هذه العملية غير مسموح بها');
        break;
      case 'weak-password':
        showErrorDialog('كلمة المرور ضعيفة جدًا');
        break;
        case 'missing-password': {
       showErrorDialog('الرجاء كتابة كلمة المرور') ;
      }
      default:
        showErrorDialog('حدث خطأ، الرجاء المحاولة مرة أخرى ');
    }
  } else {
    // Handle other exceptions
    showErrorDialog('Error: ${e.toString()}');
  }
}

      

    
  }

  bool passwordConfirmed() {
    return _passwordController.text.trim() ==
        _confirmPasswordController.text.trim();
  }

  Future<void> addUserDetails(
    String firstName,
    String lastName,
    int age,
    String email,
    Timestamp checkInTime,
    Timestamp checkOutTime,
    int hours,
    String status,
      String qrData ,
  ) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
        'email': email,
        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,
        'totalHours': hours,
        'status': status,
        'qrData':''
      });
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
               textAlign: TextAlign.right,
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
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('/Users/danait/StudioProjects/awon_pro/assets/images/4.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 150.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: buildTextField(
                              'الاسم الاخير', _lastNameController, screenWidth),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: buildTextField(
                              'الاسم الاول', _firstNameController, screenWidth),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    buildDateDropdowns('العمر', screenWidth),
                    if (_birthDateError != null) ...[
                      SizedBox(height: 10),
                      Text(
                        _birthDateError!,
                        style: ArabicTextStyle(
                            color: Colors.red, arabicFont: 'changa'),
                      ),
                    ],
                    SizedBox(height: 10),
                    buildTextField('الإيميل', _EmailController, screenWidth),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: buildPasswordField('تأكيد كلمة المرور',
                              _confirmPasswordController, screenWidth),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: buildPasswordField(
                              'كلمة المرور', _passwordController, screenWidth),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          ':ملاحظة ',
                          style: ArabicTextStyle(
                            arabicFont: ArabicFont.changa,
                            color: AppColors.AwonWhite,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل',
                          style: ArabicTextStyle(
                            arabicFont: ArabicFont.changa,
                            color: AppColors.AwonWhite,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'يجب أن تشمل أرقامًا وأحرفًا كبيرة وصغيرة',
                          style: ArabicTextStyle(
                            arabicFont: ArabicFont.changa,
                            color: AppColors.AwonWhite,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: signUp, // Updated method call
                      child: Text(
                        'إنشاء حساب',
                        style: ArabicTextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            arabicFont: 'changa'),
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: AppColors.lightgreen.withOpacity(0.9),
                        elevation: 3,
                        backgroundColor: AppColors.lightgreen,
                        padding: EdgeInsets.symmetric(
                            horizontal: 100.0, vertical: 15.0),
                        textStyle:
                            ArabicTextStyle(fontSize: 16, arabicFont: 'changa'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back Icon
          Positioned(
            top: 25,
            left: 6,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              color: Color(0xFF194173),
              iconSize: 30.0,
            ),
          ),
        ],
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
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.lightblue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDateDropdowns(String label, double screenWidth) {
    List<int> ageList = List.generate(45, (index) => index + 16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: ArabicTextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            arabicFont: 'changa',
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: screenWidth * 0.8, // استخدام عرض الشاشة لجعلها متجاوبة
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightblue),
            color: AppColors.lightblue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButton<int>(
            hint: Container(
              alignment: Alignment.center,
              child: Text(
                'اختار العمر',
                style: ArabicTextStyle(
                  color: Colors.black,
                  arabicFont: 'changa',
                ),
              ),
            ),
            value: selectedAge, // تأكد من تعريف selectedAge في حالة الكائن
            isExpanded: true,
            borderRadius: BorderRadius.circular(20),
            dropdownColor: AppColors.AwonWhite,
            onChanged: (int? newValue) {
              setState(() {
                selectedAge = newValue;
                // يمكنك تحديث نص المتحكم إذا لزم الأمر
                _AgeContoller.text = selectedAge.toString();
              });
            },
            underline: SizedBox.shrink(),
            items: ageList.map<DropdownMenuItem<int>>((int age) {
              return DropdownMenuItem<int>(
                value: age,
                child: Center(child: Text(age.toString())),
              );
            }).toList(),
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
              color: AppColors.AwonWhite,
              arabicFont: 'changa'),
        ),
        SizedBox(height: 8.0),
        Container(
          width: 300,
          child: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.lightblue,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            ),
          ),
        ),
      ],
    );
  }
}

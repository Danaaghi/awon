import 'package:arabic_font/arabic_font.dart';
import 'package:awon_pro/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewAssociations extends StatefulWidget {
  @override
  _ViewAssociationsState createState() => _ViewAssociationsState();
}

class _ViewAssociationsState extends State<ViewAssociations> {
  final Stream<QuerySnapshot> _associationsStream =
      FirebaseFirestore.instance.collection('associations').snapshots();

  void _deleteAssociation(String id) {
    // تنفيذ عملية الحذف من قاعدة البيانات
    FirebaseFirestore.instance.collection('associations').doc(id).delete();
  }

  void _editAssociation(BuildContext context, DocumentSnapshot association) {
    String formatDate(DateTime date) {
      List<String> arabicMonths = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return '${date.day} ${arabicMonths[date.month - 1]} ${date.year}';
    }

    final TextEditingController nameController =
        TextEditingController(text: association['name']);
    final TextEditingController descriptionController =
        TextEditingController(text: association['description']);
    final TextEditingController cityController =
        TextEditingController(text: association['city']);
    final TextEditingController capacityController = TextEditingController(
      text: association['capacity'].toString(),
    );
    DateTime startDate = association['startDate'].toDate();
    DateTime endDate = association['endDate'].toDate();

    Future<void> _selectDate(BuildContext context, bool isstartDate) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: isstartDate ? startDate : endDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              dialogBackgroundColor: AppColors.darkblue, // اللون الرئيسي
              primaryColor: AppColors.lightgreen, // لون الأزرار
              colorScheme: ColorScheme.light(primary: AppColors.darkblue),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != (isstartDate ? startDate : endDate)) {
        setState(() {
          if (isstartDate) {
            startDate = picked;
          } else {
            endDate = picked;
          }
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تعديل الجمعية', textAlign: TextAlign.end),
          backgroundColor: AppColors.AwonWhite,
          content: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'اسم الجمعية'),
                    textDirection: TextDirection.rtl,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'الوصف'),
                    textDirection: TextDirection.rtl,
                  ),
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(labelText: 'المدينة'),
                    textDirection: TextDirection.rtl,
                  ),
                  TextField(
                    controller: capacityController,
                    decoration: InputDecoration(labelText: 'عدد المتطوعين'),
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.rtl,
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Text(
                      'تاريخ البدء: ${formatDate(startDate)}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Text(
                      'تاريخ الانتهاء: ${formatDate(endDate)}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('تعديل'),
              onPressed: () {
                 String formattedStartDate = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
    String formattedEndDate = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

                

                FirebaseFirestore.instance
                    .collection('associations')
                    .doc(association.id)
                    .update({
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'city': cityController.text,
                  'capacity': int.tryParse(capacityController.text) ?? 0,
                  'qrData':nameController.text ,
                  'startDate': Timestamp.fromDate(startDate),
                  'endDate': Timestamp.fromDate(endDate),
                }).then((_) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم التعديل بنجاح')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('فشل التعديل: $error')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد أنك تريد حذف هذه الجمعية؟'),
          actions: [
            TextButton(
              child: Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('حذف'),
              onPressed: () {
                _deleteAssociation(id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف الجمعية!')),
                );
              },
            ),
          ],
        );
      },
    );
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
                  '  الجمعيات',
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
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _associationsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              'لا توجد جمعيات لعرضها',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.right,
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var association = snapshot.data!.docs[index];
                            return Card(
                              color: AppColors.AwonWhite,
                              elevation: 5,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: AppColors.darkblue,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${index + 1} .',
                                          style: ArabicTextStyle(
                                            fontSize: 16,
                                            arabicFont: 'changa',
                                            color: AppColors.lightgreen,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            association['name'],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'وصف: ${association['description']}',
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'المدينة: ${association['city']}',
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'عدد المتطوعين : ${association['capacity']}',
                                      textAlign: TextAlign.right,
                                    ),
                                    SizedBox(height: 5),
                                   Text(
  'تاريخ البدء: ${association['startDate'].toDate().toLocal().toString().split(' ')[0]}',
  textAlign: TextAlign.right,
),
SizedBox(height: 5),
Text(
  'تاريخ الانتهاء: ${association['endDate'].toDate().toLocal().toString().split(' ')[0]}',
  textAlign: TextAlign.right,
),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: AppColors.lightgreen),
                                          onPressed: () {
                                            _editAssociation(
                                                context, association);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _confirmDelete(association.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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

// ignore_for_file: prefer_const_constructors

import 'package:arabic_font/arabic_font.dart';
import 'package:awon_pro/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Widget to get user information
class GetUserInfo extends StatelessWidget {
  final String documentId;
  final String currentUserEmail; // إضافة متغير البريد الإلكتروني الحالي

  const GetUserInfo(
      {super.key, required this.documentId, required this.currentUserEmail});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data found.');
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        String firstName = data['first_name'] ?? 'No First Name';
        String lastName = data['last_name'] ?? 'No Last Name';
        String totalHours = data['totalHours']?.toString() ?? '0';
        String userEmail =
            data['email'] ?? ''; // افترض وجود حقل البريد الإلكتروني

        bool isCurrentUser =
            userEmail == currentUserEmail; // تحقق إذا كان المستخدم الحالي

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal:10.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: AppColors.lightgreen.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                totalHours,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                '$firstName $lastName',
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.textColor,
                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        );
      },
    );
  }
}

// Main application for displaying volunteer rankings
class VolunteerRankingApp extends StatefulWidget {
  const VolunteerRankingApp({super.key});

  @override
  State<VolunteerRankingApp> createState() => _VolunteerRankingAppState();
}

class _VolunteerRankingAppState extends State<VolunteerRankingApp> {
  final user = FirebaseAuth.instance.currentUser;

  // Function to get document IDs
  Future<List<String>> getDocIds() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .orderBy('totalHours', descending: true)
        .get();

    return snapshot.docs.map((document) => document.reference.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Get screen size

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.AwonWhite, // Set main background color
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
                    'لوحة الشرف',
                    style: ArabicTextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
        body: FutureBuilder<List<String>>(
          future:
              getDocIds(), // Ensure this returns a List<String> of document IDs
          builder: (context, snapshot) {
            // Check the connection state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No documents found.'));
            }

            // Get the list of document IDs from the snapshot
            final docID = snapshot.data!;

            return Column(
              children: [
               Container(
  padding: EdgeInsets.all(25.0),
  color: AppColors.AwonWhite, // Background color of the header
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between elements
    children: const [
      Text(
        'عدد الساعات',
        style: ArabicTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          arabicFont: 'changa',
        ),
      ),
      Text(
        'اسم المتطوع',
        style: ArabicTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          arabicFont: 'changa',
        ),
      ),
    ],
  ),
),

                Divider(
                  thickness: 2,
                  color: AppColors.lightblue,
                ),

// في الجزء الرئيسي، مرر البريد الإلكتروني الحالي إلى GetUserInfo
                Expanded(
                  child: ListView.separated(
                    itemCount: docID.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(docID[index])
                              .get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (userSnapshot.hasError) {
                              return Text('Error: ${userSnapshot.error}');
                            } else if (!userSnapshot.hasData ||
                                userSnapshot.data == null) {
                              return Text('No user data found.');
                            }

                            Map<String, dynamic> userData = userSnapshot.data!
                                .data() as Map<String, dynamic>;
                            String userEmail = userData['email'] ?? '';

                            bool isCurrentUser = user?.email ==
                                userEmail; // تحقق إذا كان المستخدم الحالي

                            return Container(
                              color: isCurrentUser
                                  ? AppColors.lightblue.withOpacity(0.4)
                                  : AppColors
                                      .AwonWhite, // تحقق إذا كان المستخدم الحالي

                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: GetUserInfo(
                                        documentId: docID[index],
                                        currentUserEmail: user?.email ?? '',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '.${index + 1} ',
                                      style: ArabicTextStyle(
                                        fontSize: 16,
                                        arabicFont: 'changa',
                                        color: AppColors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                contentPadding: const EdgeInsets.all(15),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 10,
                        color: AppColors.lightgreen,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:attendify/views/screens/student/student_attendance.dart';
import 'package:attendify/views/screens/student/student_profile_page.dart';
import 'package:attendify/views/widgets/display_toast.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../staff/staff_attendance_page.dart';
import '../staff/staff_quiz_page.dart';
import '../staff/staff_report_page.dart';
import '../student/student_quiz_page.dart';


class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  DisplayToast disp = DisplayToast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Center(
        child: Column(
          children: [
            (_page == 0)
                ? StudentAttendancePage()
                : ((_page == 1) ? StudentQuizPage() : StudentProfilePage())
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: kWhiteColor,
        color: kGreyColor.shade900,
        buttonBackgroundColor: kBlackColor,
        animationDuration: Duration(milliseconds: 300),
        height: 70.0,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        key: _bottomNavigationKey,
        items: const <Widget>[
          Icon(
            Icons.home,
            color: kWhiteColor,
            size: 30,
          ),
          Icon(
            Icons.quiz,
            color: kWhiteColor,
            size: 30,
          ),
          Icon(
            Icons.settings,
            color: kWhiteColor,
            size: 30,
          ),
        ],
      ),
    );
  }
}

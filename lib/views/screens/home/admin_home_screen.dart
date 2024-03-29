import 'package:attendify/views/widgets/display_toast.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../admin/admin_manage_page.dart';
import '../staff/staff_attendance_page.dart';
import '../staff/staff_quiz_page.dart';
import '../staff/staff_report_page.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  DisplayToast disp = DisplayToast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kWhiteColor,
      body: Center(
        child: Column(
          children: [
            (_page == 0)
                ? AdminManagePage()
                : ((_page == 1) ? StaffQuiz() : StaffReport())
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
            Icons.manage_accounts,
            color: kWhiteColor,
            size: 30,
          ),
          Icon(
            Icons.quiz,
            color: kWhiteColor,
            size: 30,
          ),
          Icon(
            Icons.pie_chart,
            color: kWhiteColor,
            size: 30,
          ),
        ],
      ),
    );
  }
}

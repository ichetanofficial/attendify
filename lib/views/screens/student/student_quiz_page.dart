import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class StudentQuizPage extends StatefulWidget {
  const StudentQuizPage({super.key});

  @override
  State<StudentQuizPage> createState() => _StudentQuizPageState();
}

class _StudentQuizPageState extends State<StudentQuizPage> {
  String? branch, sem, div, subject, question;
  String dispQue = "";

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    fetchAndBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Text("Hello There"),
            SizedBox(
              height: 10,
            ),
            Text(dispQue),
          ],
        ),
      ),
    );
  }

  Future<void> fetchAndBuild() async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    branch = prefs.getString("branch");
    sem = prefs.getString("sem");
    div = prefs.getString("div");
    subject = prefs.getString(formattedDate);
    question = prefs.getString("1$formattedDate");

    if (subject != null) {
      setState(() {
        dispQue = question!;
      });
    }
  }
}

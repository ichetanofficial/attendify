import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../widgets/dark_button.dart';
import '../../widgets/display_toast.dart';
import '../../widgets/text_input_field.dart';

class StaffQuiz extends StatefulWidget {
  const StaffQuiz({super.key});

  @override
  State<StaffQuiz> createState() => _StaffQuizState();
}

class _StaffQuizState extends State<StaffQuiz> {
  bool btnClicked = false, quizBtnClicked = false;
  String? branch, sem, div, subject;
  TextEditingController _branchController = TextEditingController();
  TextEditingController _semController = TextEditingController();
  TextEditingController _divController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _q1Controller = TextEditingController();

  DisplayToast disp = DisplayToast();
  String text = "Question";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            if (!btnClicked && !quizBtnClicked)
              DarkButton(onPressed: setQuiz, text: "Set Quiz"),
            if (btnClicked && !quizBtnClicked)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  // height: 420,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(color: kBlackColor),
                    borderRadius:
                        BorderRadius.circular(8), // Define border radius
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          // Push other widgets to the leftmost position
                          InkWell(
                            onTap: closeContainer,
                            child: const Icon(
                              Icons.close,
                              // This is the icon for the cross
                              color: kBlackColor,
                              size: 30, // Set the size of the icon
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            TextInputField(
                                controller: _branchController,
                                icon: Icons.abc,
                                labelText: "Branch"),
                            const SizedBox(
                              height: 10,
                            ),
                            TextInputField(
                                controller: _semController,
                                icon: Icons.abc,
                                labelText: "Sem"),
                            const SizedBox(
                              height: 10,
                            ),
                            TextInputField(
                                controller: _divController,
                                icon: Icons.abc,
                                labelText: "Div"),
                            const SizedBox(
                              height: 10,
                            ),
                            TextInputField(
                                controller: _subjectController,
                                icon: Icons.abc,
                                labelText: "Subject"),
                            const SizedBox(
                              height: 10,
                            ),
                            DarkButton(onPressed: goBtnProcessor, text: "Go"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            if (quizBtnClicked)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  // height: 420,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(color: kBlackColor),
                    borderRadius:
                        BorderRadius.circular(8), // Define border radius
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          // Push other widgets to the leftmost position
                          InkWell(
                            onTap: closeContainer,
                            child: const Icon(
                              Icons.close,
                              // This is the icon for the cross
                              color: kBlackColor,
                              size: 30, // Set the size of the icon
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            TextInputField(
                                controller: _q1Controller,
                                icon: Icons.abc,
                                labelText: "Question"),
                            const SizedBox(
                              height: 10,
                            ),
                            DarkButton(onPressed: setBtnProcessor, text: "Set"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void setQuiz() {
    setState(() {
      btnClicked = true;
    });
  }

  void closeContainer() {
    setState(() {
      btnClicked = false;
    });

    branch = null;
    sem = null;
    div = null;
    subject = null;
  }

  void goBtnProcessor() {
    if (_branchController.text.trim().toString().isEmpty) {
      disp.toast("Enter Branch");
    } else if (_semController.text.trim().toString().isEmpty) {
      disp.toast("Enter Sem");
    } else if (_divController.text.trim().toString().isEmpty) {
      disp.toast("Enter Div");
    } else if (_subjectController.text.trim().toString().isEmpty) {
      disp.toast("Enter Subject");
    } else {
      branch = _branchController.text.trim().toString();
      sem = _semController.text.trim().toString();
      div = _divController.text.trim().toString();
      subject = _subjectController.text.trim().toString();

      validatePathAndAccess();
    }
  }

  void validatePathAndAccess() async {
    String branch = _branchController.text.trim();
    String sem = _semController.text.trim();
    String div = _divController.text.trim();
    String subject = _subjectController.text.trim();

    String subjectPath = 'attendance/$branch/$sem/$div/$subject';

    if (await doesCollectionExist(subjectPath)) {
      setState(() {
        btnClicked = false;
        quizBtnClicked = true;
      });
    } else {
      disp.toast("Invalid Selection");
      closeContainer();
    }
  }

  Future<bool> doesCollectionExist(String collectionPath) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  void setBtnProcessor() {
    if (_q1Controller.text.trim().toString().isNotEmpty) {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(now);

      var db = firestore
          .collection("attendance")
          .doc(branch)
          .collection(sem!)
          .doc(div)
          .collection(subject!)
          .doc(formattedDate);

      db.set({
        "question": _q1Controller.text.trim().toString(),
        "count": "1",
        "rollNos": {"0": "1"},
      });

      disp.toast("Updated");
      setState(() {
        btnClicked = false;
        quizBtnClicked = false;
      });
      closeContainer();
    } else {
      disp.toast("Question Field Empty");
    }
  }
}

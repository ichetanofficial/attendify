import 'package:attendify/constants.dart';
import 'package:attendify/views/widgets/dark_button.dart';
import 'package:attendify/views/widgets/display_toast.dart';
import 'package:attendify/views/widgets/text_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainAttendanceScrren extends StatefulWidget {
  String subject;

  MainAttendanceScrren(
    this.subject, {
    Key? key,
  }) : super(key: key);

  @override
  State<MainAttendanceScrren> createState() => _MainAttendanceScrrenState();
}

class _MainAttendanceScrrenState extends State<MainAttendanceScrren> {
  String generatedOTP = '';
  String subGeneratedOTP = '';
  String todaysDate = '';
  int timeLeft = 15, attendies = 0, flag = 0;
  late Timer _timer;
  TextEditingController _branchController = TextEditingController();
  TextEditingController _semController = TextEditingController();
  TextEditingController _divController = TextEditingController();
  TextEditingController _rollNumController = TextEditingController();
  DisplayToast disp = DisplayToast();
  bool otpBtnNotClicked = true;
  bool timerCanceled = false;
  late String branch, sem, div;
  List<String> studentRollNos = [];

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Go Back'),
            content: Text('Do you want to go back ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                if (otpBtnNotClicked)
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextInputField(
                          controller: _branchController,
                          icon: Icons.abc,
                          labelText: "Branch",
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextInputField(
                          controller: _semController,
                          icon: Icons.abc,
                          labelText: "Sem",
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextInputField(
                          controller: _divController,
                          icon: Icons.abc,
                          labelText: "Div",
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          generateOTPProcessor();
                        },
                        child: Text("Generate OTP"),
                      ),
                    ],
                  ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Generated OTP : ",
                      style: TextStyle(fontSize: 20),
                    ),
                    generatedOTP.isNotEmpty
                        ? Text(
                            "$generatedOTP",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Time Left : ",
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(
                      timeLeft.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (timerCanceled)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Attendees : ",
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            attendies.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            // Add this decoration
                            border: Border.all(color: kBlackColor),
                            // Define border properties
                            borderRadius: BorderRadius.circular(
                                8), // Define border radius
                          ),
                          padding: EdgeInsets.all(8),
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                studentRollNos.length,
                                (index) => Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 15),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      studentRollNos[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: -2, horizontal: 12),
                                    // Adjust padding if needed
                                    dense:
                                        true, // Add this line to reduce ListTile height
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextInputField(
                            controller: _rollNumController,
                            icon: Icons.numbers,
                            labelText: "Roll Number"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            child: DarkButton(
                                onPressed: addRollNumber, text: "Add"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 150,
                            child: DarkButton(
                                onPressed: removeRollNumber, text: "Remove"),
                          ),
                        ],
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startCountDown() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
        DatabaseReference timeRef = FirebaseDatabase.instance
            .ref("time/$branch/$sem/$div/${widget.subject}");
        await timeRef.update({
          "remTime": timeLeft,
          "otpNum": subGeneratedOTP,
        });
      } else {
        timer.cancel();
        getStudentList();
        setState(() {
          timerCanceled = true;
        });
      }
    });
  }

  Future<void> generateOTPProcessor() async {
    if (_branchController.text.trim().isEmpty) {
      disp.toast("Branch cannot be empty");
    } else if (_semController.text.trim().isEmpty) {
      disp.toast("Sem cannot be empty");
    } else if (_divController.text.trim().isEmpty) {
      disp.toast("Div cannot be empty");
    } else {
      branch = _branchController.text.trim();
      sem = _semController.text.trim();
      div = _divController.text.trim();
      final branchCollectionRef = firestore
          .collection("admin")
          .doc("branches")
          .collection("branch")
          .doc(branch)
          .collection(branch)
          .doc(sem)
          .collection(sem)
          .doc(div);

      branchCollectionRef.get().then((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          int count = data['count'];

          for (int i = 1; i <= count; i++) {
            if (data["subject$i"] == widget.subject) {
              setState(() {
                generatedOTP = (100000 + Random().nextInt(900000)).toString();
                subGeneratedOTP = generatedOTP;
                String temp =
                    "${generatedOTP.substring(0, 2)} ${generatedOTP.substring(2, 4)} ${generatedOTP.substring(4)}";
                generatedOTP = temp;
                otpBtnNotClicked = false;
              });

              _startCountDown();
              break;
            }
          }
        } else {
          disp.toast("Something is wrong1");
        }
      }).catchError((error) {
        disp.toast("Error occurred while checking collection");
      });
      setMAP();
    }
  }

  void setMAP() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    var db = firestore
        .collection("attendance")
        .doc(branch)
        .collection(sem)
        .doc(div)
        .collection(widget.subject)
        .doc(formattedDate);

    db.snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
      } else {
        db.set({
          "count": "1",
          "rollNos": {"0": "1"},
        });
      }
    }, onError: (error) {
      print("Error fetching document: $error");
    });
  }

  void getStudentList() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    var db = firestore
        .collection("attendance")
        .doc(branch)
        .collection(sem)
        .doc(div)
        .collection(widget.subject)
        .doc(formattedDate);

    db.snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<String> rollNos = [];
        if (data.containsKey("rollNos")) {
          Map<String, dynamic> rollNosMap = data['rollNos'];
          rollNos = rollNosMap.keys.toList();
          setState(() {
            studentRollNos.clear();
            studentRollNos.addAll(rollNos);
            attendies = studentRollNos.length - 1;
          });
          storeTotalCount();
        }
      } else {
        print('Document does not exist');
      }
    }, onError: (error) {
      print("Error fetching document: $error");
    });
  }

  Future<void> addRollNumber() async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    if (_rollNumController.text.trim().toString().isNotEmpty) {
      var attendanceRef = firestore
          .collection("attendance")
          .doc(branch)
          .collection(sem)
          .doc(div)
          .collection(widget.subject)
          .doc(formattedDate);

      await firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(attendanceRef);

        Map<String, dynamic> updateData = {};
        if (snapshot.exists) {
          updateData = snapshot.data()! as Map<String, dynamic>;
        }

        updateData["rollNos"] = {
          _rollNumController.text.trim().toString(): "1"
        };
        transaction.set(attendanceRef, updateData, SetOptions(merge: true));
      });
      disp.toast("Added Successfully");
    } else {
      disp.toast("Enter Roll Number");
    }
  }

  Future<void> removeRollNumber() async {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    if (_rollNumController.text.trim().toString().isNotEmpty) {
      var attendanceRef = firestore
          .collection("attendance")
          .doc(branch)
          .collection(sem)
          .doc(div)
          .collection(widget.subject)
          .doc(formattedDate);

      await firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(attendanceRef);

        if (snapshot.exists) {
          Map<String, dynamic> existingData =
              snapshot.data()! as Map<String, dynamic>;

          // Remove the specific roll number from the "rollNos" map
          existingData["rollNos"]!
              .remove(_rollNumController.text.trim().toString());

          // If "rollNos" is empty after removal, delete the entire document
          if (existingData["rollNos"].isEmpty) {
            transaction.delete(attendanceRef);
          } else {
            // Otherwise, update the document with the modified "rollNos" map
            transaction.update(attendanceRef, existingData);
          }
        }
      });
      disp.toast("Removed Successfully");
    } else {
      disp.toast("Enter Roll Number");
    }
  }

  void storeTotalCount() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    var db = firestore
        .collection("attendance")
        .doc(branch)
        .collection(sem)
        .doc(div)
        .collection(widget.subject)
        .doc(formattedDate);

    var docRef = firestore
        .collection("attendance")
        .doc(branch)
        .collection(sem)
        .doc(div)
        .collection(widget.subject)
        .doc(formattedDate);

    docRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        var data = docSnapshot.data();
        if (data!.containsKey("presentStudentsCount")) {
          db.update({"presentStudentsCount": attendies});
        } else {
          db.update({"presentStudentsCount": 0});
        }
      } else {
        // Document does not exist
      }
    });
  }
}

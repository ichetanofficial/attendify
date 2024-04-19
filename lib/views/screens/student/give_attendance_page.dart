import 'package:attendify/constants.dart';
import 'package:attendify/views/widgets/dark_button.dart';
import 'package:attendify/views/widgets/display_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GiveAttendancePage extends StatefulWidget {
  final String? subject;
  final String? branch, sem, div, otpNum;

  const GiveAttendancePage(
      {Key? key,
      required this.subject,
      required this.branch,
      required this.sem,
      required this.div,
      this.otpNum})
      : super(key: key);

  @override
  State<GiveAttendancePage> createState() => _GiveAttendancePageState();
}

class _GiveAttendancePageState extends State<GiveAttendancePage> {
  String remTime = "";
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  bool isOutFocus = true;
  String? username;
  DisplayToast disp = DisplayToast();

  Future<bool> _onBackPressed() async {
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
  void initState() {
    super.initState();
    initialSetup();
    alwaysChecks();
    focusNode.addListener(_onFocusChanged);
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 22, color: kBlackColor, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kBlackColor),
      ),
    );

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Material(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Pinput(
                controller: pinController,
                length: 6,
                focusNode: focusNode,
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsUserConsentApi,
                listenForMultipleSmsOnAndroid: true,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 8),
                validator: (value) {
                  return value == widget.otpNum ? null : 'Pin is incorrect';
                },
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                },
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 22,
                      height: 1,
                      color: kBlackColor,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    // borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kBlackColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: kFillColor,
                    // borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: kBlackColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(height: 30),
            DarkButton(onPressed: markAttendance, text: "Attendify"),
            Text(
              "$remTime",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void initialSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");

    DatabaseReference timeRef = FirebaseDatabase.instance.ref(
        "time/${widget.branch}/${widget.sem}/${widget.div}/${widget.subject}");
    timeRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      // Map<String, dynamic>? data = snapshot.value as Map<String, dynamic>?;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

      dynamic remTimeValue = data["remTime"];

      setState(() {
        remTime = remTimeValue.toString();
      });
    });
  }

  markAttendance() async {
    if (pinController.text.trim().toString() == widget.otpNum) {
      int remainingTime = int.tryParse(remTime) ?? 0;
      if (remainingTime > 0) {
        if (isOutFocus) {
          var now = DateTime.now();
          var formatter = DateFormat('yyyy-MM-dd');
          String formattedDate = formatter.format(now);

          var attendanceRef = firestore
              .collection("attendance")
              .doc(widget.branch)
              .collection(widget.sem!)
              .doc(widget.div)
              .collection(widget.subject!)
              .doc(formattedDate);

          await firestore.runTransaction((transaction) async {
            DocumentSnapshot snapshot = await transaction.get(attendanceRef);

            Map<String, dynamic> updateData = {};
            if (snapshot.exists) {
              updateData = snapshot.data()! as Map<String, dynamic>;
            }

            updateData["rollNos"] = {username: "1"};
            transaction.set(attendanceRef, updateData, SetOptions(merge: true));
          });

          disp.toast("Attendance marked successfully!");
        } else {
          disp.toast("Proxy Try Detected");
        }
      } else {
        disp.toast("Time's up");
      }
    } else {
      disp.toast("Incorrect Code");
    }
  }

  Future<void> alwaysChecks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    var db = firestore
        .collection("attendance")
        .doc(widget.branch)
        .collection(widget.sem!)
        .doc(widget.div)
        .collection(widget.subject!)
        .doc(formattedDate);

    db.snapshots().listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<String> rollNos = [];
        if (data.containsKey("rollNos")) {
          Map<String, dynamic> rollNosMap = data['rollNos'];
          rollNos = rollNosMap.keys.toList();

          if (data.containsKey("question")) {
            for (int i = 0; i < rollNos.length; i++) {
              if (username == rollNos[i]) ;
              prefs.setString(formattedDate, widget.subject!);
              prefs.setString("1$formattedDate", data["question"]);
              break;
            }
          }
        }
      } else {
        print('Document does not exist');
      }
    }, onError: (error) {
      print("Error fetching document: $error");
    });
  }

  void _onFocusChanged() {
    setState(() {
      isOutFocus = false;
    });

    focusNode.removeListener(_onFocusChanged);
  }
}

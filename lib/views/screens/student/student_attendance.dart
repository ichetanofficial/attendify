import 'dart:io';

import 'package:attendify/views/screens/student/give_attendance_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({Key? key}) : super(key: key);

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  List<String> subjects = [];
  int? count;
  String? branch, sem, div, otpNum;
  File? _image;
  final picker = ImagePicker();
  TransformationController _transformationController =
      TransformationController();
  bool shouldNavigate = true;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            _image == null || !_image!.existsSync()
                ? Container()
                : GestureDetector(
                    onDoubleTap: () {
                      _showImageOptions();
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 300,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        panEnabled: false,
                        boundaryMargin: EdgeInsets.all(double.infinity),
                        minScale: 1.0,
                        maxScale: 4.0,
                        onInteractionEnd: (_) {
                          setState(() {
                            _image!.existsSync()
                                ? _transformationController.value =
                                    Matrix4.identity()
                                : null;
                          });
                        },
                        child: Image.file(_image!),
                      ),
                    ),
                  ),
            _image == null
                ? ElevatedButton(
                    onPressed: () {
                      _showImageOptions();
                    },
                    child: Text("Add"),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Future<void> fetchInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    count = prefs.getInt("count");
    branch = prefs.getString("branch");
    sem = prefs.getString("sem");
    div = prefs.getString("div");

    checkActiveAttendance(count);

    setState(() {
      for (int i = 1; i <= count!; i++) {
        String? sub = prefs.getString("subject$i");
        if (sub != null) {
          subjects.add(sub);
        }
      }
    });

    String? imagePath = prefs.getString("imagePath");
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath); // Initialize _image with the stored imagePath
      });
    }
  }

  Future<void> _showImageOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take a picture'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Choose from gallery'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("imagePath", pickedFile.path);
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  void checkActiveAttendance(int? count) {
    if (count != null) {
      DatabaseReference timeRef =
          FirebaseDatabase.instance.ref("time/$branch/$sem/$div/");

      timeRef.onValue.listen((event) {
        if (event.snapshot.value != null) {
          DataSnapshot divSnapshot = event.snapshot;

          for (var subjectSnapshot in divSnapshot.children) {
            String? subject = subjectSnapshot.key;
            int? remTime;

            // Cast to a Map if you're sure data is structured like a Map
            if (subjectSnapshot.value is Map) {
              Map subjectData = subjectSnapshot.value as Map;
              if (subjectData.containsKey('remTime')) {
                remTime = subjectData['remTime'];
                otpNum = subjectData['otpNum'];
              } else {
                // Handle missing remTime
              }
            } else {
              // Handle case where data is not a Map (optional)
              print("Unexpected data structure for subject $subject");
            }

            if (remTime != 0 && remTime != null) {

              if(shouldNavigate){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiveAttendancePage(
                      subject: subject,
                      branch: branch,
                      sem: sem,
                      div: div,
                      otpNum: otpNum,
                    ),
                  ),
                );
              }
              shouldNavigate = false;

              break;
            }
          }
        } else {
          // ... (handle null data)
        }
      });
    }
  }
}

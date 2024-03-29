import 'dart:io';

import 'package:flutter/src/painting/box_border.dart' as flutter;
import 'package:attendify/views/widgets/dark_button.dart';
import 'package:attendify/views/widgets/display_toast.dart';
import 'package:attendify/views/widgets/text_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart package
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants.dart';

class StaffReport extends StatefulWidget {
  const StaffReport({Key? key}) : super(key: key);

  @override
  State<StaffReport> createState() => _StaffReportState();
}

class _StaffReportState extends State<StaffReport> {
  String? branch, sem, div, subject;
  bool btnClicked = false, isShowingCharts = false;
  int whichBtnClicked = -1;
  DisplayToast disp = DisplayToast();

  TextEditingController _branchController = TextEditingController();
  TextEditingController _semController = TextEditingController();
  TextEditingController _divController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  List<int> presentStudentsCounts = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            if (!btnClicked && (!isShowingCharts))
              DarkButton(onPressed: seeAttendance, text: "See History"),
            if (!btnClicked && (!isShowingCharts))
              DarkButton(onPressed: seeReport, text: "See Report"),
            if (btnClicked && (!isShowingCharts))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  // height: 420,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: flutter.Border.all(color: kBlackColor),
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
            if (isShowingCharts)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: presentStudentsCounts
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(entry.key.toDouble() + 1,
                                  entry.value.toDouble()))
                              .toList(),
                          isCurved: false,
                          color: Colors.blue,
                          barWidth: 1,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      minX: 1,
                      // Start x-axis from 1
                      maxX: presentStudentsCounts.length.toDouble(),
                      // End x-axis at the length of the list
                      minY: 0,
                      maxY: presentStudentsCounts.isNotEmpty
                          ? presentStudentsCounts
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble()
                          : 1,
                    ),
                  ),
                ),
              ),
            if (isShowingCharts)
              SizedBox(
                height: 20,
              ),
            if (isShowingCharts)
              InkWell(
                onTap: closeGraph(),
                child: Text(
                  "Close",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )
          ],
        ),
      ),
    );
  }

  void seeAttendance() {
    setState(() {
      btnClicked = true;
    });

    whichBtnClicked = 1;
  }

  void seeReport() {
    setState(() {
      btnClicked = true;
    });
    whichBtnClicked = 2;
  }

  void closeContainer() {
    setState(() {
      btnClicked = false;
      isShowingCharts = false;
    });
    branch = null;
    sem = null;
    div = null;
    subject = null;
    whichBtnClicked = -1;
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
      if (whichBtnClicked == 1) {
        downloadReport();
      } else if (whichBtnClicked == 2) {
        validatePathAndAccess();
      }
    }
  }

  void validatePathAndAccess() async {
    String branch = _branchController.text.trim();
    String sem = _semController.text.trim();
    String div = _divController.text.trim();
    String subject = _subjectController.text.trim();

    String subjectPath = 'attendance/$branch/$sem/$div/$subject';

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(subjectPath).get();

      presentStudentsCounts.clear();

      snapshot.docs.forEach((doc) {
        // Get the value of the presentStudentsCount field from each document
        dynamic presentCountData =
            (doc.data() as Map<String, dynamic>)['presentStudentsCount'];
        if (presentCountData is int) {
          presentStudentsCounts.add(presentCountData);
        } else if (presentCountData is String) {
          // Convert string to integer before adding to presentStudentsCounts
          presentStudentsCounts.add(int.parse(presentCountData));
        } else {
          // Handle if the data is neither int nor string
          print(
              'Unexpected data type for presentStudentsCount: $presentCountData');
        }
      });

      setState(() {
        btnClicked = false;
        isShowingCharts = true;
      });

      // Continue with your logic here
    } catch (e) {
      print('Error: $e');
      // Handle errors if any
    }
  }

  void downloadReport() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      Excel excel = Excel.createExcel();
      excel.rename(excel.getDefaultSheet()!, "Test Sheet");

      Sheet sheet = excel["Test Sheet"];
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));

      CellValue cellValue1 = const IntCellValue(1);

      cell.value = cellValue1;
      var cell2 = sheet.cell(CellIndex.indexByString("A2"));
      cell2.value = cellValue1;

      excel.save(fileName: 'My_Excel_File_Name.xlsx');
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

  closeGraph() {
    setState(() {
      btnClicked = false;
      isShowingCharts = false;
      branch = null;
      sem = null;
      div = null;
      subject = null;
      whichBtnClicked = -1;
    });
  }
}

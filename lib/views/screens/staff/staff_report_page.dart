// // import 'package:flutter/src/painting/box_border.dart' as flutter;
// // import 'package:attendify/views/widgets/dark_button.dart';
// // import 'package:attendify/views/widgets/display_toast.dart';
// // import 'package:attendify/views/widgets/text_input_field.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:fl_chart/fl_chart.dart'; //
// // import 'package:flutter/widgets.dart';
// // import '../../../constants.dart';
// //
// // class StaffReport extends StatefulWidget {
// //   const StaffReport({Key? key}) : super(key: key);
// //
// //   @override
// //   State<StaffReport> createState() => _StaffReportState();
// // }
// //
// // class _StaffReportState extends State<StaffReport> {
// //   String? branch, sem, div, subject;
// //   bool btnClicked = false, isShowingCharts = false;
// //   int whichBtnClicked = -1;
// //   DisplayToast disp = DisplayToast();
// //
// //   TextEditingController _branchController = TextEditingController();
// //   TextEditingController _semController = TextEditingController();
// //   TextEditingController _divController = TextEditingController();
// //   TextEditingController _subjectController = TextEditingController();
// //   List<int> presentStudentsCounts = [];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Material(
// //       child: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             SizedBox(
// //               height: 50,
// //             ),
// //             if (!btnClicked && (!isShowingCharts))
// //               DarkButton(onPressed: seeAttendance, text: "See History"),
// //             if (!btnClicked && (!isShowingCharts))
// //               DarkButton(onPressed: seeReport, text: "See Report"),
// //             if (btnClicked && (!isShowingCharts))
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 20),
// //                 child: Container(
// //                   // height: 420,
// //                   width: double.maxFinite,
// //                   decoration: BoxDecoration(
// //                     border: flutter.Border.all(color: kBlackColor),
// //                     borderRadius:
// //                         BorderRadius.circular(8), // Define border radius
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Spacer(),
// //                           // Push other widgets to the leftmost position
// //                           InkWell(
// //                             onTap: closeContainer,
// //                             child: const Icon(
// //                               Icons.close,
// //                               // This is the icon for the cross
// //                               color: kBlackColor,
// //                               size: 30, // Set the size of the icon
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       Container(
// //                         padding: EdgeInsets.symmetric(horizontal: 20),
// //                         child: Column(
// //                           children: [
// //                             TextInputField(
// //                                 controller: _branchController,
// //                                 icon: Icons.abc,
// //                                 labelText: "Branch"),
// //                             const SizedBox(
// //                               height: 10,
// //                             ),
// //                             TextInputField(
// //                                 controller: _semController,
// //                                 icon: Icons.abc,
// //                                 labelText: "Sem"),
// //                             const SizedBox(
// //                               height: 10,
// //                             ),
// //                             TextInputField(
// //                                 controller: _divController,
// //                                 icon: Icons.abc,
// //                                 labelText: "Div"),
// //                             const SizedBox(
// //                               height: 10,
// //                             ),
// //                             TextInputField(
// //                                 controller: _subjectController,
// //                                 icon: Icons.abc,
// //                                 labelText: "Subject"),
// //                             const SizedBox(
// //                               height: 10,
// //                             ),
// //                             DarkButton(onPressed: goBtnProcessor, text: "Go"),
// //                           ],
// //                         ),
// //                       )
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             if (isShowingCharts)
// //               Padding(
// //                 padding: EdgeInsets.all(8.0),
// //                 child: SizedBox(
// //                   height: 200,
// //                   child: LineChart(
// //                     LineChartData(
// //                       lineBarsData: [
// //                         LineChartBarData(
// //                           spots: presentStudentsCounts
// //                               .asMap()
// //                               .entries
// //                               .map((entry) => FlSpot(entry.key.toDouble() + 1,
// //                                   entry.value.toDouble()))
// //                               .toList(),
// //                           isCurved: false,
// //                           color: Colors.blue,
// //                           barWidth: 1,
// //                           isStrokeCapRound: true,
// //                           belowBarData: BarAreaData(show: false),
// //                         ),
// //                       ],
// //                       minX: 1,
// //                       // Start x-axis from 1
// //                       maxX: presentStudentsCounts.length.toDouble(),
// //                       // End x-axis at the length of the list
// //                       minY: 0,
// //                       maxY: presentStudentsCounts.isNotEmpty
// //                           ? presentStudentsCounts
// //                               .reduce((a, b) => a > b ? a : b)
// //                               .toDouble()
// //                           : 1,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             if (isShowingCharts)
// //               SizedBox(
// //                 height: 20,
// //               ),
// //             if (isShowingCharts)
// //               InkWell(
// //                 onTap: closeGraph(),
// //                 child: Text(
// //                   "Close",
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
// //                 ),
// //               )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void seeAttendance() {
// //     setState(() {
// //       btnClicked = true;
// //     });
// //
// //     whichBtnClicked = 1;
// //   }
// //
// //   void seeReport() {
// //     setState(() {
// //       btnClicked = true;
// //     });
// //     whichBtnClicked = 2;
// //   }
// //
// //   void closeContainer() {
// //     setState(() {
// //       btnClicked = false;
// //       isShowingCharts = false;
// //     });
// //     branch = null;
// //     sem = null;
// //     div = null;
// //     subject = null;
// //     whichBtnClicked = -1;
// //   }
// //
// //   void goBtnProcessor() {
// //     if (_branchController.text.trim().toString().isEmpty) {
// //       disp.toast("Enter Branch");
// //     } else if (_semController.text.trim().toString().isEmpty) {
// //       disp.toast("Enter Sem");
// //     } else if (_divController.text.trim().toString().isEmpty) {
// //       disp.toast("Enter Div");
// //     } else if (_subjectController.text.trim().toString().isEmpty) {
// //       disp.toast("Enter Subject");
// //     } else {
// //       branch = _branchController.text.trim().toString();
// //       sem = _semController.text.trim().toString();
// //       div = _divController.text.trim().toString();
// //       subject = _subjectController.text.trim().toString();
// //       if (whichBtnClicked == 1) {
// //         downloadReport();
// //       } else if (whichBtnClicked == 2) {
// //         validatePathAndAccess();
// //       }
// //     }
// //   }
// //
// //   void validatePathAndAccess() async {
// //     String branch = _branchController.text.trim();
// //     String sem = _semController.text.trim();
// //     String div = _divController.text.trim();
// //     String subject = _subjectController.text.trim();
// //
// //     String subjectPath = 'attendance/$branch/$sem/$div/$subject';
// //
// //     try {
// //       QuerySnapshot snapshot =
// //           await FirebaseFirestore.instance.collection(subjectPath).get();
// //
// //       presentStudentsCounts.clear();
// //
// //       snapshot.docs.forEach((doc) {
// //         // Get the value of the presentStudentsCount field from each document
// //         dynamic presentCountData =
// //             (doc.data() as Map<String, dynamic>)['presentStudentsCount'];
// //         if (presentCountData is int) {
// //           presentStudentsCounts.add(presentCountData);
// //         } else if (presentCountData is String) {
// //           // Convert string to integer before adding to presentStudentsCounts
// //           presentStudentsCounts.add(int.parse(presentCountData));
// //         } else {
// //           // Handle if the data is neither int nor string
// //           print(
// //               'Unexpected data type for presentStudentsCount: $presentCountData');
// //         }
// //       });
// //
// //       setState(() {
// //         btnClicked = false;
// //         isShowingCharts = true;
// //       });
// //
// //       // Continue with your logic here
// //     } catch (e) {
// //       print('Error: $e');
// //       // Handle errors if any
// //     }
// //   }
// //
// //   void downloadReport() {}
// //
// //   Future<bool> doesCollectionExist(String collectionPath) async {
// //     try {
// //       QuerySnapshot snapshot = await FirebaseFirestore.instance
// //           .collection(collectionPath)
// //           .limit(1)
// //           .get();
// //       return snapshot.docs.isNotEmpty;
// //     } catch (e) {
// //       print('Error: $e');
// //       return false;
// //     }
// //   }
// //
// //   closeGraph() {
// //     setState(() {
// //       btnClicked = false;
// //       isShowingCharts = false;
// //       branch = null;
// //       sem = null;
// //       div = null;
// //       subject = null;
// //       whichBtnClicked = -1;
// //     });
// //   }
// // }
//
// import 'dart:ui';
//
// import 'package:flutter/src/painting/box_border.dart' as flutter;
// import 'package:attendify/views/widgets/dark_button.dart';
// import 'package:attendify/views/widgets/display_toast.dart';
// import 'package:attendify/views/widgets/text_input_field.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/widgets.dart';
//
// import '../../../constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
//
// class StaffReport extends StatefulWidget {
//   const StaffReport({Key? key}) : super(key: key);
//
//   @override
//   State<StaffReport> createState() => _StaffReportState();
// }
//
// class _StaffReportState extends State<StaffReport> {
//   String? branch, sem, div, subject;
//   bool btnClicked = false, isShowingCharts = false;
//   int whichBtnClicked = -1;
//   DisplayToast disp = DisplayToast();
//   bool go = false;
//   TextEditingController _branchController = TextEditingController();
//   TextEditingController _semController = TextEditingController();
//   TextEditingController _divController = TextEditingController();
//   TextEditingController _subjectController = TextEditingController();
//   List<int> presentStudentsCounts = [];
//
//   //--------------------------------------------------------------------------
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDate = DateTime.now(); // Initialize selected date
//   Map<String, List> mySelectedEvents = {};
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _loading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDataFromFirestore();
//   }
//
//   fetchDataFromFirestore() async {
//     print(">>>>>>>>>>>>>>>>>>$branch");
//     print(">>>>>>>>>>>>>>>>>>$sem");
//     print(">>>>>>>>>>>>>>>>>>$div");
//     print(">>>>>>>>>>>>>>>>>>$subject");
//
//     // QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
//     //     .instance
//     //     .collection('attendance')
//     //     .doc(branch)
//     //     .collection(sem!)
//     //     .doc(div)
//     //     .collection(subject!)
//     //     .get();
//
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
//         .instance
//         .collection('attendance')
//         .doc("cst")
//         .collection("sem1")
//         .doc("divA")
//         .collection("EC")
//         .get();
//
//     for (QueryDocumentSnapshot<Map<String, dynamic>> doc
//         in querySnapshot.docs) {
//       String docId = doc.id;
//       DateTime? date = DateTime.tryParse(docId);
//       if (date != null) {
//         String formattedDate =
//             DateFormat('yyyy-MM-dd').format(date); // Format the date
//         if (mySelectedEvents[formattedDate] == null) {
//           mySelectedEvents[formattedDate] = [];
//         }
//         // Add data to events list
//         mySelectedEvents[formattedDate]!.add({
//           "eventTitle": "Attendance",
//           "date": formattedDate,
//           // Store formatted date
//           "count": doc.data()['count'],
//           // Add count
//           "rollNos": (doc.data()['rollNos'] as Map).keys.toList(),
//           // Add rollNos as list
//         });
//       }
//     }
//
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   //--------------------------------------------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime selectedDate = _selectedDate ?? DateTime.now();
//     List myEventsList = _listOfDayEvents(selectedDate);
//     myEventsList.sort((a, b) => a['time'].compareTo(b['time']));
//     return Material(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 50,
//             ),
//             if (!btnClicked && (!isShowingCharts))
//               DarkButton(onPressed: seeAttendance, text: "See History"),
//             if (!btnClicked && (!isShowingCharts))
//               DarkButton(onPressed: seeReport, text: "See Report"),
//             if (btnClicked && (!isShowingCharts && !go))
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   // height: 420,
//                   width: double.maxFinite,
//                   decoration: BoxDecoration(
//                     border: flutter.Border.all(color: kBlackColor),
//                     borderRadius:
//                         BorderRadius.circular(8), // Define border radius
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Spacer(),
//                           // Push other widgets to the leftmost position
//                           InkWell(
//                             onTap: closeContainer,
//                             child: const Icon(
//                               Icons.close,
//                               // This is the icon for the cross
//                               color: kBlackColor,
//                               size: 30, // Set the size of the icon
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           children: [
//                             TextInputField(
//                                 controller: _branchController,
//                                 icon: Icons.abc,
//                                 labelText: "Branch"),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             TextInputField(
//                                 controller: _semController,
//                                 icon: Icons.abc,
//                                 labelText: "Sem"),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             TextInputField(
//                                 controller: _divController,
//                                 icon: Icons.abc,
//                                 labelText: "Div"),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             TextInputField(
//                                 controller: _subjectController,
//                                 icon: Icons.abc,
//                                 labelText: "Subject"),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             DarkButton(onPressed: goBtnProcessor, text: "Go"),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             if (isShowingCharts)
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: SizedBox(
//                   height: 200,
//                   child: LineChart(
//                     LineChartData(
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: presentStudentsCounts
//                               .asMap()
//                               .entries
//                               .map((entry) => FlSpot(entry.key.toDouble() + 1,
//                                   entry.value.toDouble()))
//                               .toList(),
//                           isCurved: false,
//                           color: Colors.blue,
//                           barWidth: 1,
//                           isStrokeCapRound: true,
//                           belowBarData: BarAreaData(show: false),
//                         ),
//                       ],
//                       minX: 1,
//                       // Start x-axis from 1
//                       maxX: presentStudentsCounts.length.toDouble(),
//                       // End x-axis at the length of the list
//                       minY: 0,
//                       maxY: presentStudentsCounts.isNotEmpty
//                           ? presentStudentsCounts
//                               .reduce((a, b) => a > b ? a : b)
//                               .toDouble()
//                           : 1,
//                     ),
//                   ),
//                 ),
//               ),
//             if (isShowingCharts)
//               SizedBox(
//                 height: 20,
//               ),
//             if (isShowingCharts)
//               InkWell(
//                 onTap: closeGraph(),
//                 child: const Text(
//                   "Close",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//               ),
//             if (go)
//               _loading
//                   ? const Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : Column(
//                       children: [
//                         TableCalendar(
//                           firstDay: DateTime(2024),
//                           lastDay: DateTime(2025),
//                           focusedDay: _focusedDay,
//                           calendarFormat: _calendarFormat,
//                           onDaySelected: (selectedDay, focusedDay) {
//                             if (!isSameDay(_selectedDate!, selectedDay)) {
//                               setState(() {
//                                 _selectedDate = selectedDay;
//                                 _focusedDay = focusedDay;
//                               });
//                             }
//                           },
//                           selectedDayPredicate: (day) {
//                             return isSameDay(_selectedDate!, day);
//                           },
//                           onFormatChanged: (format) {
//                             if (_calendarFormat != format) {
//                               setState(() {
//                                 _calendarFormat = format;
//                               });
//                             }
//                           },
//                           onPageChanged: (focusedDay) {
//                             _focusedDay = focusedDay;
//                           },
//                           eventLoader: _listOfDayEvents,
//                           rowHeight: 60,
//                           daysOfWeekHeight: 30,
//                           headerStyle: const HeaderStyle(
//                               titleTextStyle:
//                                   TextStyle(fontFamily: 'MainFont')),
//                           daysOfWeekStyle: const DaysOfWeekStyle(
//                               weekdayStyle: TextStyle(fontFamily: 'MainFont'),
//                               weekendStyle: TextStyle(fontFamily: 'MainFont')),
//                           calendarStyle: CalendarStyle(
//                             defaultTextStyle:
//                                 const TextStyle(fontFamily: 'MainFont'),
//                             outsideTextStyle:
//                                 const TextStyle(fontFamily: 'MainFont'),
//                             weekNumberTextStyle:
//                                 const TextStyle(fontFamily: 'MainFont'),
//                             weekendTextStyle:
//                                 const TextStyle(fontFamily: 'MainFont'),
//                             tableBorder: TableBorder(
//                               top: const BorderSide(color: Colors.black),
//                               bottom: const BorderSide(color: Colors.black),
//                               left: const BorderSide(color: Colors.black),
//                               right: const BorderSide(color: Colors.black),
//                               horizontalInside:
//                                   const BorderSide(color: Colors.black),
//                               verticalInside:
//                                   const BorderSide(color: Colors.black),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.only(
//                             top: 10,
//                           ),
//                           child: const Text(
//                             "Attendance :",
//                             style: TextStyle(
//                                 fontFamily: "MainFont",
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20),
//                           ),
//                         ),
//                         ...myEventsList.map(
//                           (myEvents) => Card(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   margin:
//                                       const EdgeInsets.only(left: 10, top: 10),
//                                   child: Text(
//                                     '${myEvents['eventTitle']} :',
//                                     style: const TextStyle(
//                                         fontFamily: "MainFont",
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 Container(
//                                   margin: const EdgeInsets.only(
//                                       left: 10, top: 10, bottom: 10),
//                                   child: Text(
//                                     getDate(myEvents['date']),
//                                     style: const TextStyle(
//                                         fontFamily: "MainFont1"),
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Align(
//                                         alignment: Alignment.centerRight,
//                                         child: Container(
//                                           margin: const EdgeInsets.only(
//                                               right: 10, bottom: 10),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "  Student Count : ${myEvents['count']}",
//                                                 style: const TextStyle(
//                                                     fontFamily: "MainFont1"),
//                                               ),
//                                               const SizedBox(height: 5),
//                                               const Text(
//                                                 "  Present Roll numbers :",
//                                                 style: TextStyle(
//                                                     fontFamily: "MainFont1"),
//                                               ),
//                                               const SizedBox(height: 5),
//                                               // Display roll numbers
//                                               Container(
//                                                 margin: const EdgeInsets.only(
//                                                     left: 8),
//                                                 child: Wrap(
//                                                   children: _buildRollNumbers(
//                                                       myEvents['rollNos']),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildRollNumbers(List rollNos) {
//     List<Widget> widgets = [];
//     for (int i = 0; i < rollNos.length; i += 5) {
//       int end = i + 5 < rollNos.length ? i + 5 : rollNos.length;
//       List<Widget> rowWidgets = [];
//       for (int j = i; j < end; j++) {
//         rowWidgets.add(Text("${rollNos[j]}, "));
//       }
//       widgets.add(Row(children: rowWidgets));
//     }
//     return widgets;
//   }
//
//   List _listOfDayEvents(DateTime dateTime) {
//     // Get events for the selected date
//     List events =
//         mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] ?? [];
//
//     return events;
//   }
//
//   String getDate(String date) {
//     DateTime parsedDate = DateTime.parse(date);
//     DateTime currentDate = DateTime.now();
//     if (isSameDay(parsedDate, currentDate)) {
//       return "Today";
//     } else if (isSameDay(parsedDate, currentDate.add(Duration(days: 1)))) {
//       return "Tomorrow";
//     }
//     return "Date : ${date}";
//   }
//
//   bool isSameDay(DateTime date1, DateTime date2) {
//     return date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }
//
//   void seeAttendance() {
//     setState(() {
//       btnClicked = true;
//     });
//
//     whichBtnClicked = 1;
//   }
//
//   void seeReport() {
//     setState(() {
//       btnClicked = true;
//     });
//     whichBtnClicked = 2;
//   }
//
//   void closeContainer() {
//     setState(() {
//       btnClicked = false;
//       isShowingCharts = false;
//     });
//     branch = null;
//     sem = null;
//     div = null;
//     subject = null;
//     whichBtnClicked = -1;
//   }
//
//   void goBtnProcessor() {
//     if (_branchController.text.trim().toString().isEmpty) {
//       disp.toast("Enter Branch");
//     } else if (_semController.text.trim().toString().isEmpty) {
//       disp.toast("Enter Sem");
//     } else if (_divController.text.trim().toString().isEmpty) {
//       disp.toast("Enter Div");
//     } else if (_subjectController.text.trim().toString().isEmpty) {
//       disp.toast("Enter Subject");
//     } else {
//       branch = _branchController.text.trim().toString();
//       sem = _semController.text.trim().toString();
//       div = _divController.text.trim().toString();
//       subject = _subjectController.text.trim().toString();
//       if (whichBtnClicked == 1) {
//         downloadReport();
//       } else if (whichBtnClicked == 2) {
//         validatePathAndAccess();
//       }
//     }
//   }
//
//   void validatePathAndAccess() async {
//     String branch = _branchController.text.trim();
//     String sem = _semController.text.trim();
//     String div = _divController.text.trim();
//     String subject = _subjectController.text.trim();
//
//     String subjectPath = 'attendance/$branch/$sem/$div/$subject';
//
//     try {
//       QuerySnapshot snapshot =
//           await FirebaseFirestore.instance.collection(subjectPath).get();
//
//       presentStudentsCounts.clear();
//
//       snapshot.docs.forEach((doc) {
//         // Get the value of the presentStudentsCount field from each document
//         dynamic presentCountData =
//             (doc.data() as Map<String, dynamic>)['presentStudentsCount'];
//         if (presentCountData is int) {
//           presentStudentsCounts.add(presentCountData);
//         } else if (presentCountData is String) {
//           // Convert string to integer before adding to presentStudentsCounts
//           presentStudentsCounts.add(int.parse(presentCountData));
//         } else {
//           // Handle if the data is neither int nor string
//           print(
//               'Unexpected data type for presentStudentsCount: $presentCountData');
//         }
//       });
//
//       setState(() {
//         btnClicked = false;
//         isShowingCharts = true;
//       });
//
//       // Continue with your logic here
//     } catch (e) {
//       print('Error: $e');
//       // Handle errors if any
//     }
//   }
//
//   void downloadReport() async {
//     // fetchDataFromFirestore();
//
//     setState(() {
//       go = true;
//     });
//   }
//
//   Future<bool> doesCollectionExist(String collectionPath) async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection(collectionPath)
//           .limit(1)
//           .get();
//       return snapshot.docs.isNotEmpty;
//     } catch (e) {
//       print('Error: $e');
//       return false;
//     }
//   }
//
//   closeGraph() {
//     setState(() {
//       btnClicked = false;
//       isShowingCharts = false;
//       branch = null;
//       sem = null;
//       div = null;
//       subject = null;
//       whichBtnClicked = -1;
//     });
//   }
// }

import 'dart:io';

import 'package:flutter/src/painting/box_border.dart' as flutter;
import 'package:attendify/views/widgets/dark_button.dart';
import 'package:attendify/views/widgets/display_toast.dart';
import 'package:attendify/views/widgets/text_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart package
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import '../../../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool go = false;
  TextEditingController _branchController = TextEditingController();
  TextEditingController _semController = TextEditingController();
  TextEditingController _divController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  List<int> presentStudentsCounts = [];

  //--------------------------------------------------------------------------
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now(); // Initialize selected date
  Map<String, List> mySelectedEvents = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchDataFromFirestore();
  // }

  fetchDataFromFirestore() async {
    print(
        '------------------------------------------------------------$branch $sem $div $subject');
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('attendance')
              .doc(branch)
              .collection(sem!)
              .doc(div)
              .collection(subject!)
              .get();
      print(
          '------------------------------------------------------------$branch $sem $div $subject');
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        String docId = doc.id;
        DateTime? date = DateTime.tryParse(docId);
        if (date != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          print(
              '------------------------------------------------------------$formattedDate');
          final rollNosData = doc.data()['rollNos'];
          if (rollNosData != null && rollNosData is Map) {
            if (mySelectedEvents[formattedDate] == null) {
              mySelectedEvents[formattedDate] = [];
            }
            mySelectedEvents[formattedDate]!.add({
              "eventTitle": "Attendance",
              "date": formattedDate,
              "count": doc.data()['count'],
              "rollNos": (rollNosData as Map).keys.toList(),
            });
          } else {
            // Handle the case where 'rollNos' data is null or not of type Map
          }
        }
      }
      setState(() {
        _loading = false;
      });
    } catch (e) {
      print(
          '---------------------------------------------------------------------${e.toString()}');
    }
  }

  //--------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = _selectedDate ?? DateTime.now();
    List myEventsList = _listOfDayEvents(selectedDate);
    myEventsList.sort((a, b) => a['time'].compareTo(b['time']));
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
            if (btnClicked && (!isShowingCharts && !go))
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
              ),
            if (go)
              _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime(2024),
                          lastDay: DateTime(2025),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          onDaySelected: (selectedDay, focusedDay) {
                            if (!isSameDay(_selectedDate!, selectedDay)) {
                              setState(() {
                                _selectedDate = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            }
                          },
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDate!, day);
                          },
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          eventLoader: _listOfDayEvents,
                          rowHeight: 60,
                          daysOfWeekHeight: 30,
                          headerStyle: HeaderStyle(
                              titleTextStyle:
                                  TextStyle(fontFamily: 'MainFont')),
                          daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(fontFamily: 'MainFont'),
                              weekendStyle: TextStyle(fontFamily: 'MainFont')),
                          calendarStyle: CalendarStyle(
                              defaultTextStyle:
                                  TextStyle(fontFamily: 'MainFont'),
                              outsideTextStyle:
                                  TextStyle(fontFamily: 'MainFont'),
                              weekNumberTextStyle:
                                  TextStyle(fontFamily: 'MainFont'),
                              weekendTextStyle:
                                  TextStyle(fontFamily: 'MainFont'),
                              tableBorder: TableBorder(
                                  top: BorderSide(color: Colors.black),
                                  bottom: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                  horizontalInside:
                                      BorderSide(color: Colors.black),
                                  verticalInside:
                                      BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Text(
                            "Events :",
                            style: TextStyle(fontFamily: "MainFont"),
                          ),
                        ),
                        ...myEventsList.map(
                          (myEvents) => InkWell(
                            onTap: () {
                              // Handle tap on event
                              print("Count: ${myEvents['count']}");
                              print("Roll Nos: ${myEvents['rollNos']}");
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '${myEvents['eventTitle']} :',
                                      style: TextStyle(
                                          fontFamily: "MainFont",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10, top: 10, bottom: 10),
                                    child: Text(
                                      getDate(myEvents['date']),
                                      style: TextStyle(fontFamily: "MainFont1"),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: 10, bottom: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "  Student Count : ${myEvents['count']}",
                                                  style: TextStyle(
                                                      fontFamily: "MainFont1"),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "  Present Roll numbers :",
                                                  style: TextStyle(
                                                      fontFamily: "MainFont1"),
                                                ),
                                                SizedBox(height: 5),
                                                // Display roll numbers
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 8),
                                                  child: Wrap(
                                                    children: _buildRollNumbers(
                                                        myEvents['rollNos']),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRollNumbers(List rollNos) {
    List<Widget> widgets = [];
    for (int i = 0; i < rollNos.length; i += 5) {
      int end = i + 5 < rollNos.length ? i + 5 : rollNos.length;
      List<Widget> rowWidgets = [];
      for (int j = i; j < end; j++) {
        rowWidgets.add(Text("${rollNos[j]}, "));
      }
      widgets.add(Row(children: rowWidgets));
    }
    return widgets;
  }

  List _listOfDayEvents(DateTime dateTime) {
    // Get events for the selected date
    List events =
        mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] ?? [];

    return events;
  }

  String getDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    DateTime currentDate = DateTime.now();
    if (isSameDay(parsedDate, currentDate)) {
      return "Today";
    } else if (isSameDay(parsedDate, currentDate.add(Duration(days: 1)))) {
      return "Tomorrow";
    }
    return "Date : ${date}";
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
    setState(() {
      go = true;
      fetchDataFromFirestore();
    });
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

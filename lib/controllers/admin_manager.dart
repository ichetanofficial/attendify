// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../constants.dart';
// import '../views/widgets/display_toast.dart';
//
// class AdminManager {
//   late int branchesCount;
//   List<String> branches = [];
//   TextEditingController branchController = TextEditingController();
//   DisplayToast disp = DisplayToast();
//   String selectedBranch = "";
//
//   managebranches(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: Container(
//                 width: double.infinity,
//                 height: 500,
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Manage branches",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.close),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     const Text(
//                       "Add New branch:",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: branchController,
//                       decoration: const InputDecoration(
//                         hintText: "Enter branch Name",
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () async {
//                         await addbranch();
//                         Navigator.of(context).pop();
//                       },
//                       child: Text("Add"),
//                     ),
//                     SizedBox(height: 20),
//                     const Text(
//                       "Existing branches:",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: branches.length,
//                         physics: AlwaysScrollableScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           final branch = branches[index];
//                           return Row(
//                             children: [
//                               Expanded(
//                                 child: Text("- $branch"),
//                               ),
//                               GestureDetector(
//                                 onTap: () async {
//                                   // Implement logic to delete the branch
//                                   bool? shouldDelete =
//                                       await confirmDelete(context, branch);
//
//                                   if (shouldDelete == null)
//                                     shouldDelete = false;
//
//                                   if (shouldDelete) {
//                                     await deleteBranch(branch);
//                                     setState(() {
//                                       branches.removeAt(index);
//                                     });
//                                   }
//                                 },
//                                 child: Icon(Icons.clear),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<bool?> confirmDelete(BuildContext context, String branch) async {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm Delete"),
//           content: Text("Are you sure you want to delete $branch?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: Text("Delete"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> deleteBranch(String branchToDelete) async {
//     final staffRef = firestore.collection("Branches").doc("branch");
//
//     for (int i = 1; i <= branchesCount; i++) {
//       final updates = <String, dynamic>{
//         "branch$i": FieldValue.delete(),
//       };
//       staffRef.update(updates);
//     }
//
//     branches.remove(branchToDelete);
//     int length = branches.length;
//
//     for (int i = 0; i < length; i++) {
//       final updates = <String, dynamic>{
//         "branch${i + 1}": branches[i],
//       };
//       staffRef.update(updates);
//     }
//     int tempCount = length;
//     staffRef.update({"count": tempCount});
//
//     fetchbranchesCountAndList();
//   }
//
//   Future<void> addbranch() async {
//     final staffRef = FirebaseFirestore.instance.collection("staff").doc(myUid);
//
//     int tempCount = branchesCount + 1;
//
//     staffRef.update({
//       "branch$tempCount": branchController.text.trim().toString(),
//       "count": tempCount,
//     });
//
//     await fetchbranchesCountAndList();
//     branchController.clear();
//   }
//
//   confirmProceed(BuildContext context, branch) {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm Proceed"),
//           content: Text("Are you sure with $branch?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: Text("Proceed"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> fetchbranchesCountAndList() async {
//     final staffRef = FirebaseFirestore.instance.collection("staff").doc(myUid);
//     staffRef.get().then(
//       (DocumentSnapshot doc) {
//         if (doc.exists) {
//           final data = doc.data() as Map<String, dynamic>;
//           branchesCount = data["count"];
//
//           branches = [];
//           for (int i = 1; i <= branchesCount; i++) {
//             branches.add(data['branch$i']);
//           }
//         } else {
//           staffRef.set({
//             "count": 0,
//           });
//
//           branchesCount = 0;
//           branches = [];
//         }
//       },
//       onError: (e) => print("Error getting document: $e"),
//     );
//   }
// }

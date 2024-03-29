import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class StudentProfile {
  List<String> branchNames = [];
  List<String> semNames = [];
  List<String> divNames = [];
  List<String> subjects = [];

  String selectedBranch = "Select Branch";
  String selectedSem = "Select Sem";
  String selectedDiv = "Select Div";
  int subjectCount = 0;
  int showButtons = 0;
  String myUid = "";

  Future<String> initialChecks() {
    DatabaseReference publicRef = FirebaseDatabase.instance
        .ref('public/admin/allowStudentsToEditStructure');
    Completer<String> completer = Completer<String>();
    publicRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      completer.complete(data.toString());
    });
    return completer.future;
  }

  Future<bool?> confirmProceed(BuildContext context, String branch) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Proceed"),
          content: Text("Are you sure with $branch ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Proceed"),
            ),
          ],
        );
      },
    );
  }

 }

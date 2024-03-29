import 'package:attendify/constants.dart';
import 'package:attendify/views/screens/home/staff_home_screen.dart';
import 'package:attendify/views/screens/home/student_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_home_screen.dart';

class HomeTravellerScreen extends StatefulWidget {
  HomeTravellerScreen({super.key});

  @override
  State<HomeTravellerScreen> createState() => _HomeTravellerScreenState();
}

class _HomeTravellerScreenState extends State<HomeTravellerScreen> {
  @override
  void initState() {
    super.initState();
    whoIsFetcher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          //FiveStar();
        ],
      ),
    );
  }

  Future<void> whoIsFetcher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    firestore.collection("users").doc(uid).get().then((doc) {
      if (doc.exists) {
        prefs.setString("whoIs", doc.data()?["whoIs"]);
        if (doc.data()?["whoIs"] == "student") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => StudentHomeScreen()));
        } else if (doc.data()?["whoIs"] == "staff") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => StaffHomeScreen()));
        } else if (doc.data()?["whoIs"] == "admin") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AdminHomeScreen()));
        }
      } else {
        print("Something Went Wrong");
      }
    }).catchError((error) {
      print("Error retrieving document: $error");
    });
  }
}

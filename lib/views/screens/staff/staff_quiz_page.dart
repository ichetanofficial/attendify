import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaffQuiz extends StatefulWidget {
  const StaffQuiz({super.key});

  @override
  State<StaffQuiz> createState() => _StaffQuizState();
}

class _StaffQuizState extends State<StaffQuiz> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Text("Application is in Development", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        ],
      ),
    );
  }
}

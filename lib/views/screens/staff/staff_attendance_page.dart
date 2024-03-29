import 'package:attendify/controllers/adder_remover.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/dark_button.dart';
import 'main_attendace_screen.dart';

class StaffAttendance extends StatefulWidget {
  const StaffAttendance({Key? key}) : super(key: key);

  @override
  State<StaffAttendance> createState() => _StaffAttendanceState();
}

class _StaffAttendanceState extends State<StaffAttendance> {
  AdderRemover adderRemover = AdderRemover();

  @override
  void initState() {
    super.initState();
    adderRemover.fetchCachedSubjectCountAndList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          DarkButton(
            onPressed: () => takeAttendance(context),
            text: "Take Attendance",
          ),
          DarkButton(
            onPressed: () => manageSubjects(context),
            text: "Manage Subjects",
          )
        ],
      ),
    );
  }

  takeAttendance(BuildContext context) {
    String searchText = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                width: double.infinity,
                height: 500,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Take Attendance",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText =
                              value.toLowerCase(); // Update search text
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: adderRemover.subjects.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final subject = adderRemover.subjects[index];
                          // Filter subjects based on search text
                          if (subject.toLowerCase().contains(searchText)) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text("- $subject"),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    bool? shouldProceed = await adderRemover
                                        .confirmProceed(context, subject);
                                    if (shouldProceed == null)
                                      shouldProceed = false;

                                    if (shouldProceed) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MainAttendanceScrren(subject),
                                        ),
                                      );
                                    }
                                  },
                                  child: Icon(Icons.check),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  manageSubjects(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                width: double.infinity,
                height: 500,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Manage Subjects",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    const Text(
                      "Add New Subject:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: adderRemover.subjectController,
                      decoration: const InputDecoration(
                        hintText: "Enter Subject Name",
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await adderRemover.addSubject();
                        Navigator.of(context).pop();
                      },
                      child: Text("Add"),
                    ),
                    SizedBox(height: 20),
                    const Text(
                      "Existing Subjects:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: adderRemover.subjects.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final subject = adderRemover.subjects[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Text("- $subject"),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool? shouldDelete = await adderRemover
                                      .confirmDelete(context, subject);

                                  if (shouldDelete == null)
                                    shouldDelete = false;

                                  if (shouldDelete) {
                                    adderRemover.deleteSubject(subject);
                                    Navigator.of(context).pop();
                                    setState(() {
                                      adderRemover.subjects.removeAt(index);
                                    });
                                  }
                                },
                                child: Icon(Icons.clear),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

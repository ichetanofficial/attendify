import 'package:attendify/controllers/student_profile.dart';
import 'package:attendify/views/widgets/dark_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  late SharedPreferences prefs;
  StudentProfile stud = StudentProfile();
  int navStatus = -1;

  @override
  void initState() {
    super.initState();
    initialPerformer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: (navStatus == 0)
          ? Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                Text(
                  "Branch : ${stud.selectedBranch}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Sem : ${stud.selectedSem}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Div : ${stud.selectedDiv}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(),
              ],
            )
          : Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                Text("Branch : ${stud.selectedBranch}"),
                (stud.showButtons > 0)
                    ? Text("Sem : ${stud.selectedSem}")
                    : const SizedBox(),
                (stud.showButtons > 1)
                    ? Text("Div : ${stud.selectedDiv}")
                    : const SizedBox(),
                DarkButton(
                    onPressed: () => selectBranch(), text: "Select Branch"),
                (stud.showButtons > 0)
                    ? DarkButton(
                        onPressed: () => selectSem(), text: "Select Sem")
                    : const SizedBox(),
                (stud.showButtons > 1)
                    ? DarkButton(
                        onPressed: () => selectDivision(), text: "Select Div")
                    : const SizedBox(),
                (stud.showButtons > 2)
                    ? DarkButton(onPressed: submitProcessor, text: "Submit")
                    : const SizedBox(),
              ],
            ),
    );
  }

  Future<void> fetchBranches() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection("admin")
          .doc("branches")
          .collection("branch")
          .get();

      List<String> names = [];
      for (var doc in querySnapshot.docs) {
        names.add(doc.id);
      }

      stud.branchNames = names;
    } catch (e) {
      //fiveStar()
    }
  }

  Future<void> fetchSems(String branch) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection("admin")
          .doc("branches")
          .collection("branch")
          .doc(branch)
          .collection(branch)
          .get();

      List<String> names = [];
      for (var doc in querySnapshot.docs) {
        names.add(doc.id);
      }
      stud.semNames = names;
    } catch (e) {
      print("Error fetching semesters: $e");
    }
  }

  Future<void> fetchDiv(String sem) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("admin")
          .doc("branches")
          .collection("branch")
          .doc(stud.selectedBranch)
          .collection(stud.selectedBranch)
          .doc(sem)
          .collection(sem)
          .get();

      List<String> names = [];
      for (var doc in querySnapshot.docs) {
        names.add(doc.id);
      }

      stud.divNames = names;
    } catch (e) {}
  }

  selectBranch() {
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select Branch",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText =
                              value.toLowerCase(); // Update search text
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: stud.branchNames.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final branch = stud.branchNames[index];
                          // Filter subjects based on search text
                          if (branch.toLowerCase().contains(searchText)) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text("- $branch"),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    bool? shouldProceed = await stud
                                        .confirmProceed(context, branch);
                                    shouldProceed ??= false;

                                    if (shouldProceed) {
                                      Navigator.pop(context);
                                      updateSelectedBranch(branch);
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

  selectSem() {
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select Branch",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText =
                              value.toLowerCase(); // Update search text
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: stud.semNames.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final sem = stud.semNames[index];
                          // Filter subjects based on search text
                          if (sem.toLowerCase().contains(searchText)) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text("- $sem"),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    bool? shouldProceed =
                                        await stud.confirmProceed(context, sem);
                                    shouldProceed ??= false;

                                    if (shouldProceed) {
                                      Navigator.pop(context);
                                      updateSelectedSem(sem);
                                    }
                                  },
                                  child: const Icon(Icons.check),
                                ),
                              ],
                            );
                          } else {
                            return Container(); // Return an empty container if subject does not match search text
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

  selectDivision() {
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select Branch",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText =
                              value.toLowerCase(); // Update search text
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: stud.divNames.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final div = stud.divNames[index];
                          // Filter subjects based on search text
                          if (div.toLowerCase().contains(searchText)) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Text("- $div"),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    bool? shouldProceed =
                                        await stud.confirmProceed(context, div);
                                    shouldProceed ??= false;

                                    if (shouldProceed) {
                                      Navigator.pop(context);
                                      updateSelectedDiv(div);
                                    }
                                  },
                                  child: const Icon(Icons.check),
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

  // Future<void> initialPerformer() async {
  //   prefs = await SharedPreferences.getInstance();
  //   stud.myUid = prefs.getString('uid')!;
  //   int? status = prefs.getInt("status");
  //
  //   String chk = await stud.initialChecks();
  //
  //   if (chk == "1") {
  //     if (status == 0) {
  //       setState(() {
  //         stud.selectedBranch = prefs.getString("branch")!;
  //         stud.selectedSem = prefs.getString("sem")!;
  //         stud.selectedDiv = prefs.getString("div")!;
  //         navStatus = 0;
  //       });
  //     } else {
  //       final studRef = firestore.collection("students").doc(stud.myUid);
  //
  //       studRef.get().then((docSnapshot) {
  //         if (docSnapshot.exists) {
  //           Map<String, dynamic>? data = docSnapshot.data();
  //           stud.subjectCount = data?['count'];
  //
  //           prefs.setInt("count", stud.subjectCount);
  //
  //           for (int i = 1; i <= stud.subjectCount; i++) {
  //             String tempSubject = data?['subject$i'];
  //             stud.subjects.add(tempSubject);
  //
  //             final studRef = firestore.collection("students").doc(stud.myUid);
  //             studRef.update({"subject$i": tempSubject});
  //
  //             prefs.setString("subject$i", tempSubject);
  //           }
  //
  //           setState(() {
  //             stud.showButtons = 3;
  //             stud.selectedBranch = prefs.getString("branch")!;
  //             stud.selectedSem = prefs.getString("sem")!;
  //             stud.selectedDiv = prefs.getString("div")!;
  //           });
  //         } else {
  //           fetchBranches();
  //         }
  //       });
  //     }
  //   } else {
  //     setState(() {
  //       stud.showButtons = 3;
  //     });
  //   }
  // }

  Future<void> initialPerformer() async {
    prefs = await SharedPreferences.getInstance();
    stud.myUid = prefs.getString('uid')!;
    int? status = prefs.getInt("status");

    String chk = await stud.initialChecks();

    if (chk == "1") {
      if (status == 0) {
        setState(() {
          stud.selectedBranch = prefs.getString("branch")!;
          stud.selectedSem = prefs.getString("sem")!;
          stud.selectedDiv = prefs.getString("div")!;
          navStatus = 0;
        });
      } else {
        final studRef = firestore.collection("students").doc(stud.myUid);

        studRef.get().then((docSnapshot) {
          if (docSnapshot.exists) {
            Map<String, dynamic>? data = docSnapshot.data();
            stud.selectedBranch = data?['branch'];
            stud.selectedDiv = data?['div'];
            stud.selectedSem = data?['sem'];

            prefs.setString("branch", stud.selectedBranch);
            prefs.setString("sem", stud.selectedSem);
            prefs.setString("div", stud.selectedDiv);

            final subRef = firestore
                .collection("admin")
                .doc("branches")
                .collection("branch")
                .doc(stud.selectedBranch)
                .collection(stud.selectedBranch)
                .doc(stud.selectedSem)
                .collection(stud.selectedSem)
                .doc(stud.selectedDiv);
            subRef.get().then((docSnapshot) {
              Map<String, dynamic>? data = docSnapshot.data();
              int count = data!["count"];
              prefs.setInt("count", count);

              for (int i = 1; i <= count; i++) {
                prefs.setString("subject$i", data!["subject$i"]);
              }
              prefs.setInt("status", 0);
            });

            setState(() {
              stud.showButtons = 3;
              stud.selectedBranch = prefs.getString("branch")!;
              stud.selectedSem = prefs.getString("sem")!;
              stud.selectedDiv = prefs.getString("div")!;
              status = 0;
            });
          } else {
            fetchBranches();
          }
        });
      }
    } else {
      setState(() {
        stud.showButtons = 3;
      });
    }
  }

  void updateSelectedBranch(String branch) {
    setState(() {
      stud.showButtons = 1;
      stud.selectedBranch = branch;
    });
    fetchSems(branch);
  }

  void updateSelectedSem(String sem) {
    setState(() {
      stud.showButtons = 2;
      stud.selectedSem = sem;
    });
    fetchDiv(sem);
  }

  void updateSelectedDiv(String div) {
    setState(() {
      stud.showButtons = 3;
      stud.selectedDiv = div;
    });
  }

  // void submitProcessor() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     stud.myUid = prefs.getString("uid")!;
  //
  //     final subjectsRef = FirebaseFirestore.instance
  //         .collection("admin")
  //         .doc("branches")
  //         .collection("branch")
  //         .doc(stud.selectedBranch)
  //         .collection(stud.selectedBranch)
  //         .doc(stud.selectedSem)
  //         .collection(stud.selectedSem)
  //         .doc(stud.selectedDiv);
  //
  //     DocumentSnapshot doc = await subjectsRef.get();
  //     if (doc.exists) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       stud.subjectCount = data["count"];
  //       prefs.setInt("count", stud.subjectCount);
  //       prefs.setString("branch", stud.selectedBranch);
  //       prefs.setString("sem", stud.selectedSem);
  //       prefs.setString("div", stud.selectedDiv);
  //
  //       stud.subjects = [];
  //       setState(() {
  //         prefs.setInt("status", 0);
  //         navStatus = 0;
  //       });
  //
  //       for (int i = 1; i <= stud.subjectCount; i++) {
  //         String tempSubject = data['subject$i'];
  //         stud.subjects.add(tempSubject);
  //         prefs.setString("subject$i", tempSubject);
  //       }
  //     } else {
  //       throw Exception("Document does not exist");
  //     }
  //
  //     final studRef = firestore.collection("students").doc(stud.myUid);
  //
  //     await studRef.set({
  //       'branch': stud.selectedBranch,
  //       'sem': stud.selectedSem,
  //       "div": stud.selectedDiv,
  //       'count': stud.subjectCount,
  //     });
  //
  //     for (int i = 1; i <= stud.subjectCount; i++) {
  //       String temp = prefs.getString("subject$i")!;
  //       await studRef.update({
  //         "subject$i": temp,
  //       });
  //     }
  //   } catch (e) {
  //     print("Error in submitProcessor: $e");
  //   }
  // }

  void submitProcessor() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      stud.myUid = prefs.getString("uid")!;

      final subjectsRef = FirebaseFirestore.instance
          .collection("admin")
          .doc("branches")
          .collection("branch")
          .doc(stud.selectedBranch)
          .collection(stud.selectedBranch)
          .doc(stud.selectedSem)
          .collection(stud.selectedSem)
          .doc(stud.selectedDiv);

      DocumentSnapshot doc = await subjectsRef.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        stud.subjectCount = data["count"];
        prefs.setInt("count", stud.subjectCount);
        prefs.setString("branch", stud.selectedBranch);
        prefs.setString("sem", stud.selectedSem);
        prefs.setString("div", stud.selectedDiv);

        stud.subjects = [];
        setState(() {
          prefs.setInt("status", 0);
          navStatus = 0;
        });

        for (int i = 1; i <= stud.subjectCount; i++) {
          String tempSubject = data['subject$i'];
          stud.subjects.add(tempSubject);
          prefs.setString("subject$i", tempSubject);
        }
      } else {
        throw Exception("Document does not exist");
      }

      final studRef = firestore.collection("students").doc(stud.myUid);

      await studRef.set({
        'branch': stud.selectedBranch,
        'sem': stud.selectedSem,
        "div": stud.selectedDiv,
      });
    } catch (e) {
      print("Error in submitProcessor: $e");
    }
  }
}

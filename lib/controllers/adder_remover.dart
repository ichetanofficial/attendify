import 'package:attendify/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/widgets/display_toast.dart';

class AdderRemover {
  late int subjectCount;
  List<String> subjects = [];
  TextEditingController subjectController = TextEditingController();
  late String myUid;
  DisplayToast disp = DisplayToast();
  String selectedSubject = "";

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
                      controller: subjectController,
                      decoration: const InputDecoration(
                        hintText: "Enter Subject Name",
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await addSubject();
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
                        itemCount: subjects.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Text("- $subject"),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // Implement logic to delete the subject
                                  bool? shouldDelete =
                                      await confirmDelete(context, subject);

                                  if (shouldDelete == null)
                                    shouldDelete = false;

                                  if (shouldDelete) {
                                    await deleteSubject(subject);
                                    setState(() {
                                      subjects.removeAt(index);
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

  Future<bool?> confirmDelete(BuildContext context, String subject) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete $subject?"),
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
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteSubject(String subjectToDelete) async {
    final staffRef = firestore.collection("staff").doc(myUid);

    for (int i = 1; i <= subjectCount; i++) {
      final updates = <String, dynamic>{
        "subject$i": FieldValue.delete(),
      };
      staffRef.update(updates);
    }

    subjects.remove(subjectToDelete);
    int length = subjects.length;

    for (int i = 0; i < length; i++) {
      final updates = <String, dynamic>{
        "subject${i + 1}": subjects[i],
      };
      staffRef.update(updates);
    }
    int tempCount = length;
    staffRef.update({"count": tempCount});

    fetchSubjectCountAndList();
  }

  Future<void> addSubject() async {
    final subjectToAdd = subjectController.text.trim().toString();
    final staffRef = FirebaseFirestore.instance.collection("staff").doc(myUid);

    bool subjectExists = await doesSubjectExist(subjectToAdd);
    if (subjectExists) {
      int tempCount = subjectCount + 1;

      staffRef.update({
        "subject$tempCount": subjectToAdd,
        "count": tempCount,
      });

      await fetchSubjectCountAndList();
      subjectController.clear();
    } else {
      disp.toast("Subject Not Recognized");
      return;
    }
  }

  Future<bool> doesSubjectExist(String subject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final branchCollectionRef = FirebaseFirestore.instance
        .collection("admin")
        .doc("branches")
        .collection("branch");

    QuerySnapshot branchSnapshots = await branchCollectionRef.get();
    for (DocumentSnapshot branchDoc in branchSnapshots.docs) {
      final semCollectionRef = branchDoc.reference.collection(branchDoc.id);
      QuerySnapshot semSnapshots = await semCollectionRef.get();

      for (DocumentSnapshot semDoc in semSnapshots.docs) {
        final divCollectionRef = semDoc.reference.collection(semDoc.id);
        QuerySnapshot divSnapshots = await divCollectionRef.get();

        for (DocumentSnapshot divDoc in divSnapshots.docs) {
          Map<String, dynamic> data = divDoc.data() as Map<String, dynamic>;
          for (String key in data.keys) {
            if (data[key] == subject) {
              // prefs.setString(key, value)
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  confirmProceed(BuildContext context, subject) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Proceed"),
          content: Text("Are you sure with $subject?"),
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

  // Future<void> fetchSubjectCountAndList() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   myUid = prefs.getString('uid')!;
  //
  //   final staffRef = FirebaseFirestore.instance.collection("staff").doc(myUid);
  //   staffRef.get().then(
  //     (DocumentSnapshot doc) {
  //       if (doc.exists) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         subjectCount = data["count"];
  //
  //         subjects = [];
  //         for (int i = 1; i <= subjectCount; i++) {
  //           subjects.add(data['subject$i']);
  //         }
  //       } else {
  //         staffRef.set({
  //           "count": 0,
  //         });
  //
  //         subjectCount = 0;
  //         subjects = [];
  //       }
  //     },
  //     onError: (e) => print("Error getting document: $e"),
  //   );
  // }

  Future<void> fetchCachedSubjectCountAndList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myUid = prefs.getString('uid')!;

    // Check if subject count and list are already cached
    if (prefs.containsKey('subjectCount') && prefs.containsKey('subjects')) {
      subjectCount = prefs.getInt('subjectCount')!;
      subjects = prefs.getStringList('subjects')!;
    } else {
      fetchSubjectCountAndList(); // Fetch from Firebase if not cached
    }
  }

  Future<void> fetchSubjectCountAndList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myUid = prefs.getString('uid')!;

    final staffRef = FirebaseFirestore.instance.collection("staff").doc(myUid);
    staffRef.get().then(
      (DocumentSnapshot doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          subjectCount = data["count"];

          subjects = [];
          for (int i = 1; i <= subjectCount; i++) {
            subjects.add(data['subject$i']);
          }

          // Cache subject count and list
          prefs.setInt('subjectCount', subjectCount);
          prefs.setStringList('subjects', subjects);
        } else {
          staffRef.set({
            "count": 0,
          });

          subjectCount = 0;
          subjects = [];
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
}

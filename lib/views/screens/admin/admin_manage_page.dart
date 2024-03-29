import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/dark_button.dart';

class AdminManagePage extends StatefulWidget {
  const AdminManagePage({Key? key}) : super(key: key);

  @override
  State<AdminManagePage> createState() => _AdminManagePageState();
}

class _AdminManagePageState extends State<AdminManagePage> {
  List<String> branches = [];
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
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
            onPressed: () => manageBranches(context),
            text: "CC",
          ),
          DarkButton(
            onPressed: () => manageBranches(context),
            text: "Manage Subjects",
          )
        ],
      ),
    );
  }

  manageBranches(BuildContext context) async {
    QuerySnapshot branchesSnapshot = await firestore
        .collection('admin')
        .doc('branches')
        .collection('branch')
        .get();

    List<String> branchNames =
    branchesSnapshot.docs.map((doc) => doc.id).toList();

    String selectedBranch = branchNames.isNotEmpty ? branchNames.first : '';
    String selectedCollection = '';

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
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Manage Branches",
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
                      "Select Branch:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedBranch,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBranch = newValue!;
                        });
                        // Automatically confirm selection
                        // Handle other actions here if needed
                        // Example: Load collections for selected branch
                      },
                      items: branchNames.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    const Text(
                      "Select Collection:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Replace with your logic to load collections for the selected branch
                    DropdownButton<String>(
                      value: selectedCollection,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCollection = newValue!;
                        });
                      },
                      items: _getCollectionsForBranch(selectedBranch)
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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

// Replace this with your logic to load collections for the selected branch
  List<String> _getCollectionsForBranch(String selectedBranch) {
    // Example implementation:
    // Fetch collections for the selected branch from Firestore
    // Return a list of collection names
    // Modify this function according to your Firestore structure and data retrieval logic
    return ['Collection1', 'Collection2', 'Collection3'];
  }


}

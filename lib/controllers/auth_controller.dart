import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/model_user.dart';

class AuthController {
  Future<String> registerUser(String name, String username, String email,
      String password, BuildContext context) async {
    try {
      UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid", cred.user!.uid);

      await firestore.collection('users').doc(cred.user!.uid).set(ModelUser(
              username: username,
              name: name,
              email: email,
              password: password,
              uid: cred.user!.uid)
          .toJson());

      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return "Weak Password";
      } else if (e.code == "email-already-in-use") {
        return "email-already-in-use";
      }
    }

    return "Something went wrong";
  }

  Future<String> signinUser(
      String email, String password, BuildContext context) async {
    try {
      UserCredential cred = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid", (cred.user!.uid).toString());

      var db = firestore.collection("users").doc((cred.user!.uid).toString());
      db.get().then(
            (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
           prefs.setString("username", data["username"].toString());
        },
        onError: (e) => print("Error getting document: $e"),
      );

      return "Success"; // Return success explicitly
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "Email Not Registered";
      } else if (e.code == "wrong-password") {
        return "Wrong Password";
      }else{
        return "Wrong";
      }
    }
  }
}

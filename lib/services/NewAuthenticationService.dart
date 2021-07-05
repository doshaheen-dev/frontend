import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  //GOOGLE SIGN IN
  static Future<User> signInWithGoogle({BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        // print("Successful $user ");
      } on FirebaseAuthException catch (e) {
        print(e.message);
        print(e.code);

        if (e.code == 'account-exists-with-different-credential') {
          print("Error1 ${e.message} ");
        } else if (e.code == 'invalid-credential') {
          print("Error2 ${e.message} ");
          print(e.credential);
        }
      } catch (e) {
        print(e.toString());
        print("Catch ${e.toString()} ");
        // handle the error here
      }
    }
    return user;
  }

  // APPLE SIGN IN

  static Future<void> signOut() async {
    print("logged out");
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}

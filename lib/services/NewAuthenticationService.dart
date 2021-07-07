import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Authentication {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  Authentication(this.firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => firebaseAuth.idTokenChanges();

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

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // APPLE SIGN IN
  // ignore: missing_return
  Future<User> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult =
          await firebaseAuth.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      final userEmail = '${appleCredential.email}';
      print("Name: $displayName");
      print("Email: $userEmail");

      final prefs = await SharedPreferences.getInstance();
      if (displayName != null) {
        prefs.setString("displayName", displayName);
      }
      if (userEmail != null) {
        prefs.setString("userEmail", userEmail);
      }

      final User firebaseUser = authResult.user;
      await firebaseUser.updateProfile(displayName: displayName);
      await firebaseUser.updateEmail(userEmail);

      return firebaseUser;
    } catch (exception) {
      print(exception);
    }
  }

  // Apple sign for Android
  Future<void> appleAuthenticationAndroid() async {
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'com.doshaheen.portfoliomanagementservice',
        redirectUri: Uri.parse(''),
      ),
    );
    // 'intent://callback?${name}#Intent;package=com.doshaheen.portfoliomanagement;scheme=signinwithapple;end',

    // 'https://portfoliomanagement-7d9f3.firebaseapp.com/__/auth/handler',

    final oAuthCredential = OAuthProvider('apple.com').credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );

// Use the OAuthCredential to sign in to Firebase.
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(oAuthCredential);

    print("Apple Android:- ${userCredential}");
  }

  static Future<void> signOut() async {
    print("logged out");
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}

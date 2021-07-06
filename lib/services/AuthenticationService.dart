// import 'dart:convert';
// import 'dart:math';
// import 'dart:async';

// import 'package:crypto/crypto.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// // import 'package:provider/provider.dart';
// // import 'package:flutter/material.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthenticationService {
//   final FirebaseAuth firebaseAuth;
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   AuthenticationService(this.firebaseAuth);

//   /// Changed to idTokenChanges as it updates depending on more cases.
//   Stream<User> get authStateChanges => firebaseAuth.idTokenChanges();

//   /// Firebase Email/password sign-in
//   Future<String> signIn({String email, String password}) async {
//     try {
//       await firebaseAuth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return "Signed in";
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     }
//   }

//   Future<dynamic> signUpWithEmailAndPassword(
//       {String email, String password}) async {
//     try {
//       final result = await firebaseAuth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       return result;
//     } on FirebaseAuthException catch (e) {
//       return e.message;
//     }
//   }

//   /// Firebase Google sign-in
//   Future<String> signInWithGoogle() async {
//     try {
//       print("google sign in service 1");
//       final GoogleSignInAccount googleSignInAccount =
//           await googleSignIn.signIn();
//       print("google sign in service 2");
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;
//       print("google sign in service 3");
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//       print("google sign in service 4");
//       final googleCredential =
//           await firebaseAuth.signInWithCredential(credential);
//       print("google sign in userinfo: ${googleCredential.additionalUserInfo}");
//       return "Signed in";
//     } catch (e) {
//       return e.message;
//     }
//   }

//   /// Generates a cryptographically secure random nonce, to be included in a
//   /// credential request.
//   String generateNonce([int length = 32]) {
//     final charset =
//         '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//     final random = Random.secure();
//     return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//         .join();
//   }

//   /// Returns the sha256 hash of [input] in hex notation.
//   String sha256ofString(String input) {
//     final bytes = utf8.encode(input);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }

//   // ignore: missing_return
//   Future<User> signInWithApple() async {
//     // To prevent replay attacks with the credential returned from Apple, we
//     // include a nonce in the credential request. When signing in in with
//     // Firebase, the nonce in the id token returned by Apple, is expected to
//     // match the sha256 hash of `rawNonce`.
//     final rawNonce = generateNonce();
//     final nonce = sha256ofString(rawNonce);

//     try {
//       // Request credential for the currently signed in Apple account.
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//         nonce: nonce,
//       );

//       // Create an `OAuthCredential` from the credential returned by Apple.
//       final oauthCredential = OAuthProvider("apple.com").credential(
//         idToken: appleCredential.identityToken,
//         rawNonce: rawNonce,
//       );
//       // Sign in the user with Firebase. If the nonce we generated earlier does
//       // not match the nonce in `appleCredential.identityToken`, sign in will fail.
//       final authResult =
//           await firebaseAuth.signInWithCredential(oauthCredential);

//       final displayName =
//           '${appleCredential.givenName} ${appleCredential.familyName}';
//       final userEmail = '${appleCredential.email}';
//       print("Name: $displayName");
//       print("Email: $userEmail");

//       final prefs = await SharedPreferences.getInstance();
//       if (displayName != null) {
//         prefs.setString("displayName", displayName);
//       }
//       if (userEmail != null) {
//         prefs.setString("userEmail", userEmail);
//       }

//       final User firebaseUser = authResult.user;
//       await firebaseUser.updateProfile(displayName: displayName);
//       await firebaseUser.updateEmail(userEmail);

//       return firebaseUser;
//     } catch (exception) {
//       print(exception);
//     }
//   }

//   /// Firebase Apple sign in
//   // Future<String> signInWithApple({String email, String password}) async {
//   //   try {
//   //     // User user = await FirebaseAuthOAuth()
//   //     //     .openSignInFlow("apple.com", ["email"], {"locale": "en"});

//   //     // print(user);
//   //     // firebaseAuth.signInWithPopup(provider);

//   //     final OAuthProvider provider = OAuthProvider("apple.com");
//   //     provider.addScope("email");
//   //     provider.addScope("name");
//   //     provider.setCustomParameters({"local": "en"});
//   //     firebaseAuth.signInWithPopup(provider);
//   //   } catch (e) {
//   //     return e.message;
//   //   }
//   // }

//   Future<void> signOut() async {
//     await firebaseAuth.signOut();
//   }
// }

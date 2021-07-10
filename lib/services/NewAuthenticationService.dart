import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:portfolio_management/models/authentication/verify_phone.dart';
import 'package:portfolio_management/models/authentication/verify_phone_signin.dart';
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

      final displayName = '${authResult.user.displayName}';
      final userEmail = '${authResult.user.email}';
      print("Name: $displayName");
      print("Email: $userEmail");

      final User firebaseUser = authResult.user;
      final prefs = await SharedPreferences.getInstance();
      if (displayName != null) {
        prefs.setString("displayName", displayName);
        await firebaseUser.updateProfile(displayName: displayName);
      }
      if (userEmail != null) {
        prefs.setString("userEmail", userEmail);
        await firebaseUser.updateEmail(userEmail);
      }

      return firebaseUser;
    } catch (exception) {
      print(exception);
    }
  }

  // Apple sign for Android
  Future<User> appleAuthenticationAndroid() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.doshaheen.portfoliomanagementservice',
          redirectUri: Uri.parse(
            'https://fern-protective-smash.glitch.me/callbacks/sign_in_with_apple',
          ),
        ),
      );

      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

// Use the OAuthCredential to sign in to Firebase.
      final authResult =
          await FirebaseAuth.instance.signInWithCredential(oAuthCredential);

      // print("Apple Android:- $authResult");

      final displayName = '${authResult.user.displayName}';
      final userEmail = '${authResult.user.email}';
      // print("Name: $displayName");
      // print("Email: $userEmail");

      final User firebaseUser = authResult.user;
      final prefs = await SharedPreferences.getInstance();
      if (displayName != null) {
        prefs.setString("displayName", displayName);
        await firebaseUser.updateProfile(displayName: displayName);
      }
      if (userEmail != null) {
        prefs.setString("userEmail", userEmail);
        await firebaseUser.updateEmail(userEmail);
      }

      return firebaseUser;
    } catch (exception) {
      print(exception);
    }
  }

  static Future<void> signOut() async {
    print("logged out");
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  static String baseUrl =
      "http://ec2-65-2-69-222.ap-south-1.compute.amazonaws.com:3000/api";
  var client = new http.Client();

  // Verify user with phone number - SIGN UP For Investor
  static Future<VerifyPhoneNumber> verifyUser(
      String token, String phoneNumber) async {
    // set up POST request arguments
    final url = Uri.parse("$baseUrl/sign-up/verify/firebase/mobile_no");
    final headers = {"Content-type": "application/json"};
    final _body = '{"mobile_no": "$phoneNumber", "idToken": "$token"}';
    print("Body:${_body}");

    // make POST request
    final response = await post(url, headers: headers, body: _body);

    // check the status code for the result
    //final statusCode = response.statusCode;

    // this API passes back the id of the new item added to the body
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    VerifyPhoneNumber userDetails = VerifyPhoneNumber.from(valueMap);
    return userDetails;
  }

  // Get otp from backend
  static Future<VerifyPhoneNumberSignIn> verifyUserByServer(
      String token,
      String phoneNumber,
      String verificationId,
      String smsCode,
      String inputType,
      String requesterType) async {
    // print("Header => $inputType, token => $token");
    // print("requesterType => $requesterType");
    // print(
    //     "phoneNumber => $phoneNumber, verificationId => $verificationId, smsCode => $smsCode");

    // set up POST request arguments
    final url = Uri.parse("$baseUrl/sign-in/verify_otp");
    final headers = {
      "Content-type": "application/json",
      "x-auth-service-type": "$requesterType"
    };
    var _body;
    if (inputType == "email") {
      _body =
          '{"email_id": "$phoneNumber", "idToken": "$token","verificationId": "$verificationId", "smsCode": "$smsCode"}';
    } else {
      _body =
          '{"mobile_no": "$phoneNumber", "idToken": "$token","verificationId": "$verificationId", "smsCode": "$smsCode"}';
    }
    print("Body:${_body}");

    // make POST request
    final response = await post(url, headers: headers, body: _body);
    print("Body:${response}");

    // check the status code for the result
    //final statusCode = response.statusCode;

    // this API passes back the id of the new item added to the body
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    VerifyPhoneNumberSignIn userDetails =
        VerifyPhoneNumberSignIn.from(valueMap);
    return userDetails;
  }

  // Get otp from backend
  static Future<VerificationIdSignIn> getVerificationFromTwillio(
      String phoneNumber, String inputType, String requesterType) async {
    // print("Header => $inputType, phoneNumber => $phoneNumber");
    // set up POST request arguments
    final url = Uri.parse("$baseUrl/sign-in/send_otp");
    final headers = {
      "Content-type": "application/json",
      "x-auth-service-type": "$requesterType"
    };
    var _body;
    if (inputType == "mobile") {
      _body = '{"mobile_no": "$phoneNumber"}';
    } else {
      _body = '{"email_id": "$phoneNumber"}';
    }

    print("Body:${_body}, requesterType => $requesterType");

    // make POST request
    final response = await post(url, headers: headers, body: _body);

    // check the status code for the result
    //final statusCode = response.statusCode;

    // this API passes back the id of the new item added to the body
    final responseBody = response.body;
    Map valueMap = jsonDecode(responseBody);
    VerificationIdSignIn userDetails = VerificationIdSignIn.from(valueMap);
    return userDetails;
  }
}

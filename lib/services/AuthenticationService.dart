import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthenticationService {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  AuthenticationService(this.firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => firebaseAuth.idTokenChanges();

  /// Firebase Email/password sign-in
  Future<String> signIn({String email, String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<dynamic> signUpWithEmailAndPassword(
      {String email, String password}) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// Firebase Google sign-in
  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await firebaseAuth.signInWithCredential(credential);
      return "Signed in";
    } catch (e) {
      return e.message;
    }
  }

  /// Firebase Google sign-in
  Future<String> signInWithApple({String email, String password}) async {
    try {
      // User user = await FirebaseAuthOAuth()
      //     .openSignInFlow("apple.com", ["email"], {"locale": "en"});

      // print(user);
      // firebaseAuth.signInWithPopup(provider);

      final OAuthProvider provider = OAuthProvider("apple.com");
      provider.addScope("email");
      provider.addScope("name");
      provider.setCustomParameters({"local": "en"});
      firebaseAuth.signInWithPopup(provider);
    } catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toko_romi/models/user.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
String name;
String email;
String imageUrl;

class AuthService {
  // Future<String> signInWithGoogle() async {
  //   final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.getCredential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );

  //   final AuthResult authResult = await _auth.signInWithCredential(credential);
  //   final FirebaseUser user = authResult.user;

  //   assert(!user.isAnonymous);
  //   assert(await user.getIdToken() != null);
    
  //   assert(user.email != null);
  //   assert(user.displayName != null);
  //   assert(user.photoUrl != null);

  //   name = user.displayName;
  //   email = user.email;
  //   imageUrl = user.photoUrl;

  //   // Only taking the first part of the name, i.e., First Name
  //   if (name.contains(" ")) {
  //     name = name.substring(0, name.indexOf(" "));
  //   }

  //   final FirebaseUser currentUser = await _auth.currentUser();
  //   assert(user.uid == currentUser.uid);

  //   return 'signInWithGoogle succeeded: $user';
  // }
  User _getUserFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid, name: user.displayName, email: user.email, photo: user.photoUrl) : null;
  }
  
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_getUserFromFirebase);
  }

  Future<User> handleSignIn() async {
    FirebaseUser user;
    // User res;
    bool isSignedIn = await googleSignIn.isSignedIn();
    if (isSignedIn) {
      user = await _auth.currentUser();
      
    } else {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );
      user = (await _auth.signInWithCredential(credential)).user;
    }
  
    var res = _getUserFromFirebase(user);
    return res;
  }

  Future<String> getCurrentUid() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    return currentUser.uid;
  }

  Future<String> getCurrentUsername() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    return currentUser.displayName;
  }

  Future signOutGoogle() async {
    try {
      await googleSignIn.signOut();
      print("User Sign Out");
    } catch (e) {
      print(e.toString());
    }
  }
}
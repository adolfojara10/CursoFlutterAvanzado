import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential> signIn() async {
    //para escoger con que cuenta iniciar sesion
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    //se consiguen las credenciales de la cuenta
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    final user = await _auth.signInWithCredential(GoogleAuthProvider.credential(
        accessToken: gSA.accessToken, idToken: gSA.idToken));

    return user;
  }

  signOut() async {
    await _auth.signOut().then((onValue) => print("Fin sesión"));
    googleSignIn.signOut();
    print("Sesiones cerradas");
  }
}

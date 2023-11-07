import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// Créer un utilisateur sans se connecter automatiquement
  Future<void> register(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
      name: "secondary",
          options: FirebaseOptions(
          apiKey: "AIzaSyDgBCJC0Us5cogmz8k-2yzRlyq8UAvp-hI",
          appId: "1:45735240169:web:7382fb3065b0db0420ab78",
          messagingSenderId: "45735240169",
          projectId: "pfe-test-1661a",
        ));
    try {
        UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(email: email, password: password);
    }
    on FirebaseAuthException catch (e) {
      // Do something with exception. This try/catch is here to make sure 
      // that even if the user creation fails, app.delete() runs, if is not, 
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
    }
    
    await app.delete();
}

Future<String?> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return "SUCCESFUL LOGGED !";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      return 'L\'adresse e-mail ou le mot de passe est incorrect.';
    }
    return e.message;
  } catch (e) {
    return e.toString();
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

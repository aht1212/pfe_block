import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// Créer un utilisateur sans se connecter automatiquement
Future<void> register(String email, String password) async {
  FirebaseApp app = await Firebase.initializeApp(
      name: "secondary",
      options: FirebaseOptions(
        apiKey: "AIzaSyDY6tYCdhze0vE9yq9ZvAlx9XP12Cf4z4w",
        appId: "1:288090153028:web:80c2d3c3664b4a95ad5c11",
        messagingSenderId: "288090153028",
        projectId: "pfe-eni",
      ));
  try {
    UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
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

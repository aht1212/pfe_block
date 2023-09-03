import 'package:firebase_auth/firebase_auth.dart';

Future<String?> createUser(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 'Le mot de passe est trop faible.';
    } else if (e.code == 'email-already-in-use') {
      return 'Un compte existe déjà avec cette adresse e-mail.';
    }
    return e.message;
  } catch (e) {
    return e.toString();
  }
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

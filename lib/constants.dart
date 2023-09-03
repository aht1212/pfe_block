import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}



const primaryColorCode = 0xFFA9DFD8;
const cardBackgroundColor = Color(0xFF21222D);


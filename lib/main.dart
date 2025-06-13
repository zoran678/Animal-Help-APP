import 'package:animal_app/Ind_screen/ind_screen.dart';
import 'package:animal_app/firebase/firebase_options.dart';
import 'package:animal_app/Screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(home: LoginScreen()),
  );
}

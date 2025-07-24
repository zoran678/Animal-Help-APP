import 'package:animal_app/feature/Ind_screen/bottom_navigation.dart';
import 'package:animal_app/feature/Ind_screen/report_case_screen.dart';
import 'package:animal_app/feature/auth/auth_service.dart';
import 'package:animal_app/feature/firebase/firebase_options.dart';
import 'package:animal_app/feature/auth/login.dart';
import 'package:animal_app/feature/ngo_side/bottom_navigation.dart';
import 'package:animal_app/services/location_services.dart';
import 'package:animal_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LocationServices()),
      ],
      child: MaterialApp(
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (asyncSnapshot.hasData) {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(asyncSnapshot.data!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: Text('No user data found'));
                      }
                      final userData = snapshot.data!;
                      final userType = userData['userType'] as String?;
                      print(userType);
                      if (userType == UserOption.individual) {
                        return const AppBottomNavigation();
                      } else if (userType == UserOption.organisation) {
                        return const AppNGOBottomNavigation();
                      }

                      return const Scaffold(
                        body: Center(
                          child:
                              Text('Unknown user type, something went wrong.'),
                        ),
                      );
                    });
              }

              return LoginScreen();
            }),
      ),
    ),
  );
}

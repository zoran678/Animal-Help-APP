import 'package:animal_app/Screens/ngo_screen.dart';
import 'package:animal_app/Screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:animal_app/service/class.dart';
import 'package:animal_app/Screens/ind_screen.dart';
import 'package:animal_app/firebase/firebase_options.dart';

class Chat_Screen extends StatelessWidget {
  const Chat_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F9FF),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF333333),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ));
  }
}

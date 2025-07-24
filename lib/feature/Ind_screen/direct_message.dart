import 'package:flutter/material.dart';

class Chat_Screen extends StatelessWidget {
  const Chat_Screen({super.key});

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

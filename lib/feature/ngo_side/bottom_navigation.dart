import 'package:animal_app/feature/Ind_screen/home.dart';
import 'package:animal_app/feature/Ind_screen/profile_screen.dart';
import 'package:animal_app/feature/ngo_side/ngo_home.dart';
import 'package:animal_app/feature/ngo_side/ngo_recent_cases_list_page.dart';
import 'package:flutter/material.dart';

class AppNGOBottomNavigation extends StatefulWidget {
  const AppNGOBottomNavigation({super.key});

  @override
  State<AppNGOBottomNavigation> createState() => _AppNGOBottomNavigationState();
}

class _AppNGOBottomNavigationState extends State<AppNGOBottomNavigation> {
  int currentIndex = 0;
  final List<Widget> pages = const [
    NGOHomeScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

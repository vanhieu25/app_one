import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  const MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      child: GNav(
        onTabChange: (value) => onTabChange?.call(value),
        color: Colors.white,
        mainAxisAlignment: MainAxisAlignment.center,
        activeColor: Colors.grey[800],
        tabBackgroundColor: Colors.grey.shade400,
        tabBorderRadius: 25,
        tabActiveBorder: Border.all(color: Colors.grey.shade800, ),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.shopping_bag_outlined,
            text: 'Cart',
          ),
          
        ],
      ),
    );
  }
}
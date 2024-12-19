import 'package:WatchMate/screens/Match.dart';
import 'package:WatchMate/screens/chatlist.dart';
import 'package:WatchMate/screens/profile.dart';
import 'package:WatchMate/screens/watchApidashboard.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int navx;

  const BottomNavBar({super.key, required this.navx});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // backgroundColor: Colors.black, // Change the background color
      selectedItemColor: const Color.fromARGB(
          255, 33, 215, 243), // Color for the selected item
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
          ),
          label: 'Match',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.message,
          ),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
          label: 'Profile',
        ),
      ],
      currentIndex: widget.navx,
      onTap: (index) {
        // Handle
        switch (index) {
          case 0:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => dashboardMate()));
          case 1:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MatchMate()));
          case 2:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ConversationsList()));
          case 3:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
        }
      },
    );
  }
}

import 'package:WatchMate/main.dart';
import 'package:WatchMate/screens/watchApidashboard.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Darkmode extends StatefulWidget {
  const Darkmode({super.key});

  @override
  State<Darkmode> createState() => _DarkmodeState();
}

class _DarkmodeState extends State<Darkmode> with ChangeNotifier {
  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('dark mode')),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: themeProvider.ToggleTheme,
              child: Text(themeProvider.thememode == ThemeMode.dark
                  ? 'Dark Mode'
                  : 'Light Mode')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => dashboardMate()));
              },
              child: Text('return'))
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        navx: 3,
      ),
    );
  }
}

import 'package:WatchMate/screens/AuthPage.dart';
import 'package:WatchMate/screens/profileDetails.dart';
import 'package:WatchMate/screens/darkmode.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigate to settings page (if implemented)
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ))
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Personal Details'),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Profile()));
              // Navigate to profile page (if implemented)
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Dark Mode'),
            onTap: () {
              // Navigate to settings page (if implemented)
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Darkmode()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Implement logout logic
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement actual logout functionality here
                          Navigator.of(context).pop(); // Close the dialog
                          // Example: Navigator.pushReplacementNamed(context, '/login');
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthPage()),
                              (Route) => false);
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(navx: 3),
    );
  }
}

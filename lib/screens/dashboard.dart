// import 'package:feranz_salonga/main.dart'; // Ensure this path is correct
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:WatchMate/screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final User? user = FirebaseAuth.instance.currentUser;

  Widget _userEmail() {
    return Text(user?.email ?? 'User email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userEmail(),
            SizedBox(height: 20),
            Image.network(
              'https://media2.giphy.com/media/7NMG9vPM5kTpC/giphy.gif?cid=6c09b952hhj2tth4xkswfvp0r4pd0arxw0v91ww8icanfuai&ep=v1_gifs_search&rid=giphy.gif&ct=g',
              // 'https://64.media.tumblr.com/faf8e00bedc145470b7c27f5b81ffafc/07f5c59b786500c9-58/s540x810/843ad338ddddd8ca5a668b2e34224cdd2f0400b3.gif',
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'You Did It!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AuthPage()),
                      (route) => false);
                });
              },
              child: const Text("Log Out"),
            )
          ],
        ),
      ),
    );
  }
}

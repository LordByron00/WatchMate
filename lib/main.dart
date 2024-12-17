import 'package:WatchMate/screens/Home.dart';
import 'package:WatchMate/screens/Match.dart';
import 'package:WatchMate/screens/watchApidashboard.dart';
import 'package:WatchMate/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: WatchMate(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get thememode => _themeMode;

  void ToggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class WatchMate extends StatefulWidget {
  const WatchMate({super.key});

  @override
  State<WatchMate> createState() => _WatchMateState();
}

class _WatchMateState extends State<WatchMate> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WatchMate',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 162, 162, 162),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: const Color.fromARGB(255, 24, 36, 37)),
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 24, 36, 37),
        ),
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      themeMode: themeProvider._themeMode,
      home: AuthPage(),
      // home: dashboardMate(),
    );
  }
}

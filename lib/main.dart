import 'package:WatchMate/screens/Spash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://nbaudhxcllzyvwnhrfbe.supabase.co';
// const supabaseKey = String.fromEnvironment('SUPABASE_KEY');
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5iYXVkaHhjbGx6eXZ3bmhyZmJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ0NjczMTgsImV4cCI6MjA1MDA0MzMxOH0.qbojdxA8j-7IzeENXfBxGV5Es7glfWSLcIozb3riNko';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    print('Firebase initialized successfully');

    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );

    print('Supabase initialized successfully');
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
          backgroundColor: const Color.fromARGB(255, 31, 60, 63),
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
      home: SplashScreen(),
      // home: dashboardMate(),
    );
  }
}

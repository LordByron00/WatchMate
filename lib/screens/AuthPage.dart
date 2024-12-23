import 'package:WatchMate/screens/Home.dart';
import 'package:WatchMate/utils/validators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/auth.dart';
import '../widgets/textFormField.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogged = true;
  String? _usernameError;

  Future<void> _validateUsername() async {
    String username = usernameCtrl.text;

    // Call the asynchronous validation function
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _usernameError = 'Username is already taken';
      });
    } else {
      setState(() {
        _usernameError = null; // No error
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmpassCtrl = TextEditingController();

  void toggleForm() {
    setState(() {
      isLogged = !isLogged;
      _formKey.currentState!.reset();
      emailCtrl.text = '';
      passCtrl.text = '';
    });
  }

  Future<void> handleSubmit() async {
    String name = nameCtrl.text;
    String username = usernameCtrl.text;
    String email = emailCtrl.text;
    String password = passCtrl.text;
    String confirmPassword = confirmpassCtrl.text;

    if (_formKey.currentState!.validate()) {
      if (isLogged) {
        // Handle login logic
        await Auth()
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => dashboardMate()),
                  )
                });

        print('Login with Email: $email, Password: $password');
      } else {
        // Handle sign-up logic
        if (password != confirmPassword) {
        } else {
          await Auth()
              .signUp(email, password, username, name)
              .then((onValue) => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => dashboardMate()))
                  });
          print('Sign-Up with Email: $email, Password: $password');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          '🎥',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'WatchMate',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isLogged)
                      // Name Field'
                      Textformfield(
                          label: 'Name',
                          hint: "Enter your name",
                          isPass: false,
                          controller: nameCtrl,
                          validator: Validators.validateName,
                          keyboardType: TextInputType.name),
                    if (!isLogged)
                      //Username
                      Textformfield(
                          label: 'Username',
                          hint: "Enter your username",
                          isPass: false,
                          controller: usernameCtrl,
                          errorText: _usernameError,
                          onchange: (value) {
                            _validateUsername();
                          },
                          validator: Validators.validateUser,
                          keyboardType: TextInputType.text),

                    // Email Field'
                    Textformfield(
                        label: 'Email',
                        hint: "Enter your email",
                        isPass: false,
                        controller: emailCtrl,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress),
                    SizedBox(height: 20),
                    // Password Field
                    Textformfield(
                      label: 'Password',
                      hint: "Enter your password",
                      isPass: true,
                      controller: passCtrl,
                      validator: Validators.validatePassword,
                    ),
                    SizedBox(height: 20),
                    // Confirm Password Field (Sign-Up only)
                    if (!isLogged)
                      Textformfield(
                        label: 'Confirm Password',
                        hint: "Enter your password again",
                        isPass: true,
                        controller: confirmpassCtrl,
                        validator: Validators.validatePassword,
                      ),
                    SizedBox(height: 20),
                    // Submit Button
                    ElevatedButton(
                      onPressed: handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text(
                        isLogged ? 'Login' : 'Sign Up',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Toggle Button for Login/Sign-Up
                    TextButton(
                      onPressed: toggleForm,
                      child: Text(
                        isLogged
                            ? "Don't have an account? Sign Up"
                            : "Already have an account? Login",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

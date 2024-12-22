import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile; // Local image file
  String? _downloadUrl; // URL of the uploaded image
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload to Firebase Storage
      await _uploadToFirebase();
    }
  }

  // Function to upload image to Firebase Storage
  Future<void> _uploadToFirebase() async {
    try {
      if (_imageFile == null) return;

      // Create a unique file name
      String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('profiles/$fileName');
      await storageRef.putFile(_imageFile!);

      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      setState(() {
        _downloadUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Profile Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _downloadUrl != null
              ? CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(_downloadUrl!),
                )
              : const CircleAvatar(
                  radius: 80,
                  child: Icon(Icons.person, size: 80),
                ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Upload Profile Image'),
          ),
        ],
      ),
    );
  }
}

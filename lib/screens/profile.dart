import 'package:WatchMate/screens/Chat.dart';
import 'package:WatchMate/screens/Home.dart';
import 'package:WatchMate/screens/MedeiaDetail.dart';
import 'package:WatchMate/screens/profileDetails.dart';
import 'package:WatchMate/screens/watchApidashboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:WatchMate/screens/settings.dart';
import 'package:WatchMate/services/userPreference.dart';
import 'package:WatchMate/utils/auth.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;

  List<Map<String, dynamic>>? favorite;
  List<Map<String, dynamic>>? MovieRating;
  List<Map<String, dynamic>>? MovieReview;

  File? _imageFile; // Local image file
  dynamic _imageUrl; // URL of the uploaded image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // fetchDPbyID();
    wait();
  }

  void wait() async {
    try {
      await Auth().setUser();
      await fetchDPbyID(); // Ensures fetchDPbyID completes first
      getFavorites(); // Waits for getFavorites
      getRatings(); // Waits for getRatings
      getReviews(); // Waits for getReviews
    } catch (e) {
      print('Error in initialization: $e'); // Handle any errors
    }
  }

  void getFavorites() async {
    print('getting favorites');
    QuerySnapshot favoriteSnapshot =
        await PreferenceService().getFavorites(Auth().curUserData?.uid);
    if (favoriteSnapshot.docs.isNotEmpty) {
      setState(() {
        favorite = favoriteSnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    }

    // print('favorite');
    // print(favorite);
  }

  void getRatings() async {
    print('getting Rating');
    QuerySnapshot favoriteSnapshot =
        await PreferenceService().getRatings(Auth().curUserData?.uid);
    if (favoriteSnapshot.docs.isNotEmpty) {
      setState(() {
        MovieRating = favoriteSnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    }
  }

  void getReviews() async {
    print('getting review');
    QuerySnapshot favoriteSnapshot =
        await PreferenceService().getReviews(Auth().curUserData?.uid);

    if (favoriteSnapshot.docs.isNotEmpty) {
      setState(() {
        MovieReview = favoriteSnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });
    }
  }

  Future<void> getDP(fileName) async {
    // Retrieve the public URL of the uploaded file
    final publicUrl =
        Supabase.instance.client.storage.from('avatars').getPublicUrl(fileName);
    if (publicUrl.isNotEmpty) {
      setState(() {
        _imageUrl = publicUrl;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload to Firebase Storage
      await _uploadToSupabase(_imageFile!);
    }
  }

  // Function to upload the image to Supabase Storage
  Future<void> _uploadToSupabase(File file) async {
    try {
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // final fileName = Auth().curUserData!.uid;

      // Upload file to the "avatars" bucket
      final response = await Supabase.instance.client.storage
          .from('avatars') // Bucket name
          .upload(fileName, file);

      if (response.isNotEmpty) {
        print('Response type: ${response.runtimeType}');
        print('Response status: $response');
      }

      // Retrieve the public URL of the uploaded file
      getDP(fileName);

      await storeImageMetadata(fileName, _imageUrl);

      print("Image uploaded successfully: $_imageUrl");
    } catch (e) {
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }
  }

  Future<void> storeImageMetadata(String name, String fileUrl) async {
    try {
      final PostgrestResponse response = await Supabase.instance.client
          .from('images') // Table where metadata is stored
          .insert({
        'fbid': Auth().curUserData?.uid,
        'name': name,
        'file_url': fileUrl,
      });

      // Check for errors in the response
      print('ResponseDatabase type: ${response.runtimeType}');
      print('ResponseDatabase status: $response');
    } catch (e) {
      print('Error storing metadata: $e');
    }
  }

  Future<void> fetchDPbyID() async {
    print('fetching DP by ID..');
    try {
      // Query the 'images' table for a single row where name matches
      final response = await Supabase.instance.client
          .from('images')
          .select()
          .eq('fbid', Auth().curUserData!.uid)
          .order('uploaded_at', ascending: false)
          .limit(1) // Filter rows where name = 'something'
          .maybeSingle(); // Fetch at most one row, or null if none found

      if (response == null) {
        _imageUrl = 'not found';
      } else {
        setState(() {
          _imageUrl = response['file_url'];
        });
        print(_imageUrl);
        // Handle the retrieved data
        print('ID: ${response['fbid']}');
        print('Name: ${response['name']}');
        print('file_url: ${response['file_url']}');
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<void> _uploadToFirebase() async {
    try {
      if (_imageFile == null) return;

      // Create a unique file name
      String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('profileImage/$fileName');
      await storageRef.putFile(_imageFile!);

      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      if (downloadUrl.isNotEmpty) {
        setState(() {
          _imageUrl = downloadUrl;
        });
      }

      print('downloadUrl');
      print(downloadUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully!")),
      );
    } catch (e) {
      print("Upload failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  final List<String> tabs = ['Favorites', 'Ratings', 'Reviews'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: BackButton(),
        title: Row(
          children: [SizedBox(width: 100), Text('Profile')],
        ),
      ),
      endDrawer:
          Auth().curUserData == null && _imageUrl == null ? null : AppDrawer(),
      body: (_imageUrl == null) && Auth().curUserData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Cover Section
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/cover.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.48),
                        ), // Dark overlay
                      ),
                      // Profile Photo and Info
                      Positioned(
                        bottom: 15,
                        left: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(_imageUrl ?? 'no image'),
                              ),
                              Positioned(
                                  bottom: 3,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: const Color.fromARGB(
                                            255, 86, 86, 86)),
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: Icon(
                                        Icons.camera_alt_sharp,
                                        size: 20,
                                      ),
                                    ),
                                  ))
                            ]),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Auth().curUserData != null
                                      ? Auth().curUserData!.name
                                      : 'User not found',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(
                                          0.0,
                                          1.5,
                                        ), // Horizontal and vertical offset
                                        blurRadius: 1.0, // Blur radius
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  Auth().curUserData != null
                                      ? '@${Auth().curUserData!.username}'
                                      : 'UserName not found',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    shadows: [
                                      Shadow(
                                        offset: Offset(
                                          0.0,
                                          1.5,
                                        ), // Horizontal and vertical offset
                                        blurRadius: 1.0, // Blur radius
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Edit Profile Button
                      Positioned(
                        bottom: 10,
                        right: 20,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.3),
                            side: BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            fixedSize: Size(75, 30),
                          ),
                          onPressed: () {
                            _pickImage();
                          },
                          child: Text(
                            "Edit cover",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 9),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 60), // Space for profile photo
                  // Tabs Section
                  Container(
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(tabs.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: selectedIndex == index
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedIndex == index
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Content Section
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 13, horizontal: 0),
                    child: Text(
                      'Movies',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  switch (selectedIndex) {
                    0 => buildFavorite(favorite, selectedIndex),
                    1 => buildFavorite(MovieRating, selectedIndex),
                    2 => buildFavorite(MovieReview, selectedIndex),
                    _ => Container(), // Default case (optional)
                  },
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBar(navx: 3),
    );
  }

  Widget AppDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('${Auth().curUserData!.name}'),
            accountEmail: Text('@${Auth().curUserData!.email}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(_imageUrl ?? 'no image'),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => dashboardMate()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile Details'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
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
    );
  }
}

Widget buildFavorite(favorite, selectedIndex) {
  return favorite != null
      ? SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            itemCount: favorite.length, // Sample item count
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(
                          movie: favorite[index],
                        ),
                      ));
                },
                child: Card(
                  margin: EdgeInsets.only(right: 10),
                  child: Container(
                    width: 150, // Fixed width
                    height: 270, // Fixed height
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        Container(
                          height: 180, // Fixed height for the image
                          width: double.infinity, // Full width for the card
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              // image: AssetImage('assets/${Movies[index]}'),
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${favorite[index]['poster_path']}',
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        // Text Section

                        switch (selectedIndex) {
                          0 => Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Wrap(
                                children: [
                                  Text(
                                    favorite[index]['title'] ?? 'No title',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    // overflow: TextOverflow.ellipsis,
                                    overflow: TextOverflow.clip,
                                  ),
                                ],
                              )),
                          1 => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    favorite[index]['rating'], (starIndex) {
                                  return Icon(Icons.star,
                                      size: 16, color: Colors.amber);
                                }),
                              ),
                            ),
                          2 => Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                favorite[index]['review'],
                                softWrap: true,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          _ => Container(), // Default case (optional)
                        },
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      : Container();
}

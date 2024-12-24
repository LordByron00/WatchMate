import 'package:WatchMate/screens/Chat.dart';
import 'package:WatchMate/screens/AuthPage.dart';
import 'package:WatchMate/screens/MedeiaDetail.dart';
import 'package:WatchMate/screens/profileDetails.dart';
import 'package:WatchMate/screens/Home.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final List<String> tabs = ['Favorites', 'Ratings', 'Reviews'];
  late Map<String, dynamic>? reviewData;

  File? _imageFile; // Local image file
  dynamic _imageUrl; // URL of the uploaded image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // fetchDPbyID();
    wait();
  }

  Future<void> setReview(Reviewmovie) async {
    print('setting Review');
    QuerySnapshot<Object?> reviewSnap =
        await PreferenceService().checkReview(Reviewmovie);

    if (reviewSnap.docs.isNotEmpty) {
      setState(() {
        reviewData = reviewSnap.docs.first.data() as Map<String, dynamic>;
      });
    } else {
      reviewData = null;
      print('it returned even empty');
    }
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
        await PreferenceService().getReviews(Auth().curUserData?.uid);
    if (favoriteSnapshot.docs.isNotEmpty) {
      setState(() {
        // MovieRating = favoriteSnapshot.docs.map((doc) {
        //   return doc.data() as Map<String, dynamic>;
        // }).toList();

        MovieRating = favoriteSnapshot.docs
            .where((doc) =>
                doc['rating'] != null &&
                doc['rating'] > 0) // Add your specific condition here
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    }
  }

  void getReviews() async {
    print('getting review');
    QuerySnapshot favoriteSnapshot =
        await PreferenceService().getReviews(Auth().curUserData?.uid);

    if (favoriteSnapshot.docs.isNotEmpty) {
      setState(() {
        MovieReview = favoriteSnapshot.docs
            .where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data.isNotEmpty && // Ensure `data` is not null
                  data.containsKey('review') &&
                  data['review'] != null && // Ensure 'review' is not null
                  data['review'] != ''; // Ensure 'review' is not empty
            }) // Add your specific condition here
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });

      print('getReviews');
      print(MovieReview);
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
                    2 => buildReview(MovieReview),
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
            accountName: Text(Auth().curUserData!.name),
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
              Navigator.pushReplacement(
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

  Widget buildReview(reviewList) {
    return reviewList != null
        ? SizedBox(
            height: 330,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(10),
              itemCount: reviewList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 290,
                  padding: EdgeInsets.all(20),
                  // clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 51, 58, 62),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //Movie image
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MovieDetailPage(
                                        movie: reviewList[index],
                                      ),
                                    ));
                              },
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${reviewList[index]['poster_path']}',
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      reviewList[index]['title'],
                                      overflow: TextOverflow.clip,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (starIndex) {
                                      return starIndex <
                                              reviewList[index]['rating']
                                          ? Icon(Icons.star,
                                              size: 18,
                                              color: const Color.fromRGBO(
                                                  254, 191, 3, 1))
                                          : Icon(Icons.star,
                                              size: 18,
                                              color: const Color.fromARGB(
                                                  109, 220, 194, 107));
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Text(
                          reviewList[index]['review'],
                          softWrap: true,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                      // Spacer(),
                      Row(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            child: Icon(Icons.thumb_up_alt_sharp,
                                size: 18,
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                          SizedBox(width: 15),
                          Text(
                            '0',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                              child: Icon(Icons.thumb_down_alt,
                                  size: 18,
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255))),
                          Spacer(),
                          PopupMenuButton(
                              color: const Color.fromARGB(255, 40, 46, 49),
                              constraints: BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.more_horiz),
                              onSelected: (item) async {
                                if (item == 'Edit') {
                                  print('Edit selected');
                                  // await setReview(reviewList[index]);
                                  // _showReviewPopup(context, reviewList[index]);
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                        value: 'Edit',
                                        onTap: () async {
                                          print('edit');
                                          await setReview(reviewList[index]);
                                          print('reviewData');
                                          print(reviewData);
                                          _showReviewPopup(
                                              context, reviewList[index]);
                                        },
                                        child: Wrap(
                                          children: [
                                            Icon(Icons.edit),
                                            Text('Edit')
                                          ],
                                        )),
                                    PopupMenuItem(
                                        value: 'Delete',
                                        onTap: () async {
                                          print('printing');
                                          await PreferenceService()
                                              .clearReview(reviewList[index]);
                                          getReviews();
                                        },
                                        child: Wrap(
                                          children: [
                                            Icon(Icons.delete),
                                            Text('Delete')
                                          ],
                                        ))
                                  ]),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : Container();
  }

  Widget buildFavorite(favorite, selectedIndex) {
    return favorite != null
        ? SizedBox(
            height: selectedIndex != 0 ? 285 : 265,
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
                  child: SizedBox(
                    width: 170,
                    child: Card(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Section
                          Container(
                            height: 180, // Fixed height for the image
                            width: double.infinity, // Full width for the card
                            padding: EdgeInsets.all(15),
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
                            0 => Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    favorite[index]['title'] ?? 'No title',
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            1 => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(5, (starIndex) {
                                          return favorite[index]['rating'] >
                                                  starIndex
                                              ? Icon(Icons.star,
                                                  size: 16, color: Colors.amber)
                                              : Icon(Icons.star,
                                                  size: 16,
                                                  color: const Color.fromARGB(
                                                      89, 182, 151, 57));
                                        }),
                                      ),
                                    ],
                                  ),
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

  void _showReviewPopup(BuildContext context, reviewMovie) {
    final TextEditingController reviewController = TextEditingController();
    int starRating = (reviewData?['rating'] ?? 0);
    reviewController.text = reviewData?['review'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(15),
          title: const Text(
            'Leave a Review',
            textAlign: TextAlign.center,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Star Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            starRating = index + 1;
                          });
                        },
                        child: Icon(
                          index < starRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 25,
                        ),
                      );
                    }),
                  ),

                  // Review Text Field
                  TextField(
                    controller: reviewController,
                    decoration: InputDecoration(
                      labelText: 'Your review',
                      border: const OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 12),
                    maxLines: 6,
                    maxLength: 200,
                  ),
                ],
              );
            },
          ),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    await PreferenceService().clearReview(reviewMovie);
                    // await PreferenceService().clearRating(reviewMovie);
                    getReviews();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> movieReview = {
                      ...reviewMovie,
                      'review': reviewController.text,
                      'rating': starRating,
                    };

                    await PreferenceService().addReview(movieReview);
                    // await PreferenceService().addRating(movieReview);
                    getReviews();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Submit', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

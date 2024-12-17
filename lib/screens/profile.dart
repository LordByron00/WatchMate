import 'package:WatchMate/ignore/profile.dart';
import 'package:WatchMate/screens/settings.dart';
import 'package:WatchMate/utils/auth.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;

  final List<String> tabs = ['Favorites', 'Ratings', 'Reviews'];
  final List<String> Movies = [
    'mad_max.jpg',
    'redone.jpg',
    'Venom.jpg',
    'Dune.jpg',
    'Secret Level.jpg'
  ];

  final List<String> Movietitle = [
    'Mad Max',
    'Red One',
    'Venom',
    'Dune',
    'Secret Level'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
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
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/lord.jpg'),
                      ),
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
                              color: const Color.fromARGB(255, 255, 255, 255),
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
                              color: const Color.fromARGB(255, 255, 255, 255),
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
                      fixedSize: Size(114, 25),
                    ),
                    onPressed: () {
                      // Handle Edit Profile Action
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => Profile(),
                            builder: (context) => SettingsPage(),
                          ));
                    },
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 13),
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
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 0),
              child: Text(
                'Movies',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                itemCount: Movies.length, // Sample item count
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(right: 10),
                    child: Container(
                      width: 150, // Fixed width
                      height: 200, // Fixed height
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
                                image: AssetImage('assets/${Movies[index]}'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          // Text Section
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              Movietitle[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(navx: 3),
    );
  }
}

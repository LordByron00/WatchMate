import 'package:WatchMate/screens/profile.dart';
import 'package:WatchMate/utils/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  // final String user;
  // const Profile(User? currentUser, {super.key, required this.user});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();
  TextEditingController schoolCtrl = TextEditingController();
  TextEditingController bioCtrl = TextEditingController();
  DateTime? dateSelected;
  String _selectedGender = 'Male';
  List<dynamic> Lgenres = [];
  TextEditingController genreCtrl = TextEditingController();

  void setData() {
    print('detail Rebuilding');
    if (Auth().curUserData != null) {
      nameCtrl.text = Auth().curUserData!.name;
      emailCtrl.text = Auth().curUserData!.email;
      usernameCtrl.text = Auth().curUserData!.username;

      if (Auth().curUserData!.location != null) {
        ageCtrl.text = Auth().curUserData!.age!;
      }
      if (Auth().curUserData!.location != null) {
        locationCtrl.text = Auth().curUserData!.location!;
      }
      if (Auth().curUserData!.birthdate != null) {
        dateSelected = Auth().curUserData!.birthdate;
      }
      if (Auth().curUserData!.school != null) {
        schoolCtrl.text = Auth().curUserData!.school!;
      }
      if (Auth().curUserData!.bio != null) {
        bioCtrl.text = Auth().curUserData!.bio!;
      } else {
        print('empty bio');
      }
      if (Auth().curUserData!.gender != null) {
        _selectedGender = Auth().curUserData!.gender!;
      }
      if (Auth().curUserData!.genre != null) {
        Lgenres = Auth().curUserData!.genre!;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  Future<void> dateSelect(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != dateSelected) {
      setState(() {
        dateSelected = picked;
      });
    }
  }

  void genreAdd() {
    if (genreCtrl.text.isNotEmpty) {
      setState(() {
        Lgenres.add(genreCtrl.text);
        genreCtrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile Details'),
        // backgroundColor: Colors.cyanAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.cyanAccent)),
                style: TextStyle(color: Colors.white, fontSize: 15),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter your name';
                //   }
                //   return null;
                // },
              ),
              TextFormField(
                controller: usernameCtrl,
                decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.cyanAccent)),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Colors.cyanAccent)),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                    labelText: 'Gender/Sex',
                    labelStyle: TextStyle(color: Colors.cyanAccent)),
                items: ['Male', 'Female', 'Nonbinary', 'LGBTQ+'].map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(
                      gender,
                      style: TextStyle(
                        color: Colors.cyanAccent,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please select your gender';
                //   }
                //   return null;
                // },
              ),
              TextFormField(
                controller: ageCtrl,
                decoration: InputDecoration(
                    labelText: 'Age',
                    labelStyle: TextStyle(color: Colors.cyanAccent)),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              ListTile(
                title: Text(
                  dateSelected == null
                      ? 'Select Date of Birth'
                      : '${dateSelected?.toLocal()}'.split(' ')[0],
                  style: TextStyle(color: Colors.cyanAccent),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => dateSelect(context),
              ),
              TextFormField(
                controller: schoolCtrl,
                decoration: InputDecoration(
                    labelText: 'College',
                    labelStyle: TextStyle(color: Colors.cyanAccent)),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              TextFormField(
                controller: locationCtrl,
                decoration: InputDecoration(
                    labelText: 'Live in',
                    labelStyle: TextStyle(color: Colors.cyanAccent)),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              TextFormField(
                controller: bioCtrl,
                decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(color: Colors.cyanAccent)),
                style: TextStyle(color: Colors.white, fontSize: 15),
                maxLines: 4,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter your bio';
                //   }
                //   return null;
                // },
              ),
              TextFormField(
                controller: genreCtrl,
                decoration: InputDecoration(
                    labelText: 'Genre',
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.cyanAccent,
                      ),
                      onPressed: genreAdd,
                    ),
                    labelStyle: TextStyle(color: Colors.cyanAccent)),
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: Lgenres.map((genre) => Chip(
                      label: Text(genre),
                      onDeleted: () {
                        setState(() {
                          Lgenres.remove(genre);
                        });
                      },
                    )).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Save the profile data
                    DocumentReference userDoc = FirebaseFirestore.instance
                        .collection('users')
                        .doc(Auth().curUserData?.uid);

                    // Adding or updating fields
                    await userDoc.update({
                      if (nameCtrl.text.isNotEmpty) 'name': nameCtrl.text,
                      if (ageCtrl.text.isNotEmpty) 'age': ageCtrl.text,
                      if (_selectedGender.isNotEmpty) 'gender': _selectedGender,
                      if (schoolCtrl.text.isNotEmpty) 'school': schoolCtrl.text,
                      if (locationCtrl.text.isNotEmpty)
                        'location': locationCtrl.text,
                      if (dateSelected != null) 'birthdate': dateSelected,
                      if (bioCtrl.text.isNotEmpty) 'bio': bioCtrl.text,
                      if (Lgenres.isNotEmpty) 'genre': Lgenres
                    });

                    Auth().setUser();

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Save Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateUserData() async {
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(Auth().curUserData?.uid);

    // Adding or updating fields
    await userDoc.update({
      'name': 'John Doe',
      'age': 25,
    });
  }
}

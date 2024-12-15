import 'package:WatchMate/ignore/watchmateDashboard.dart';
import 'package:WatchMate/screens/profile.dart';
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
  TextEditingController bioCtrl = TextEditingController();
  DateTime? dateSelected;
  String _selectedGender = 'Male';
  List<String> Lgenres = [];
  TextEditingController genreCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // emailCtrl.text = widget.user;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
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
                    labelStyle: TextStyle(color: Colors.blue)),
                style: TextStyle(color: Colors.black, fontSize: 15),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Colors.blue)),
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(
                    labelText: 'Gender/Sex',
                    labelStyle: TextStyle(color: Colors.blue)),
                items: ['Male', 'Female', 'Nonbinary', 'LGBTQ+'].map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(
                      gender,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                  dateSelected == null
                      ? 'Select Date of Birth'
                      : '${dateSelected?.toLocal()}'.split(' ')[0],
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () => dateSelect(context),
              ),
              TextFormField(
                controller: bioCtrl,
                decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: TextStyle(color: Colors.blue)),
                style: TextStyle(color: Colors.black, fontSize: 15),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your bio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: genreCtrl,
                decoration: InputDecoration(
                    labelText: 'Genre',
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      onPressed: genreAdd,
                    ),
                    labelStyle: TextStyle(color: Colors.black)),
                style: TextStyle(color: Colors.black, fontSize: 15),
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
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Save the profile data
                    print('Name: ${nameCtrl.text}');
                    print('Email: ${emailCtrl.text}');
                    print('Gender: $_selectedGender');
                    print('Date of Birth: $dateSelected');
                    print('Bio: ${bioCtrl.text}');
                    print('Genres: $Lgenres');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
}

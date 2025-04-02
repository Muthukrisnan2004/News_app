import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedGender;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = data['name'] ?? '';
            _selectedGender = data['gender'] ?? null;
            _phoneController.text = data['phone'] ?? '';
            _locationController.text = data['location'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).set({
            'name': _nameController.text,
            'gender': _selectedGender,
            'phone': _phoneController.text,
            'location': _locationController.text,
          }, SetOptions(merge: true)); // Prevents overwriting other fields

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark Theme
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter your name" : null,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                dropdownColor: Colors.grey[900],
                decoration: InputDecoration(
                  labelText: "Gender",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                  child:
                  Text(gender, style: TextStyle(color: Colors.white)),
                  value: gender,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) => value == null ? "Select a gender" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter your phone number" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _locationController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Location",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter your location" : null,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveUserData,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

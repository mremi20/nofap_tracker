import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String profileImagePath = "";
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // لود کردن اطلاعات ذخیره‌شده
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? "کاربر";
      usernameController.text = prefs.getString('username') ?? "username";
      bioController.text =
          prefs.getString('bio') ?? "بیوگرافی خود را وارد کنید";
      profileImagePath = prefs.getString('profileImage') ?? "";
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // ذخیره اطلاعات کاربر
  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', nameController.text);
    prefs.setString('username', usernameController.text);
    prefs.setString('bio', bioController.text);
    prefs.setString('profileImage', profileImagePath);
    prefs.setBool('darkMode', isDarkMode);
  }

  // تغییر عکس پروفایل
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImagePath = pickedFile.path;
      });
      _saveUserData();
    }
  }

  // تغییر تم دارک و لایت
  void _toggleDarkMode() async {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    _saveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("پروفایل"),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: _toggleDarkMode,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImagePath.isNotEmpty
                      ? FileImage(File(profileImagePath))
                      : null,
                  child: profileImagePath.isEmpty
                      ? Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "نام"),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "نام کاربری"),
              ),
              TextField(
                controller: bioController,
                decoration: InputDecoration(labelText: "بیوگرافی"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUserData,
                child: Text("ذخیره تغییرات"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

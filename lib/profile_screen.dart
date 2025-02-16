import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  String username = "";
  String gender = "مرد";
  int age = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 📌 خواندن اطلاعات از SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "";
      age = prefs.getInt('age') ?? 0;
      gender = prefs.getString('gender') ?? "مرد";
      _nameController.text = username;
      _ageController.text = age > 0 ? age.toString() : "";
    });
  }

  // 📌 ذخیره اطلاعات کاربر
  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String newUsername = _nameController.text;
    int newAge = int.tryParse(_ageController.text) ?? 0;

    await prefs.setString('username', newUsername);
    await prefs.setInt('age', newAge);
    await prefs.setString('gender', gender);

    setState(() {
      username = newUsername;
      age = newAge;
    });

    // 📌 نمایش پیام ذخیره شدن اطلاعات
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("اطلاعات ذخیره شد ✅"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("پنل کاربری")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "نام خود را وارد کنید:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "نام کاربری",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "سن:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "سن",
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "جنسیت:",
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton<String>(
              value: gender,
              items: ["مرد", "زن"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  gender = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text("ذخیره تغییرات"),
            ),
            const SizedBox(height: 20),
            Text(
              "نام شما: $username",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "سن: ${age > 0 ? age : "نامشخص"}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "جنسیت: $gender",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

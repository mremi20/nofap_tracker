import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_screen.dart';

void main() {
  runApp(const NoFapApp());
}

class NoFapApp extends StatelessWidget {
  const NoFapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoFap Tracker',
      theme: ThemeData.dark(), // تم پیش‌فرض دارک
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _streak = 0;
  int _bestRecord = 0;
  int _resetCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // لود کردن داده‌ها از SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _streak = prefs.getInt('streak') ?? 0;
      _bestRecord = prefs.getInt('bestRecord') ?? 0;
      _resetCount = prefs.getInt('resetCount') ?? 0;
    });
  }

  // ریست کردن تایمر و افزایش تعداد ریست‌ها
  Future<void> _resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_streak > _bestRecord) {
        _bestRecord = _streak;
        prefs.setInt('bestRecord', _bestRecord);
      }
      _streak = 0;
      _resetCount++;
      prefs.setInt('streak', _streak);
      prefs.setInt('resetCount', _resetCount);
    });
  }

  // برو به صفحه پروفایل
  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoFap Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person), // آیکون پروفایل در هدر
            onPressed: _goToProfile,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'مدت زمان ترک:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_streak روز',
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetStreak,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('ریست کردن ترک'),
            ),
            const SizedBox(height: 20),
            Text(
              'بهترین رکورد: $_bestRecord روز',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            Text(
              'تعداد ریست‌ها: $_resetCount بار',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

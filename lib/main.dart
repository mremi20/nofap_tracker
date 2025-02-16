import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 📌 فایل مربوط به پروفایل کاربر
import 'profile_screen.dart';

void main() {
  runApp(const NoFapApp());
}

// 📌 اپلیکیشن اصلی
class NoFapApp extends StatelessWidget {
  const NoFapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoFap Tracker',
      theme: ThemeData.dark(), // تم تاریک
      home: const HomeScreen(),
    );
  }
}

// 📌 صفحه اصلی (HomeScreen)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  Duration _duration = const Duration();
  int bestRecord = 0;
  int resetCount = 0;
  int userScore = 0;

  @override
  void initState() {
    super.initState();
    _loadData(); // 📌 مقادیر ذخیره‌شده را بارگیری کن
    _startTimer(); // 📌 تایمر را شروع کن
  }

  // 📌 تابع برای خواندن اطلاعات از SharedPreferences
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bestRecord = prefs.getInt('bestRecord') ?? 0;
      resetCount = prefs.getInt('resetCount') ?? 0;
      userScore = prefs.getInt('userScore') ?? 0;
    });
  }

  // 📌 شروع تایمر
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration = _duration + const Duration(seconds: 1);
      });
    });
  }

  // 📌 ریست کردن تایمر و ذخیره داده‌ها
  void _resetTimer() async {
    final prefs = await SharedPreferences.getInstance();

    if (_duration.inSeconds > bestRecord) {
      bestRecord = _duration.inSeconds;
      prefs.setInt('bestRecord', bestRecord);
    }

    resetCount++;
    prefs.setInt('resetCount', resetCount);

    _duration = const Duration();
    setState(() {});

    prefs.setInt('userScore', userScore);
  }

  // 📌 تبدیل ثانیه به فرمت HH:MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoFap Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person), // 📌 آیکون پنل کاربری
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'مدت زمان ترک:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _formatDuration(_duration),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetTimer,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("ریست کردن ترک"),
            ),
            const SizedBox(height: 20),
            Text(
              "بهترین رکورد: ${_formatDuration(Duration(seconds: bestRecord))}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "تعداد ریست‌ها: $resetCount بار",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "امتیاز شما: $userScore امتیاز",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}

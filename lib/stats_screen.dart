import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  final int currentStreak; // مدت زمان فعلی ترک (به روز)
  final int bestStreak; // بهترین رکورد (به روز)
  final int resetCount; // تعداد ریست‌ها

  const StatsScreen({
    Key? key,
    required this.currentStreak,
    required this.bestStreak,
    required this.resetCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("آمار و تحلیل ترک"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            StatItem(title: "مدت زمان ترک فعلی:", value: "$currentStreak روز"),
            StatItem(title: "بهترین رکورد:", value: "$bestStreak روز"),
            StatItem(title: "تعداد ریست‌ها:", value: "$resetCount بار"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("بازگشت به صفحه اصلی"),
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String title;
  final String value;

  const StatItem({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(value,
              style: const TextStyle(fontSize: 18, color: Colors.blueAccent)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HourlyFore extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const HourlyFore(
      {super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              Text(time, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Icon(icon, size: 30),
              const SizedBox(height: 10),
              Text(temp, style: const TextStyle(fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const HoroscopeApp());
}

class HoroscopeApp extends StatelessWidget {
  const HoroscopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Horoscope',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignListScreen(),
    );
  }
}

const List<String> signs = [
  'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
  'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
];

class SignListScreen extends StatelessWidget {
  const SignListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick your sign')),
      body: ListView.builder(
        itemCount: signs.length,
        itemBuilder: (context, index) {
          final sign = signs[index];
          return ListTile(
            title: Text(sign),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HoroscopeScreen(sign: sign)),
              );
            },
          );
        },
      ),
    );
  }
}

class HoroscopeScreen extends StatelessWidget {
  const HoroscopeScreen({super.key, required this.sign});

  final String sign;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sign)),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Your horoscope for today will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
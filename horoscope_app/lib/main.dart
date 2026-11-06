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

const Map<String, String> readings = {
  'Aries': 'Energy is high today. Start the thing you have been putting off.',
  'Taurus': 'Slow down and enjoy the small comforts. Patience pays off.',
  'Gemini': 'A conversation could spark a useful idea. Stay curious.',
  'Cancer': 'Trust your instincts with a decision that has been nagging you.',
  'Leo': 'Your confidence shines. Share credit and it will grow.',
  'Virgo': 'Tidy one small corner of your life and notice how it feels.',
  'Libra': 'Balance matters today. Say no to one thing so you can say yes to another.',
  'Scorpio': 'Focus beats scattered effort. Pick one goal and push on it.',
  'Sagittarius': 'Try something new, even something small.',
  'Capricorn': 'Steady progress counts. Do not compare your pace to others.',
  'Aquarius': 'An unusual idea deserves a second look.',
  'Pisces': 'Rest is productive too. Give your mind some quiet time.',
};

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
    final now = DateTime.now();
    final date = '${now.day}/${now.month}/${now.year}';

    return Scaffold(
      appBar: AppBar(title: Text(sign)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            Text(
              readings[sign] ?? 'No reading available yet.',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
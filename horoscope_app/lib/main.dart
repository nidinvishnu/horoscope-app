import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  final prefs = await SharedPreferences.getInstance();
  final savedSign = prefs.getString('sign');
  runApp(HoroscopeApp(savedSign: savedSign));
}

class HoroscopeApp extends StatelessWidget {
  const HoroscopeApp({super.key, this.savedSign});

  final String? savedSign;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Horoscope',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: savedSign == null
          ? const SignListScreen()
          : HoroscopeScreen(sign: savedSign!),
    );
  }
}

const List<String> signs = [
  'Aries',
  'Taurus',
  'Gemini',
  'Cancer',
  'Leo',
  'Virgo',
  'Libra',
  'Scorpio',
  'Sagittarius',
  'Capricorn',
  'Aquarius',
  'Pisces',
];

const Map<String, String> symbols = {
  'Aries': '♈',
  'Taurus': '♉',
  'Gemini': '♊',
  'Cancer': '♋',
  'Leo': '♌',
  'Virgo': '♍',
  'Libra': '♎',
  'Scorpio': '♏',
  'Sagittarius': '♐',
  'Capricorn': '♑',
  'Aquarius': '♒',
  'Pisces': '♓',
};

const List<String> dailyReadings = [
  'Energy is high today. Start the thing you have been putting off.',
  'Slow down and enjoy the small comforts. Patience pays off.',
  'A conversation could spark a useful idea. Stay curious.',
  'Trust your instincts with a decision that has been nagging you.',
  'Your confidence shines. Share credit and it will grow.',
  'Tidy one small corner of your life and notice how it feels.',
  'Balance matters today. Say no to one thing so you can say yes to another.',
  'Focus beats scattered effort. Pick one goal and push on it.',
  'Try something new, even something small.',
  'Steady progress counts. Do not compare your pace to others.',
  'An unusual idea deserves a second look.',
  'Rest is productive too. Give your mind some quiet time.',
  'Reach out to someone you have not spoken to in a while.',
  'Small habits add up. Repeat one good thing today.',
  'A delay may turn out to be useful. Use the extra time well.',
  'Listen more than you speak, and you will learn something.',
  'Say what you actually mean today. Clarity saves time.',
  'Take a short walk. Your best thinking happens on the move.',
  'Finish one thing completely before starting another.',
  'Ask for help. It is easier than you expect.',
  'Let go of one worry that is not yours to carry.',
  'Celebrate a small win you have been overlooking.',
  'Plan tomorrow tonight, and the morning will feel lighter.',
  'Someone is paying more attention to your effort than you realise.',
  'Choose the simple option. It is probably the right one.',
  'Be kind to yourself about something you cannot change.',
  'A fresh perspective is one question away. Ask it.',
  'Do something just because you enjoy it.',
  'Your timing is better than you think. Trust it.',
  'Wrap up loose ends and make room for something new.',
];

String readingFor(String sign, DateTime date) {
  final day = DateTime.utc(
    date.year,
    date.month,
    date.day,
  ).difference(DateTime.utc(2020)).inDays;
  final signIndex = signs.indexOf(sign);
  return dailyReadings[(day + signIndex * 7) % dailyReadings.length];
}

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
            leading: Text(
              symbols[sign] ?? '',
              style: const TextStyle(fontSize: 28),
            ),
            title: Text(sign),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('sign', sign);
              if (!context.mounted) return;
              Navigator.pushReplacement(
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

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key, required this.sign});

  final String sign;

  @override
  State<HoroscopeScreen> createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  TimeOfDay? _reminder;

  @override
  void initState() {
    super.initState();
    _loadReminder();
  }

  Future<void> _loadReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('reminder_hour');
    final minute = prefs.getInt('reminder_minute');
    if (hour != null && minute != null && mounted) {
      setState(() => _reminder = TimeOfDay(hour: hour, minute: minute));
    }
  }

  Future<void> _setReminder() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminder ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked == null) return;
    await NotificationService.requestPermission();
    await NotificationService.scheduleDaily(
      hour: picked.hour,
      minute: picked.minute,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminder_hour', picked.hour);
    await prefs.setInt('reminder_minute', picked.minute);
    if (!mounted) return;
    setState(() => _reminder = picked);
  }

  Future<void> _turnOffReminder() async {
    await NotificationService.cancelDaily();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('reminder_hour');
    await prefs.remove('reminder_minute');
    if (!mounted) return;
    setState(() => _reminder = null);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = '${now.day}/${now.month}/${now.year}';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sign),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Change sign',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignListScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                symbols[widget.sign] ?? '',
                style: const TextStyle(fontSize: 72),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(date, style: Theme.of(context).textTheme.labelLarge),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  readingFor(widget.sign, DateTime.now()),
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.alarm),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _reminder == null
                                ? 'Daily reminder is off'
                                : 'Daily reminder at ${_reminder!.format(context)}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        FilledButton.tonal(
                          onPressed: _setReminder,
                          child: Text(
                            _reminder == null ? 'Set reminder' : 'Change time',
                          ),
                        ),
                        if (_reminder != null) ...[
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _turnOffReminder,
                            child: const Text('Turn off'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

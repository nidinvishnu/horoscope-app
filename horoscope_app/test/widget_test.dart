import 'package:flutter_test/flutter_test.dart';
import 'package:horoscope_app/main.dart';

void main() {
  test('same sign and day always give the same reading', () {
    final day = DateTime(2026, 11, 7);
    expect(readingFor('Leo', day), readingFor('Leo', day));
  });

  test('reading changes from one day to the next', () {
    final today = DateTime(2026, 11, 7);
    final tomorrow = DateTime(2026, 11, 8);
    expect(readingFor('Leo', today), isNot(readingFor('Leo', tomorrow)));
  });

  test('different signs get different readings on the same day', () {
    final day = DateTime(2026, 11, 7);
    expect(readingFor('Aries', day), isNot(readingFor('Taurus', day)));
  });

  test('every sign has a symbol', () {
    for (final sign in signs) {
      expect(symbols.containsKey(sign), isTrue);
    }
  });
}
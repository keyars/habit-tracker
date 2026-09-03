import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/main.dart';

void main() {
  test('dateKey creates a stable local date key', () {
    expect(dateKey(DateTime(2026, 9, 3)), '2026-09-03');
  });

  test('habit stores completed dates', () {
    final habit = Habit(
      id: '1',
      name: 'Read',
      emoji: '📚',
      completedDates: {'2026-09-03'},
    );
    expect(habit.isComplete(DateTime(2026, 9, 3)), isTrue);
    expect(habit.completedDates.length, 1);
  });
}

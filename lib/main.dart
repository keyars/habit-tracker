import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = HabitStore();
  final habits = await store.load();
  runApp(HabitTrackerApp(store: store, habits: habits));
}

class HabitTrackerApp extends StatefulWidget {
  const HabitTrackerApp({super.key, required this.store, required this.habits});
  final HabitStore store;
  final List<Habit> habits;
  @override State<HabitTrackerApp> createState() => _HabitTrackerAppState();
}

class _HabitTrackerAppState extends State<HabitTrackerApp> {
  late List<Habit> habits;
  @override void initState() { super.initState(); habits = [...widget.habits]; }
  Future<void> persist() => widget.store.save(habits);
  void addHabit(String name, String emoji) {
    setState(() => habits = [...habits, Habit(id: DateTime.now().microsecondsSinceEpoch.toString(), name: name, emoji: emoji)]);
    persist();
  }
  void toggle(Habit habit) {
    final key = dateKey(DateTime.now());
    setState(() {
      final i = habits.indexWhere((h) => h.id == habit.id);
      final dates = {...habits[i].completedDates};
      dates.contains(key) ? dates.remove(key) : dates.add(key);
      habits[i] = habits[i].copyWith(completedDates: dates);
    });
    persist();
  }
  void remove(Habit habit) { setState(() => habits.removeWhere((h) => h.id == habit.id)); persist(); }
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Habit Tracker',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF3559E8), scaffoldBackgroundColor: const Color(0xFFF6F7FB)),
    home: HomePage(habits: habits, onAdd: addHabit, onToggle: toggle, onRemove: remove),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.habits, required this.onAdd, required this.onToggle, required this.onRemove});
  final List<Habit> habits;
  final void Function(String, String) onAdd;
  final void Function(Habit) onToggle;
  final void Function(Habit) onRemove;
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Habit Tracker', style: TextStyle(fontWeight: FontWeight.w800))),
    body: IndexedStack(index: tab, children: [TodayView(habits: widget.habits, onToggle: widget.onToggle, onRemove: widget.onRemove), InsightsView(habits: widget.habits)]),
    floatingActionButton: tab == 0 ? FloatingActionButton.extended(onPressed: () => _addHabit(context), icon: const Icon(Icons.add), label: const Text('New habit')) : null,
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (i) => setState(() => tab = i), destinations: const [
      NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Today'),
      NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Insights'),
    ]),
  );

  Future<void> _addHabit(BuildContext context) async {
    final controller = TextEditingController();
    String emoji = '🌱';
    await showModalBottomSheet<void>(context: context, isScrollControlled: true, showDragHandle: true, builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setSheetState) => Padding(
        padding: EdgeInsets.fromLTRB(24, 8, 24, MediaQuery.viewInsetsOf(sheetContext).bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Create a habit', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Habit name', hintText: 'Read for 20 minutes')),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(initialValue: emoji, decoration: const InputDecoration(labelText: 'Icon'), items: const ['🌱','📚','🏃','💧','🧘','💻','🥗','😴','✍️','🎸'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 22)))).toList(), onChanged: (v) => setSheetState(() => emoji = v ?? emoji)),
          const SizedBox(height: 18),
          FilledButton(onPressed: () { final name = controller.text.trim(); if (name.isEmpty) return; widget.onAdd(name, emoji); Navigator.pop(sheetContext); }, child: const Text('Create habit')),
        ]),
      ),
    ));
    controller.dispose();
  }
}

class TodayView extends StatelessWidget {
  const TodayView({super.key, required this.habits, required this.onToggle, required this.onRemove});
  final List<Habit> habits;
  final void Function(Habit) onToggle;
  final void Function(Habit) onRemove;
  @override Widget build(BuildContext context) {
    final completed = habits.where((h) => h.isComplete(DateTime.now())).length;
    final ratio = habits.isEmpty ? 0.0 : completed / habits.length;
    final best = habits.fold<int>(0, (b, h) => h.currentStreak > b ? h.currentStreak : b);
    return ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 120), children: [
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
        SizedBox(width: 78, height: 78, child: Stack(fit: StackFit.expand, children: [CircularProgressIndicator(value: ratio, strokeWidth: 8), Center(child: Text('${(ratio * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w800)))])),
        const SizedBox(width: 18),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_greeting(), style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 5), Text('Build a better day, one check at a time.', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text('$completed of ${habits.length} habits complete')])),
        Column(children: [Text('$best', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), const Text('streak', style: TextStyle(fontSize: 12))]),
      ]))),
      const SizedBox(height: 20),
      Text('Today', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      if (habits.isEmpty) Card(child: Padding(padding: const EdgeInsets.all(28), child: Column(children: [const Text('🌤️', style: TextStyle(fontSize: 44)), const SizedBox(height: 12), const Text('Start small', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text('Add one habit you would like to make automatic.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium)])))
      else ...habits.map((habit) => Dismissible(key: ValueKey(habit.id), direction: DismissDirection.endToStart, onDismissed: (_) => onRemove(habit), background: Container(margin: const EdgeInsets.only(bottom: 10), alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Theme.of(context).colorScheme.errorContainer), child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onErrorContainer)), child: Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), leading: CircleAvatar(radius: 24, child: Text(habit.emoji, style: const TextStyle(fontSize: 21))), title: Text(habit.name, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text('${habit.currentStreak} day streak'), trailing: IconButton.filledTonal(tooltip: habit.isComplete(DateTime.now()) ? 'Mark incomplete' : 'Mark complete', onPressed: () => onToggle(habit), icon: Icon(habit.isComplete(DateTime.now()) ? Icons.check : Icons.circle_outlined))))),
      const SizedBox(height: 20), const WeeklyRhythm(),
    ]);
  }
  static String _greeting() { final h = DateTime.now().hour; if (h < 12) return 'Good morning'; if (h < 17) return 'Good afternoon'; return 'Good evening'; }
}

class WeeklyRhythm extends StatelessWidget {
  const WeeklyRhythm({super.key});
  @override Widget build(BuildContext context) { final now = DateTime.now(); final days = List.generate(7, (i) => DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - i))); return Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Weekly rhythm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 14), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: days.map((d) => Column(children: [Text(['M','T','W','T','F','S','S'][d.weekday - 1]), const SizedBox(height: 8), CircleAvatar(radius: 16, child: Text('${d.day}', style: const TextStyle(fontSize: 11)))] )).toList())]))); }
}

class InsightsView extends StatelessWidget {
  const InsightsView({super.key, required this.habits});
  final List<Habit> habits;
  @override Widget build(BuildContext context) { final total = habits.fold<int>(0, (s, h) => s + h.completedDates.length); final best = habits.fold<int>(0, (b, h) => h.currentStreak > b ? h.currentStreak : b); return ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 40), children: [Text('Insights', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 6), const Text('Simple signals for better consistency.'), const SizedBox(height: 18), Row(children: [Expanded(child: MetricCard(label: 'Habits', value: '${habits.length}', icon: Icons.auto_awesome_outlined)), const SizedBox(width: 12), Expanded(child: MetricCard(label: 'Check-ins', value: '$total', icon: Icons.done_all_outlined))]), const SizedBox(height: 12), MetricCard(label: 'Best current streak', value: '$best days', icon: Icons.local_fire_department_outlined)]); }
}

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.label, required this.value, required this.icon});
  final String label; final String value; final IconData icon;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon), const SizedBox(height: 12), Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)), Text(label)]));
}

class Habit {
  const Habit({required this.id, required this.name, required this.emoji, this.completedDates = const <String>{}});
  final String id; final String name; final String emoji; final Set<String> completedDates;
  bool isComplete(DateTime date) => completedDates.contains(dateKey(date));
  int get currentStreak { var day = DateTime.now(); if (!isComplete(day)) day = day.subtract(const Duration(days: 1)); var count = 0; while (isComplete(day)) { count++; day = day.subtract(const Duration(days: 1)); } return count; }
  Habit copyWith({Set<String>? completedDates}) => Habit(id: id, name: name, emoji: emoji, completedDates: completedDates ?? this.completedDates);
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'emoji': emoji, 'completedDates': completedDates.toList()};
  factory Habit.fromJson(Map<String, dynamic> json) => Habit(id: json['id'] as String, name: json['name'] as String, emoji: json['emoji'] as String? ?? '🌱', completedDates: Set<String>.from((json['completedDates'] as List<dynamic>? ?? const []).cast<String>()));
}

String dateKey(DateTime date) => '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

class HabitStore {
  static const key = 'habit_tracker_habits_v1';
  Future<List<Habit>> load() async { final prefs = SharedPreferencesAsync(); final raw = await prefs.getString(key); if (raw == null || raw.isEmpty) return []; try { final data = jsonDecode(raw) as List<dynamic>; return data.map((e) => Habit.fromJson(e as Map<String, dynamic>)).toList(); } catch (_) { return []; } }
  Future<void> save(List<Habit> habits) async { final prefs = SharedPreferencesAsync(); await prefs.setString(key, jsonEncode(habits.map((h) => h.toJson()).toList())); }
}

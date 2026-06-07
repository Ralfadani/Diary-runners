// lib/screens/training_plan_screen.dart

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class TrainingPlanScreen extends StatefulWidget {
  final VoidCallback? onPlanCreated;

  const TrainingPlanScreen({Key? key, this.onPlanCreated}) : super(key: key);

  @override
  _TrainingPlanScreenState createState() => _TrainingPlanScreenState();
}

class _TrainingPlanScreenState extends State<TrainingPlanScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Data Event disimpan disini
  late Map<DateTime, List<Map<String, dynamic>>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {};
  }

  // --- HELPER FUNCTIONS ---

  void _addEventToMap(DateTime date, Map<String, dynamic> event) {
    final key = DateTime(date.year, date.month, date.day);
    if (_events[key] != null) {
      _events[key]!.add(event);
    } else {
      _events[key] = [event];
    }
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _events[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Jadwal Latihan',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepOrange),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAdvancedAICoach,
        backgroundColor: Colors.deepOrange,
        icon: const Icon(Icons.psychology, color: Colors.white),
        label: const Text("AI Coach",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // KALENDER
          Card(
            margin: const EdgeInsets.all(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 2,
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                    color: Colors.deepOrange, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(0.3),
                    shape: BoxShape.circle),
                markerDecoration: const BoxDecoration(
                    color: Colors.blueAccent, shape: BoxShape.circle),
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _getEventsForDay,
            ),
          ),

          // TITLE HARI INI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  DateFormat('EEEE, d MMMM')
                      .format(_selectedDay ?? DateTime.now()),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            ),
          ),

          // LIST LATIHAN
          Expanded(
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // 🧠 LOGIKA AI COACH (DENGAN TARGET WAKTU)
  // ======================================================

  void _showAdvancedAICoach() {
    String targetDistance = '5K';
    String currentAbility = 'Pemula (<30km/minggu)';
    List<int> selectedWeekdays = [2, 4, 6];
    DateTime? selectedRaceDate;

    // Controller untuk Target Waktu
    TextEditingController hourController = TextEditingController();
    TextEditingController minController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            String dateText = selectedRaceDate == null
                ? "Pilih Tanggal"
                : DateFormat('d MMMM yyyy').format(selectedRaceDate!);

            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 24,
                  left: 24,
                  right: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.deepOrange),
                        SizedBox(width: 8),
                        Text("AI COACH",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 1. PILIH JARAK
                    const Text("Target Lomba (Race):",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: targetDistance,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ['5K', '10K', 'Half Marathon', 'Marathon']
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) =>
                          setSheetState(() => targetDistance = val!),
                    ),

                    const SizedBox(height: 16),

                    // --- [BARU] TARGET WAKTU ---
                    const Text("Target Waktu (Opsional):",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: hourController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "0",
                              labelText: "Jam",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: minController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "00",
                              labelText: "Menit",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 3. PILIH TANGGAL RACE
                    const Text("Tanggal Lomba:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().add(const Duration(days: 60)),
                          firstDate:
                              DateTime.now().add(const Duration(days: 14)),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setSheetState(() => selectedRaceDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dateText,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: selectedRaceDate == null
                                        ? Colors.grey[600]
                                        : Colors.black87)),
                            const Icon(Icons.calendar_today,
                                size: 20, color: Colors.deepOrange),
                          ],
                        ),
                      ),
                    ),
                    if (selectedRaceDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          "Sisa waktu: ${selectedRaceDate!.difference(DateTime.now()).inDays ~/ 7} Minggu latihan",
                          style: const TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // 4. KEMAMPUAN SAAT INI
                    const Text("Level Kemampuan:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: currentAbility,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      items: [
                        'Pemula (<30km/minggu)',
                        'Menengah (30-50km/minggu)',
                        'Lanjutan (>50km/minggu)'
                      ]
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) =>
                          setSheetState(() => currentAbility = val!),
                    ),

                    const SizedBox(height: 16),

                    // 5. PILIH HARI SPESIFIK
                    const Text("Hari Latihan:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: List.generate(7, (index) {
                        int dayCode = index + 1;
                        String dayName = [
                          'Sen',
                          'Sel',
                          'Rab',
                          'Kam',
                          'Jum',
                          'Sab',
                          'Min'
                        ][index];
                        bool isSelected = selectedWeekdays.contains(dayCode);

                        return FilterChip(
                          label: Text(dayName),
                          selected: isSelected,
                          selectedColor: Colors.deepOrange.withOpacity(0.2),
                          checkmarkColor: Colors.deepOrange,
                          labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.deepOrange
                                  : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                          onSelected: (selected) {
                            setSheetState(() {
                              if (selected) {
                                selectedWeekdays.add(dayCode);
                              } else {
                                if (selectedWeekdays.length > 2) {
                                  selectedWeekdays.remove(dayCode);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Minimal pilih 2 hari latihan")));
                                }
                              }
                              selectedWeekdays.sort();
                            });
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 32),

                    // TOMBOL GENERATE
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedRaceDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Mohon pilih tanggal lomba!")));
                            return;
                          }

                          // Format Target Time
                          String targetTimeStr = "";
                          if (hourController.text.isNotEmpty ||
                              minController.text.isNotEmpty) {
                            String h = hourController.text.isEmpty
                                ? "0"
                                : hourController.text;
                            String m = minController.text.isEmpty
                                ? "00"
                                : minController.text;
                            targetTimeStr = "${h}h ${m}m";
                          }

                          Navigator.pop(context);
                          _generateSpecificPlan(
                              targetDistance,
                              currentAbility,
                              selectedWeekdays,
                              selectedRaceDate!,
                              targetTimeStr);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text("BUAT JADWAL",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ALGORITMA PEMBUAT JADWAL DINAMIS
  void _generateSpecificPlan(String distance, String level, List<int> days,
      DateTime raceDate, String targetTime) {
    setState(() {
      _events.clear();
    });

    DateTime startDate = DateTime.now();
    int totalDays = raceDate.difference(startDate).inDays;
    int weeks = (totalDays / 7).floor();

    int minWeeks = distance == 'Marathon' ? 12 : 4;
    if (weeks < minWeeks) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Waktu terlalu singkat! Min $minWeeks minggu untuk $distance.")),
      );
      return;
    }

    double baseDistance = 3.0;
    if (level.contains('Menengah')) baseDistance = 5.0;
    if (level.contains('Lanjutan')) baseDistance = 8.0;

    for (int w = 0; w < weeks; w++) {
      for (int i = 0; i < days.length; i++) {
        int dayIndex = days[i];
        int currentWeekday = startDate.weekday;
        int daysToAdd = (dayIndex - currentWeekday + (w * 7));
        if (daysToAdd < 0) daysToAdd += 7;

        DateTime workoutDate = startDate.add(Duration(days: daysToAdd));
        if (workoutDate.isAfter(raceDate)) continue;

        String title = "Lari";
        String desc = "";
        String type = "run";

        double progressFactor =
            (w < weeks - 2) ? (1.0 + (w * 0.1)) : (1.0 - ((weeks - w) * 0.1));

        if (i == 0) {
          title = "Interval Run";
          int reps = 4 + (w ~/ 2);
          desc =
              "Pemanasan, $reps x 400m speed (Pace target race), pendinginan.";
        } else if (i == days.length - 1) {
          title = "Long Run";
          double dist = (baseDistance * 1.5 * progressFactor);
          double maxDist = distance == 'Marathon'
              ? 32.0
              : (distance == 'Half Marathon' ? 18.0 : 12.0);
          if (dist > maxDist) dist = maxDist;

          desc = "Lari ${dist.toStringAsFixed(1)} km pace santai (Zone 2).";
        } else {
          title = "Easy Run";
          double dist = (baseDistance * progressFactor);
          desc = "Lari santai ${dist.toStringAsFixed(1)} km recovery.";
        }

        if (w == weeks - 1) {
          title = "Tapering";
          desc = "Lari ringan 2-3km untuk menjaga kondisi otot.";
        }

        _addEventToMap(workoutDate,
            {"title": title, "desc": desc, "type": type, "isDone": false});
      }
    }

    // EVENT RACE DAY
    String raceDesc = "Hari pembuktian! Persiapkan mental & fisik.";
    if (targetTime.isNotEmpty) {
      raceDesc += "\n🎯 Target Waktu: $targetTime";
    }

    _addEventToMap(raceDate, {
      "title": "🏁 RACE DAY: $distance",
      "desc": raceDesc,
      "type": "race",
      "isDone": false
    });

    if (widget.onPlanCreated != null) {
      widget.onPlanCreated!();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Plan $distance ($weeks Minggu) berhasil dibuat!")),
    );
  }

  // ======================================================
  // UI LIST CARD
  // ======================================================

  Widget _buildEventList() {
    final events = _getEventsForDay(_selectedDay!);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.grey[100], shape: BoxShape.circle),
              child: Icon(Icons.bed_rounded, size: 40, color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            const Text("Rest Day",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54)),
            const SizedBox(height: 4),
            const Text("Istirahat untuk pemulihan otot.",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) => _buildWorkoutCard(events[index]),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> event) {
    bool isRace = event['type'] == 'race';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isRace ? Border.all(color: Colors.amber, width: 2) : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isRace ? Colors.amber[100] : Colors.deepOrange[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isRace ? Icons.emoji_events : Icons.directions_run,
            color: isRace ? Colors.amber[800] : Colors.deepOrange,
          ),
        ),
        title: Text(event['title'],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text(event['desc'],
              style: TextStyle(color: Colors.grey[600], height: 1.3)),
        ),
        trailing: isRace
            ? null
            : Checkbox(
                value: event['isDone'],
                activeColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onChanged: (val) {
                  setState(() {
                    event['isDone'] = val;
                  });
                },
              ),
      ),
    );
  }
}

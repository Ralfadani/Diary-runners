import 'dart:async';
// Untuk FontFeature
import 'package:flutter/material.dart';
import 'package:runners_hub/screens/detail_activity_screen.dart';

class RecordActivityScreen extends StatefulWidget {
  const RecordActivityScreen({Key? key}) : super(key: key);

  @override
  _RecordActivityScreenState createState() => _RecordActivityScreenState();
}

class _RecordActivityScreenState extends State<RecordActivityScreen>
    with SingleTickerProviderStateMixin {
  // --- STATE (TIDAK BERUBAH) ---
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  double _distance = 0.00;
  double _calories = 0;
  String _currentPace = "0'00\"";

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _distance += 0.004;
        _calories += 0.18;
        _currentPace =
            "5'${(45 + (_seconds % 10)).toString().padLeft(2, '0')}\"";
      });
    });
  }

  void _pauseTimer() {
    if (_timer != null) _timer!.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  void _stopTimer() {
    if (_timer != null) _timer!.cancel();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DetailActivityScreen()));
  }

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return h > 0
        ? "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}"
        : "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. MAP FULL SCREEN
          Image.asset(
            'assets/images/maps.jpeg',
            fit: BoxFit.cover,
          ),

          // 2. ANIMASI LOKASI (PULSE KECIL)
          Center(
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80 + (_pulseAnimation.value * 30), // Diperkecil
                      height: 80 + (_pulseAnimation.value * 30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue
                            .withOpacity(0.2 - (_pulseAnimation.value * 0.2)),
                      ),
                    ),
                    Container(
                      width: 18, // Dot lebih kecil
                      height: 18,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF4285F4),
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2))
                          ]),
                    ),
                  ],
                );
              },
            ),
          ),

          // 3. TOP BAR (GPS STATUS - SIMPLE)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Chip GPS Kecil Transparan
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10)
                      ]),
                  child: const Row(
                    children: [
                      Icon(Icons.near_me_rounded,
                          color: Color(0xFF4285F4), size: 14),
                      SizedBox(width: 6),
                      Text("GPS ON",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                // Tombol Settings Kecil
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10)
                      ]),
                  child: const Icon(Icons.layers_outlined,
                      color: Colors.black87, size: 18),
                )
              ],
            ),
          ),

          // 4. BOTTOM FLOATING HUD (COMPACT)
          // Ini adalah panel statistik yang diperkecil
          Positioned(
            bottom: 30, // Mengambang 30px dari bawah
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95), // Hampir solid
                borderRadius: BorderRadius.circular(24), // Sudut sangat bulat
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Hanya setinggi konten
                children: [
                  // BARIS 1: TIMER & STATS DALAM SATU ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TIMER (Kiri)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DURATION",
                            style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1),
                          ),
                          Text(
                            _formatTime(_seconds),
                            style: const TextStyle(
                              fontSize: 32, // Ukuran font diperkecil drastis
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              letterSpacing: -1,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),

                      // STATS (Kanan - Condensed)
                      Row(
                        children: [
                          _buildMiniStat("KM", _distance.toStringAsFixed(2)),
                          const SizedBox(width: 16),
                          _buildMiniStat("PACE", _currentPace),
                          const SizedBox(width: 16),
                          _buildMiniStat("CAL", _calories.toInt().toString()),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 16),
                  Divider(height: 1, color: Colors.grey.shade200),
                  const SizedBox(height: 16),

                  // BARIS 2: CONTROLS (KECIL)
                  _buildCompactControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER KHUSUS COMPACT ---

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16, // Font angka statistik kecil
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactControls() {
    // 1. BELUM MULAI (Tombol Kecil)
    if (!_isRunning && !_isPaused) {
      return Center(
        child: GestureDetector(
          onTap: _startTimer,
          child: Container(
            width: 56, // Ukuran FAB standar
            height: 56,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87, // Ganti ke Hitam/Orange agar kontras
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 28),
          ),
        ),
      );
    }

    // 2. SEDANG LARI
    if (_isRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTinyCircleButton(Icons.lock_outline, Colors.grey.shade100,
              Colors.grey.shade400, () {}),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: _pauseTimer,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber[400],
                  boxShadow: [
                    BoxShadow(
                        color: Colors.amber.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]),
              child: const Icon(Icons.pause_rounded,
                  color: Colors.black87, size: 28),
            ),
          ),
          const SizedBox(width: 24),
          _buildTinyCircleButton(Icons.camera_alt_outlined,
              Colors.grey.shade100, Colors.grey.shade400, () {}),
        ],
      );
    }

    // 3. PAUSE (RESUME / FINISH)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onLongPress: _stopTimer,
          child: Container(
            width: 48, // Lebih kecil dari tombol play
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.red.shade100, width: 1),
            ),
            child: const Icon(Icons.stop_rounded,
                color: Colors.redAccent, size: 24),
          ),
        ),
        const SizedBox(width: 32),
        GestureDetector(
          onTap: _startTimer,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black87,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ]),
            child: const Icon(Icons.play_arrow_rounded,
                color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildTinyCircleButton(
      IconData icon, Color bg, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}

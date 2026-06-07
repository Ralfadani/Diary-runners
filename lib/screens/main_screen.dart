// lib/screens/main_screen.dart

import 'package:flutter/material.dart';

// Import semua halaman yang dibutuhkan
import 'package:runners_hub/screens/home_screen.dart';
import 'package:runners_hub/screens/training_plan_screen.dart'; // Pindah ke posisi 1
import 'package:runners_hub/screens/record_activity_screen.dart'; // Pindah ke posisi 2 (Baru)
import 'package:runners_hub/screens/routes_screen.dart';
import 'package:runners_hub/screens/more_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // State untuk status Plan (Aktif/Tidak)
  bool _hasActivePlan = false;

  // Fungsi callback jika plan dibuat di TrainingPlanScreen
  void _activatePlan() {
    setState(() {
      _hasActivePlan = true;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // DAFTAR HALAMAN (URUTAN BARU)
  List<Widget> _getScreens() {
    return [
      // 0. HOME
      HomeScreen(
        onTabChange: _onItemTapped,
        hasActivePlan: _hasActivePlan,
      ),

      // 1. LATIHAN (Sebelumnya Acara)
      TrainingPlanScreen(
        onPlanCreated: _activatePlan,
      ),

      // 2. RECORD / REKAM (Sebelumnya Latihan)
      const RecordActivityScreen(),

      // 3. RUTE
      const RoutesScreen(),

      // 4. LAINNYA
      const MoreScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan IndexedStack agar halaman tidak reload saat pindah tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _getScreens(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Tab 0
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),

          // Tab 1 (Dulu Acara, Sekarang Latihan)
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Latihan',
          ),

          // Tab 2 (Dulu Latihan, Sekarang Record)
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_checked), // Ikon tombol rekam
            label: 'Rekam',
          ),

          // Tab 3
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'Rute',
          ),

          // Tab 4
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded), // Ikon menu kotak-kotak
            label: 'Lainnya',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Agar 5 item muat sejajar
        onTap: _onItemTapped,
      ),
    );
  }
}

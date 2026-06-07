import 'package:flutter/material.dart';

import 'package:runners_hub/screens/detail_profile_screen.dart';
import 'package:runners_hub/screens/outfit_screen.dart';
import 'package:runners_hub/screens/notification_screen.dart';
import 'package:runners_hub/screens/detail_activity_screen.dart';
import 'package:runners_hub/screens/event_screen.dart';
import 'package:runners_hub/screens/history_screen.dart';
import 'package:runners_hub/services/auth_service.dart';
import 'package:runners_hub/screens/performance_analytics_screen.dart';
import 'package:runners_hub/screens/shoe_intelligence_screen.dart';
import 'package:runners_hub/screens/my_event_detail_screen.dart';
import 'package:runners_hub/screens/add_event_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;
  final bool hasActivePlan;

  const HomeScreen({
    Key? key,
    required this.onTabChange,
    required this.hasActivePlan,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _userName = "Runner";
  List<Map<String, dynamic>> _myEvents = [
    {
      "name": "BTN Jakarta International Marathon",
      "date": "Sun, 14 Jun 2026",
      "category": "42,20 km",
      "estimatedTime": "4:31:27",
      "daysLeft": 27,
      "image": null
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await AuthService.getUserName();
    setState(() {
      _userName = name;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. APP BAR
          _buildSliverAppBar(),

          // 2. ISI DASHBOARD
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // --- BAGIAN 1: SAPAAN & SMART INSIGHTS (BI) ---
                  _buildGreetingSection(),
                  const SizedBox(height: 24),
                  _buildSmartInsightsSection(),

                  const SizedBox(height: 32),

                  // --- BAGIAN 2: JADWAL LATIHAN (COMPACT: HARI INI & BESOK) ---
                  _buildSectionHeader(
                    title: "Jadwal Latihan",
                    // Hapus action text jika ingin lebih bersih, atau biarkan
                    actionText: widget.hasActivePlan ? null : "Buat Baru",
                    onActionTap: () => widget.onTabChange(1),
                  ),
                  const SizedBox(height: 12),

                  // Logika Tampilan Jadwal Baru
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: widget.hasActivePlan
                        ? _buildCompactScheduleRow() // Tampilan Hari Ini & Besok
                        : _buildCompactNoPlanCard(), // Tampilan Kosong Kecil
                  ),

                  const SizedBox(height: 32),

                  // --- BAGIAN 3: AKTIVITAS TERAKHIR ---
                  _buildSectionHeader(
                    title: "Aktivitas Terakhir",
                    actionText: "Riwayat >",
                    onActionTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildLastActivityCard(),

                  const SizedBox(height: 32),

                  // --- BAGIAN 4: STATISTIK ---
                  _buildSectionHeader(title: "Statistik Minggu Ini"),
                  const SizedBox(height: 12),
                  _buildWeeklyBarChart(),

                  const SizedBox(height: 32),

                  // --- BAGIAN 5: EVENT MENDATANG (YANG DIIKUTI) ---
                  _buildSectionHeader(
                    title: "Event Mendatang",
                    actionText: _myEvents.isEmpty ? null : "+ Tambah Event",
                    onActionTap: _myEvents.isEmpty ? null : () => _navigateToAddEvent(context),
                  ),
                  const SizedBox(height: 12),
                  _buildUpcomingEventsList(),

                  const SizedBox(height: 32),



                  // --- BAGIAN 5: JELAJAHI ---
                  _buildSectionHeader(title: "Jelajahi"),
                  const SizedBox(height: 12),
                  _buildHorizontalExploreMenu(),

                  const SizedBox(height: 100), // Padding Bawah
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // WIDGET UTAMA
  // ==================================================

  // --- 1. JADWAL LATIHAN COMPACT (HARI INI & BESOK) ---
  Widget _buildCompactScheduleRow() {
    return Row(
      children: [
        // Kartu Hari Ini (Active Style)
        Expanded(
          child: _buildDailyCard(
            day: "HARI INI",
            title: "Interval Run",
            subtitle: "35 Min • 5 km",
            icon: Icons.directions_run_rounded,
            isActive: true, // Warna Orange
            onTap: () => widget.onTabChange(2),
          ),
        ),
        const SizedBox(width: 16),
        // Kartu Besok (Inactive/Preview Style)
        Expanded(
          child: _buildDailyCard(
            day: "BESOK",
            title: "Recovery Run",
            subtitle: "20 Min • 3 km",
            icon: Icons.favorite_rounded,
            isActive: false, // Warna Putih/Abu
            onTap: () {
              // Aksi untuk melihat detail besok (opsional)
            },
          ),
        ),
      ],
    );
  }

  // Helper untuk membuat Kartu Harian Kecil
  Widget _buildDailyCard({
    required String day,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130, // Tinggi tetap agar rapi
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? Colors.deepOrange : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: isActive
                    ? Colors.deepOrange.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6))
          ],
          border: isActive ? null : Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: isActive ? Colors.white70 : Colors.grey[400],
                      letterSpacing: 1),
                ),
                if (isActive)
                  const Icon(Icons.play_circle_fill_rounded,
                      color: Colors.white, size: 20)
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon,
                    color: isActive ? Colors.white : Colors.deepOrange,
                    size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isActive ? Colors.white : Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isActive
                          ? Colors.white.withOpacity(0.9)
                          : Colors.grey[500]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- 2. NO PLAN CARD (COMPACT VERSION) ---
  Widget _buildCompactNoPlanCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit_calendar_rounded,
                color: Colors.deepOrange, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Belum Ada Jadwal",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Colors.black87),
                ),
                Text(
                  "Buat rencana latihanmu sekarang.",
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.add_rounded,
                  size: 20, color: Colors.deepOrange),
              onPressed: () => widget.onTabChange(1),
            ),
          )
        ],
      ),
    );
  }

  // --- WIDGET PENDUKUNG LAINNYA ---

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF8F9FD),
      elevation: 0,
      pinned: true,
      floating: false,
      expandedHeight: 70,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(color: const Color(0xFFF8F9FD)),
      ),
      title: const Row(
        children: [
          Icon(Icons.run_circle_outlined, color: Colors.deepOrange, size: 30),
          SizedBox(width: 8),
          Text(
            'Diary Runners',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                fontSize: 20),
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()));
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Stack(
              children: [
                const Icon(Icons.notifications_outlined,
                    color: Colors.black87, size: 24),
                Positioned(
                    right: 3,
                    top: 3,
                    child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 1.5)))),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DetailProfileScreen()));
            },
            child: Hero(
              tag: 'profile-avatar-hero',
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.deepOrange.withOpacity(0.5), width: 2)),
                child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(Icons.face_rounded,
                        color: Colors.white, size: 22)),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rabu, 26 Nov',
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Hi, $_userName 👋',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87)),
      ],
    );
  }

  Widget _buildSectionHeader(
      {required String title, String? actionText, VoidCallback? onActionTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87)),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(actionText,
                  style: const TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 12)),
            ),
          ),
      ],
    );
  }

  Widget _buildLastActivityCard() {
    if (!widget.hasActivePlan) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.withOpacity(0.1))),
        child: Center(
            child: Text("Tidak ada aktivitas terakhir",
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontStyle: FontStyle.italic))),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DetailActivityScreen()));
      },
      child: Container(
        height: 110,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5))
            ]),
        child: Row(
          children: [
            Container(
              width: 110,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24)),
                image: DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1524661135-423995f22d0b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80"),
                    fit: BoxFit.cover),
              ),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomLeft: Radius.circular(24)),
                      color: Colors.black.withOpacity(0.1)),
                  child: const Center(
                      child: Icon(Icons.location_on_rounded,
                          color: Colors.white, size: 28))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Lari Pagi Santai",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87)),
                        Text("Hari Ini",
                            style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMiniStatItem("5.02", "km"),
                        _buildVerticalLine(),
                        _buildMiniStatItem("32:15", "waktu"),
                        _buildVerticalLine(),
                        _buildMiniStatItem("6'25\"", "pace"),
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

  Widget _buildWeeklyBarChart() {
    final List<double> weeklyData = [2.5, 4.0, 0.0, 5.2, 3.0, 8.5, 0.0];
    final List<String> days = ["S", "S", "R", "K", "J", "S", "M"];
    double maxVal = 8.5;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 10))
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.auto_graph_rounded,
                        size: 16, color: Colors.deepOrange),
                    const SizedBox(width: 6),
                    Text("Total Jarak".toUpperCase(),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w700))
                  ]),
                  const SizedBox(height: 8),
                  Text(widget.hasActivePlan ? "23.2 km" : "0.0 km",
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87)),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: const Row(children: [
                  Icon(Icons.arrow_upward_rounded,
                      color: Colors.green, size: 14),
                  SizedBox(width: 4),
                  Text("12%",
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w800,
                          fontSize: 13))
                ]),
              )
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                double relativeHeight = weeklyData[index] / maxVal;
                if (!widget.hasActivePlan) relativeHeight = 0.05;
                bool isToday = index == 5;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isToday && widget.hasActivePlan)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text("${weeklyData[index]}",
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange))),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutBack,
                      width: 16,
                      height: (100 * relativeHeight) < 6
                          ? 6
                          : (100 * relativeHeight),
                      decoration: BoxDecoration(
                        color: weeklyData[index] > 0 && widget.hasActivePlan
                            ? (isToday
                                ? Colors.deepOrange
                                : Colors.deepOrangeAccent.withOpacity(0.5))
                            : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(days[index],
                        style: TextStyle(
                            color: isToday ? Colors.black87 : Colors.grey[400],
                            fontSize: 12,
                            fontWeight:
                                isToday ? FontWeight.w900 : FontWeight.w600)),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  // ==================================================
  // WIDGET BI & ANALITIK PINTAR (Dashboard Access Points)
  // ==================================================
  Widget _buildSmartInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: "Smart Insights (BI)"),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              // Titik Akses A: Kartu "Performance Intelligence"
              SizedBox(
                width: 300,
                child: _buildDashboardBICard(
                  title: "Performance Insight",
                  subtitle: "Grafik mingguanmu naik 20%! Prediksi waktu 10K kamu semakin tajam.",
                  icon: Icons.trending_up_rounded,
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PerformanceAnalyticsScreen()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Titik Akses B: Kartu "Gear Health"
              SizedBox(
                width: 300,
                child: _buildDashboardBICard(
                  title: "Gear Condition (Nike Pegasus 40)",
                  subtitle: "Bantalan sepatu kritis (sisa adaptif 50km). Waktunya rotasi sepatu.",
                  icon: Icons.do_not_step_rounded,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShoeIntelligenceScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardBICard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalExploreMenu() {
    final List<Map<String, dynamic>> menuItems = [
      {
        "title": "Event Lari",
        "subtitle": "Ikuti lomba",
        "icon": Icons.emoji_events_outlined,
        "color": Colors.orange,
        "bg": Colors.orange.shade50,
        "action": () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventScreen()));
        }
      },
      {
        "title": "Cari Rute",
        "subtitle": "Jelajah peta",
        "icon": Icons.explore_outlined,
        "color": Colors.blue,
        "bg": Colors.blue.shade50,
        "action": () => widget.onTabChange(3)
      },
      {
        "title": "Outfit",
        "subtitle": "Gaya lari",
        "icon": Icons.checkroom_outlined,
        "color": Colors.purple,
        "bg": Colors.purple.shade50,
        "action": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OutfitScreen()));
        }
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menuItems.length,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: item['action'],
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: newMethod(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: item['bg'], shape: BoxShape.circle),
                        child:
                            Icon(item['icon'], color: item['color'], size: 24)),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text(item['subtitle'],
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: Colors.grey[500]))
                        ])
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration newMethod() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ]);
  }

  Widget _buildMiniStatItem(String val, String label) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(val,
          style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: Colors.black87)),
      Text(label,
          style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500))
    ]);
  }

  Widget _buildVerticalLine() {
    return Container(height: 20, width: 1, color: Colors.grey.shade200);
  }

  Widget _buildUpcomingEventsList() {
    if (_myEvents.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5)
            )
          ]
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.flag_outlined, size: 28, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            const Text(
              "No events added",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black87
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tambahkan lomba lari atau event lain ke kalendermu. Cari event atau buat kalendermu sendiri.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5), // Biru (Garmin style)
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventScreen()),
                  );
                },
                child: const Text("Cari Event", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _navigateToAddEvent(context),
                child: const Text("Buat Event Manual", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _myEvents.length,
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          final event = _myEvents[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyEventDetailScreen(eventData: event),
                ),
              );
            },
            child: Container(
              width: 300,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // Light background
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 5)
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text(
                      event['daysLeft'] != null ? "IN ${event['daysLeft']} DAYS" : "MENDATANG",
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Orange Circle Icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.deepOrange, // Orange
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.directions_run_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      // Text Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                height: 1.2
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              event['date'],
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallbackEventIcon() {
    return Container(
      color: Colors.deepOrange.shade50,
      child: const Center(
        child: Icon(Icons.emoji_events, color: Colors.deepOrange, size: 40),
      ),
    );
  }

  Future<void> _navigateToAddEvent(BuildContext context) async {
    final newEvent = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEventScreen()),
    );
    if (newEvent != null) {
      setState(() {
        _myEvents.insert(0, newEvent as Map<String, dynamic>);
      });
    }
  }

  String _getMonth(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "Mei", "Jun", "Jul", "Ags", "Sep", "Okt", "Nov", "Des"];
    return months[month - 1];
  }
}

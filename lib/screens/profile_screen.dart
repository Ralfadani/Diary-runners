// lib/screens/create_profile_screen.dart

import 'package:flutter/material.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  String? selectedGoal;
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lengkapi Profil Pelari"),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sedikit lagi!",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
            Text(
              "Kami butuh data ini untuk membuat training plan yang personal untukmu.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Input Berat Badan
            const Text("Berat Badan (kg)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Contoh: 65",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: const Icon(Icons.monitor_weight_outlined),
              ),
            ),
            const SizedBox(height: 20),

            // Input Tinggi Badan
            const Text("Tinggi Badan (cm)",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Contoh: 170",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: const Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown Target
            const Text("Target Lari Utama",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedGoal,
              items: const [
                DropdownMenuItem(
                    value: "weight_loss",
                    child: Text("Menurunkan Berat Badan")),
                DropdownMenuItem(value: "5k", child: Text("Tamat Lari 5K")),
                DropdownMenuItem(
                    value: "marathon", child: Text("Persiapan Marathon")),
                DropdownMenuItem(
                    value: "health", child: Text("Kesehatan Jantung")),
              ],
              onChanged: (val) => setState(() => selectedGoal = val),
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              hint: const Text("Pilih Target"),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Simulasi simpan data berhasil
                  // Kirim sinyal 'true' kembali ke halaman Home
                  Navigator.pop(context, true);
                },
                child: const Text("SIMPAN PROFIL",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

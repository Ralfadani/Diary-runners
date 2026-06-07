import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("Keamanan",
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ganti Kata Sandi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            _buildPasswordField("Kata Sandi Lama"),
            const SizedBox(height: 16),
            _buildPasswordField("Kata Sandi Baru"),
            const SizedBox(height: 16),
            _buildPasswordField("Konfirmasi Kata Sandi Baru"),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Kata sandi diperbarui!")));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.deepOrange),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("GANTI KATA SANDI",
                    style: TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 20),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Login Biometrik",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Gunakan FaceID / Fingerprint untuk login"),
              value: _biometricEnabled,
              activeThumbColor: Colors.deepOrange,
              onChanged: (val) => setState(() => _biometricEnabled = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

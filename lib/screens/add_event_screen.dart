import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController(text: "Running");
  final TextEditingController _categoryController = TextEditingController(); // e.g. 42.20 km
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController(); // e.g. 05:00 AM
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _goalTimeController = TextEditingController(); // e.g. 04:30:00
  final TextEditingController _websiteController = TextEditingController();

  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black87, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepOrange, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day} ${_getMonth(picked.month)} ${picked.year}";
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepOrange,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _startTimeController.text = picked.format(context);
      });
    }
  }

  String _getMonth(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      // Calculate days left
      int? daysLeft;
      if (_selectedDate != null) {
        final now = DateTime.now();
        final difference = _selectedDate!.difference(DateTime(now.year, now.month, now.day)).inDays;
        daysLeft = difference > 0 ? difference : 0;
      }

      final newEvent = {
        "name": _nameController.text,
        "date": _dateController.text,
        "category": _categoryController.text.isNotEmpty ? _categoryController.text : "Distance not set",
        "estimatedTime": _goalTimeController.text.isNotEmpty ? _goalTimeController.text : "-",
        "daysLeft": daysLeft,
        "image": null, // Can add dummy or leave null
        "type": _typeController.text.isNotEmpty ? _typeController.text : "Running",
        "startTime": _startTimeController.text.isNotEmpty ? _startTimeController.text : "-",
        "location": _locationController.text.isNotEmpty ? _locationController.text : "-",
        "website": _websiteController.text.isNotEmpty ? _websiteController.text : "-",
      };

      Navigator.pop(context, newEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FD),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.deepOrange, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tambah Event",
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detail Event Manual",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  "Isi detail event di bawah ini. Informasi ini akan ditampilkan di halaman detail event Anda.",
                  style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 24),

                // Name
                _buildTextField(
                  controller: _nameController,
                  label: "Nama Event",
                  icon: Icons.emoji_events_outlined,
                  validator: (val) => val == null || val.isEmpty ? "Nama event wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // Date
                _buildTextField(
                  controller: _dateController,
                  label: "Tanggal Event",
                  icon: Icons.calendar_month_outlined,
                  readOnly: true,
                  onTap: _pickDate,
                  validator: (val) => val == null || val.isEmpty ? "Tanggal wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // Distance / Category
                _buildTextField(
                  controller: _categoryController,
                  label: "Jarak Lari / Kategori (Misal: 10K, HM, 42.20 km)",
                  icon: Icons.directions_run_rounded,
                ),
                const SizedBox(height: 16),

                // Start Time
                _buildTextField(
                  controller: _startTimeController,
                  label: "Waktu Mulai (Local Start Time)",
                  icon: Icons.access_time_rounded,
                  readOnly: true,
                  onTap: _pickTime,
                ),
                const SizedBox(height: 16),

                // Location
                _buildTextField(
                  controller: _locationController,
                  label: "Lokasi (Misal: Jakarta, ID)",
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),

                // Goal Time
                _buildTextField(
                  controller: _goalTimeController,
                  label: "Target Waktu / Goal Time (Misal: 04:30:00)",
                  icon: Icons.timer_outlined,
                ),
                const SizedBox(height: 16),

                // Event Type
                _buildTextField(
                  controller: _typeController,
                  label: "Tipe Event (Misal: Running)",
                  icon: Icons.merge_type_rounded,
                ),
                const SizedBox(height: 16),

                // Website
                _buildTextField(
                  controller: _websiteController,
                  label: "Website / Tautan Informasi",
                  icon: Icons.link_rounded,
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _saveEvent,
                    child: const Text(
                      "Simpan Event",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.normal),
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 1.5),
        ),
      ),
    );
  }
}

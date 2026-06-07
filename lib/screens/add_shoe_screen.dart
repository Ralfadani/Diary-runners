import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddShoeScreen extends StatefulWidget {
  const AddShoeScreen({Key? key}) : super(key: key);

  @override
  State<AddShoeScreen> createState() => _AddShoeScreenState();
}

class _AddShoeScreenState extends State<AddShoeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _maxMileageController = TextEditingController(text: "500");
  final TextEditingController _initialMileageController = TextEditingController(text: "0");
  final TextEditingController _sizeController = TextEditingController();

  String _selectedCategory = 'Daily Trainer';
  final List<String> _categories = ['Daily Trainer', 'Race / Carbon Plated', 'Speed / Tempo', 'Trail', 'Max Cushion', 'Recovery'];

  String _selectedTerrain = 'Road / Aspal';
  final List<String> _terrains = ['Road / Aspal', 'Trail / Tanah', 'Track / Karet', 'Treadmill', 'Mixed'];

  DateTime? _purchaseDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple, 
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _purchaseDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _saveShoe() {
    if (_formKey.currentState!.validate()) {
      // Create shoe data object if needed, but for now we just pop
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data sepatu berhasil ditambahkan!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.deepPurple, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tambah Sepatu",
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
                  "Detail Gear Intelligence",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  "Isi spesifikasi sepatu secara detail agar AI dapat menganalisis kesehatan busa (midsole), prediksi masa pakai, dan Return on Investment (ROI).",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 32),

                // --- IDENTITAS SEPATU ---
                const Text("IDENTITAS SEPATU", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurple, letterSpacing: 1.2)),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _brandController,
                  label: "Merek (Brand)",
                  hint: "Misal: Nike, Adidas, Hoka",
                  icon: Icons.storefront_outlined,
                  validator: (val) => val == null || val.isEmpty ? "Merek wajib diisi" : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _modelController,
                  label: "Model / Nama Sepatu",
                  hint: "Misal: Pegasus 40, Boston 12",
                  icon: Icons.do_not_step,
                  validator: (val) => val == null || val.isEmpty ? "Model wajib diisi" : null,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: "Kategori Sepatu",
                  value: _selectedCategory,
                  items: _categories,
                  icon: Icons.category_outlined,
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _sizeController,
                  label: "Ukuran (Size)",
                  hint: "Misal: 42.5 EU / 9 US",
                  icon: Icons.straighten,
                ),

                const SizedBox(height: 32),

                // --- DATA ANALITIK UMUR & MEDAN ---
                const Text("DATA ANALITIK & MASA PAKAI", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurple, letterSpacing: 1.2)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _maxMileageController,
                        label: "Klaim Umur (KM)",
                        hint: "500",
                        icon: Icons.speed,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _initialMileageController,
                        label: "Jarak Awal (KM)",
                        hint: "0",
                        icon: Icons.history,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: "Medan Utama (Terrain)",
                  value: _selectedTerrain,
                  items: _terrains,
                  icon: Icons.landscape_outlined,
                  onChanged: (val) => setState(() => _selectedTerrain = val!),
                ),

                const SizedBox(height: 32),

                // --- FINANCIAL (ROI) ---
                const Text("DATA FINANSIAL (Untuk Analisis ROI)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurple, letterSpacing: 1.2)),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _priceController,
                  label: "Harga Beli (Rp)",
                  hint: "Misal: 2000000",
                  icon: Icons.attach_money_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (val) => val == null || val.isEmpty ? "Harga beli wajib diisi" : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _dateController,
                  label: "Tanggal Pembelian",
                  hint: "Pilih tanggal",
                  icon: Icons.calendar_month_outlined,
                  readOnly: true,
                  onTap: _pickDate,
                ),

                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _saveShoe,
                    child: const Text(
                      "Simpan Sepatu ke Gear Intelligence",
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
    String? hint,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.normal),
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade300),
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
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.deepPurple),
      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.normal),
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade300),
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
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

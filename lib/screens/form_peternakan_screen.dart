import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:surgatani/models/pencatatan_peternakan_model.dart';
import 'package:surgatani/widgets/gradient_app_bar.dart';

// Class helper untuk state management form ini
class PeternakanFormData {
  final String nama;
  final bool isDefault;
  final TextEditingController hargaUtamaController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  final List<SubItemFormData> subItems;

  PeternakanFormData({
    required this.nama,
    this.isDefault = false,
    required this.subItems,
  });
}

class SubItemFormData {
  final String nama;
  final TextEditingController hargaController = TextEditingController();
  SubItemFormData({required this.nama});
}

class FormPeternakanScreen extends StatefulWidget {
  const FormPeternakanScreen({super.key});

  @override
  State<FormPeternakanScreen> createState() => _FormPeternakanScreenState();
}

class _FormPeternakanScreenState extends State<FormPeternakanScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _instansiController = TextEditingController();
  final _petugasController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _pedagangController = TextEditingController();

  // Variables
  DateTime _selectedDate = DateTime.now();
  String? _selectedJabatan;
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoadingCommodities = true;
  late List<PeternakanFormData> _komoditiItems;

  // Constants
  static const Color _primaryColor = Color(0xFF5D4037);
  final List<String> _jabatanOptions = [
    'Pengawas Mutu Hasil Pertanian (PMHP)',
    'Analis Pasar Hasil Pertanian',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _komoditiItems = _getDefaultCommodities();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _isLoadingCommodities = false);
    });
  }

  @override
  void dispose() {
    _instansiController.dispose();
    _petugasController.dispose();
    _lokasiController.dispose();
    _pedagangController.dispose();
    for (var item in _komoditiItems) {
      item.hargaUtamaController.dispose();
      item.keteranganController.dispose();
      for (var subItem in item.subItems) {
        subItem.hargaController.dispose();
      }
    }
    super.dispose();
  }

  List<PeternakanFormData> _getDefaultCommodities() {
    return [
      PeternakanFormData(
        nama: 'Harga Ayam Pedaging Hidup per Kg',
        isDefault: true,
        subItems: [],
      ),
      PeternakanFormData(
        nama: 'Harga Daging Ayam per Kg',
        isDefault: true,
        subItems: [
          SubItemFormData(nama: 'daging campur'),
          SubItemFormData(nama: 'daging fillet'),
          SubItemFormData(nama: 'daging paha'),
        ],
      ),
      PeternakanFormData(
        nama: 'Harga Babi Hidup per Kg',
        isDefault: true,
        subItems: [],
      ),
      PeternakanFormData(
        nama: 'Harga Daging Babi per Kg',
        isDefault: true,
        subItems: [
          SubItemFormData(nama: 'daging super'),
          SubItemFormData(nama: 'daging campur'),
          SubItemFormData(nama: 'iga'),
          SubItemFormData(nama: 'balung'),
        ],
      ),
      PeternakanFormData(
        nama: 'Harga Sapi Hidup per Kg',
        isDefault: true,
        subItems: [],
      ),
      PeternakanFormData(
        nama: 'Harga Daging Sapi per Kg',
        isDefault: true,
        subItems: [
          SubItemFormData(nama: 'daging campur'),
          SubItemFormData(nama: 'daging super'),
        ],
      ),
      PeternakanFormData(
        nama: 'Harga Telur Ayam Ras per tray',
        isDefault: true,
        subItems: [
          SubItemFormData(nama: 'telur besar'),
          SubItemFormData(nama: 'telur sedang'),
          SubItemFormData(nama: 'telur kecil'),
        ],
      ),
    ];
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      if (mounted) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Gagal memilih gambar. Silakan coba lagi.",
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
                Theme.of(context).colorScheme.copyWith(primary: _primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _showAddCommodityDialog() {
    final newCommodityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(children: const [
          Icon(Icons.add_box_outlined, color: _primaryColor),
          SizedBox(width: 12),
          Text("Tambah Komoditi Baru",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
        content: TextFormField(
          controller: newCommodityController,
          decoration: InputDecoration(
            hintText: "Nama Komoditi",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          autofocus: true,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Batal"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (newCommodityController.text.trim().isNotEmpty) {
                      setState(() {
                        _komoditiItems.add(
                          PeternakanFormData(
                            nama: newCommodityController.text.trim(),
                            subItems: [],
                          ),
                        );
                      });
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Tambah"),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      ),
    );
  }

  Future<void> _saveData() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Mohon lengkapi semua field yang wajib diisi.",
        ),
      );
      return;
    }

    try {
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => Center(
      //     child: Container(
      //       margin: const EdgeInsets.all(40),
      //       padding: const EdgeInsets.all(24),
      //       decoration: BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: BorderRadius.circular(16),
      //       ),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: const [
      //           CircularProgressIndicator(
      //               valueColor: AlwaysStoppedAnimation<Color>(_primaryColor)),
      //           SizedBox(height: 16),
      //           Text('Menyimpan data...'),
      //         ],
      //       ),
      //     ),
      //   ),
      // );

      final List<ItemPeternakan> daftarKomoditi = _komoditiItems.map((item) {
        return ItemPeternakan()
          ..nama = item.nama
          ..hargaUtama = double.tryParse(item.hargaUtamaController.text) ?? 0
          ..keterangan = item.keteranganController.text
          ..subItems = item.subItems.map((subItem) {
            return SubItemPeternakan()
              ..nama = subItem.nama
              ..harga = double.tryParse(subItem.hargaController.text) ?? 0;
          }).toList();
      }).toList();

      List<String> savedImagePaths = [];
      if (_selectedImages.isNotEmpty) {
        final appDir = await getApplicationDocumentsDirectory();
        final localPath = path.join(
          appDir.path,
          'pictures',
          DateTime.now().millisecondsSinceEpoch.toString(),
        );
        await Directory(localPath).create(recursive: true);
        for (var imageFile in _selectedImages) {
          final fileName = path.basename(imageFile.path);
          final localFile =
              await imageFile.copy(path.join(localPath, fileName));
          savedImagePaths.add(localFile.path);
        }
      }

      final newPencatatan = PencatatanPeternakan()
        ..namaInstansi = _instansiController.text.trim()
        ..namaPetugas = _petugasController.text.trim()
        ..jabatan = _selectedJabatan!
        ..tanggal = _selectedDate
        ..lokasi = _lokasiController.text.trim()
        ..namaPedagang = _pedagangController.text.trim()
        ..daftarKomoditi = daftarKomoditi
        ..imagePaths = savedImagePaths;

      final box = Hive.box('peternakan_box');
      await box.add(newPencatatan);

      if (mounted) {
        Navigator.of(context).pop();
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "Data Peternakan berhasil disimpan!",
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Gagal menyimpan data. Silakan coba lagi.",
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: GradientAppBar(
        title: 'Catat Harga',
        subtitle: 'Peternakan',
        icon: MdiIcons.cow,
        gradientColors: const [
          Color(0xFF6D4C41),
          Color(0xFF5D4037),
          Color(0xFF4E342E),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader("Informasi Umum", Icons.info_outline),
              const SizedBox(height: 20),
              _buildGeneralInfoSection(),
              const SizedBox(height: 32),
              _buildSectionHeader(
                  "Daftar Harga Komoditi", Icons.monetization_on_outlined),
              const SizedBox(height: 20),
              _buildCommoditySection(),
              const SizedBox(height: 32),
              _buildSectionHeader(
                  "Dokumentasi Foto", Icons.camera_alt_outlined),
              const SizedBox(height: 20),
              _buildImageSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralInfoSection() {
    return Column(
      children: [
        _buildTextField(
          controller: _instansiController,
          label: 'Nama Instansi',
          icon: Icons.business_outlined,
          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _petugasController,
          label: 'Nama Petugas',
          icon: Icons.person_outline,
          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
        ),
        const SizedBox(height: 16),
        _buildDropdownField(),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _lokasiController,
          label: 'Lokasi (Contoh: Pasar Anyar)',
          icon: Icons.location_on_outlined,
          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _pedagangController,
          label: 'Nama Pedagang',
          icon: Icons.store_outlined,
          validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
        ),
        const SizedBox(height: 16),
        _buildDatePicker(),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: _primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedJabatan,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Jabatan',
        prefixIcon: const Icon(Icons.work_outline, color: _primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _jabatanOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (newValue) => setState(() => _selectedJabatan = newValue),
      validator: (value) => value == null ? 'Jabatan wajib dipilih' : null,
    );
  }

  Widget _buildDatePicker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading:
            const Icon(Icons.calendar_today_outlined, color: _primaryColor),
        title: Text(
          'Tanggal: ${DateFormat('d MMMM yyyy', 'id_ID').format(_selectedDate)}',
          style: const TextStyle(fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: _primaryColor),
        onTap: _selectDate,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCommoditySection() {
    return Column(
      children: [
        if (_isLoadingCommodities)
          const Center(child: CircularProgressIndicator(color: _primaryColor))
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _komoditiItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => _buildCommodityCard(index),
          ),
        const SizedBox(height: 16),
        _buildAddCommodityButton(),
      ],
    );
  }

  Widget _buildCommodityCard(int index) {
    final item = _komoditiItems[index];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                        color: _primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                ),
                if (!item.isDefault)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () =>
                        setState(() => _komoditiItems.removeAt(index)),
                    tooltip: 'Hapus Komoditi',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (item.subItems.isEmpty)
              TextFormField(
                controller: item.hargaUtamaController,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: _primaryColor),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            if (item.subItems.isNotEmpty)
              ...item.subItems.map((subItem) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: subItem.hargaController,
                    decoration: InputDecoration(
                      labelText: subItem.nama,
                      prefixText: 'Rp ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                );
              }).toList(),
            const SizedBox(height: 12),
            TextFormField(
              controller: item.keteranganController,
              decoration: InputDecoration(
                labelText: 'Keterangan',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _primaryColor),
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCommodityButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primaryColor.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: _showAddCommodityDialog,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: _primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Tambah Komoditi",
                style: TextStyle(
                  color: _primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          if (_selectedImages.isNotEmpty) ...[
            Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.file(
                          _selectedImages[index],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.close,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: _primaryColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: _pickImages,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_a_photo_outlined,
                          color: _primaryColor, size: 32),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedImages.isEmpty
                          ? "Tambah Foto Dokumentasi"
                          : "Tambah Foto Lainnya",
                      style: const TextStyle(
                        color: _primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Tap untuk memilih foto dari galeri",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6D4C41),
            Color(0xFF5D4037),
            Color(0xFF4E342E),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _saveData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        icon: const Icon(Icons.save_outlined, size: 24),
        label: const Text(
          "SIMPAN DATA",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:surgatani/models/pencatatan_tanaman_pangan_model.dart';
import 'package:surgatani/widgets/gradient_app_bar.dart';

// Class helper untuk menampung controller dari setiap komoditi
class KomoditiEditData {
  String nama;
  TextEditingController hargaEceranController;
  TextEditingController hargaGrosirController;
  TextEditingController keteranganController;
  final bool isDefault;

  KomoditiEditData({
    required this.nama,
    required this.hargaEceranController,
    required this.hargaGrosirController,
    required this.keteranganController,
    this.isDefault = false,
  });
}

class DetailTanamanPanganScreen extends StatefulWidget {
  final PencatatanTanamanPangan pencatatan;
  final int pencatatanKey;

  const DetailTanamanPanganScreen({
    super.key,
    required this.pencatatan,
    required this.pencatatanKey,
  });

  @override
  State<DetailTanamanPanganScreen> createState() =>
      _DetailTanamanPanganScreenState();
}

class _DetailTanamanPanganScreenState extends State<DetailTanamanPanganScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _instansiController;
  late TextEditingController _petugasController;
  late TextEditingController _lokasiController;
  late TextEditingController _pedagangController;

  // Variables
  late DateTime _selectedDate;
  late String _selectedJabatan;
  late List<KomoditiEditData> _komoditiEditList;
  List<dynamic> _images = [];
  final ImagePicker _picker = ImagePicker();

  // Constants
  static const Color _primaryColor = Color(0xFFD4AF37);
  final List<String> _jabatanOptions = [
    'Pengawas Mutu Hasil Pertanian (PMHP)',
    'Analis Pasar Hasil Pertanian',
    'Lainnya',
  ];
  final List<String> _defaultKomoditiNames = [
    "Beras Premium",
    "Beras Medium",
    "Jagung Pipilan Kering",
    "Kedelai",
    "Beras Ketan Putih",
    "Beras Ketan Hitam",
    "Kacang Merah",
    "Kacang Buncis",
    "Kacang Tanah Polong Kering",
    "Kacang Ijo Biji Kering",
    "Ubi Kayu",
    "Ubi Jalar",
    "Talas",
    "Porang",
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    _instansiController =
        TextEditingController(text: widget.pencatatan.namaInstansi);
    _petugasController =
        TextEditingController(text: widget.pencatatan.namaPetugas);
    _selectedJabatan = widget.pencatatan.jabatan;
    _lokasiController = TextEditingController(text: widget.pencatatan.lokasi);
    _pedagangController =
        TextEditingController(text: widget.pencatatan.namaPedagang);
    _selectedDate = widget.pencatatan.tanggal;

    _komoditiEditList = widget.pencatatan.daftarKomoditi.map((komoditi) {
      return KomoditiEditData(
        nama: komoditi.nama,
        hargaEceranController:
            TextEditingController(text: komoditi.hargaEceran?.toString() ?? ''),
        hargaGrosirController:
            TextEditingController(text: komoditi.hargaGrosir?.toString() ?? ''),
        keteranganController:
            TextEditingController(text: komoditi.keterangan ?? ''),
        isDefault: _defaultKomoditiNames.contains(komoditi.nama),
      );
    }).toList();

    if (widget.pencatatan.imagePaths != null) {
      _images = List<dynamic>.from(widget.pencatatan.imagePaths!);
    }
  }

  @override
  void dispose() {
    _instansiController.dispose();
    _petugasController.dispose();
    _lokasiController.dispose();
    _pedagangController.dispose();
    for (var item in _komoditiEditList) {
      item.hargaEceranController.dispose();
      item.hargaGrosirController.dispose();
      item.keteranganController.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles =
          await _picker.pickMultiImage(imageQuality: 80);
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _images.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      if (mounted) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
              message: "Gagal memilih gambar. Silakan coba lagi."),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primaryColor, width: 2),
            ),
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
                        _komoditiEditList.add(
                          KomoditiEditData(
                            nama: newCommodityController.text.trim(),
                            hargaEceranController: TextEditingController(),
                            hargaGrosirController: TextEditingController(),
                            keteranganController: TextEditingController(),
                            isDefault: false,
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
                    elevation: 0,
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

  Future<void> _updateData() async {
    if (!_formKey.currentState!.validate()) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
            message: "Mohon lengkapi semua field yang wajib diisi."),
      );
      return;
    }
    FocusScope.of(context).unfocus();

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
      //           Text('Memperbarui data...'),
      //         ],
      //       ),
      //     ),
      //   ),
      // );

      List<String> finalImagePaths = [];
      final appDir = await getApplicationDocumentsDirectory();
      for (var image in _images) {
        if (image is String) {
          finalImagePaths.add(image);
        } else if (image is File) {
          final localPath = path.join(appDir.path, 'pictures',
              DateTime.now().millisecondsSinceEpoch.toString());
          await Directory(localPath).create(recursive: true);
          final fileName = path.basename(image.path);
          final localFile = await image.copy(path.join(localPath, fileName));
          finalImagePaths.add(localFile.path);
        }
      }
      final oldPaths = widget.pencatatan.imagePaths ?? [];
      for (String oldPath in oldPaths) {
        if (!finalImagePaths.contains(oldPath)) {
          try {
            await File(oldPath).delete();
          } catch (e) {
            print("Gagal menghapus file lama: $e");
          }
        }
      }

      final updatedListKomoditi = _komoditiEditList.map((editData) {
        return Komoditi()
          ..nama = editData.nama
          ..hargaEceran = double.tryParse(editData.hargaEceranController.text)
          ..hargaGrosir = double.tryParse(editData.hargaGrosirController.text)
          ..keterangan = editData.keteranganController.text;
      }).toList();

      final updatedPencatatan = PencatatanTanamanPangan()
        ..namaInstansi = _instansiController.text.trim()
        ..namaPetugas = _petugasController.text.trim()
        ..jabatan = _selectedJabatan
        ..tanggal = _selectedDate
        ..lokasi = _lokasiController.text.trim()
        ..namaPedagang = _pedagangController.text.trim()
        ..daftarKomoditi = updatedListKomoditi
        ..imagePaths = finalImagePaths;

      final box = Hive.box('tanaman_pangan_box');
      await box.put(widget.pencatatanKey, updatedPencatatan);

      if (mounted) {
        Navigator.of(context).pop(); // Close loading
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(message: "Data berhasil diperbarui!"),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.of(context).pop(); // Back to list
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
              message: "Gagal memperbarui data. Silakan coba lagi."),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: GradientAppBar(
        title: 'Edit Catatan',
        subtitle: 'Tanaman Pangan',
        icon: MdiIcons.barley,
        gradientColors: const [
          Color(0xFF8E712E),
          Color(0xFFB89B31),
          Color(0xFFD4AF37),
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
            color: Color(0xFFD4AF37),
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
      onChanged: (newValue) => setState(() => _selectedJabatan = newValue!),
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
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _komoditiEditList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) => _buildCommodityCard(index),
        ),
        const SizedBox(height: 16),
        _buildAddCommodityButton(),
      ],
    );
  }

  Widget _buildCommodityCard(int index) {
    final item = _komoditiEditList[index];
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
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                ),
                if (!item.isDefault)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () =>
                        setState(() => _komoditiEditList.removeAt(index)),
                    tooltip: 'Hapus Komoditi',
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: item.hargaEceranController,
              decoration: InputDecoration(
                labelText: 'Harga Eceran/kg',
                prefixText: 'Rp ',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _primaryColor),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: item.hargaGrosirController,
              decoration: InputDecoration(
                labelText: 'Harga Grosir/25kg',
                prefixText: 'Rp ',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _primaryColor),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
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
          if (_images.isNotEmpty) ...[
            Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final image = _images[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        image is File
                            ? Image.file(image,
                                width: 120, height: 120, fit: BoxFit.cover)
                            : Image.file(File(image),
                                width: 120, height: 120, fit: BoxFit.cover),
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
                      _images.isEmpty
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
            Color(0xFF8E712E),
            Color(0xFFB89B31),
            Color(0xFFD4AF37),
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
        onPressed: _updateData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        icon: const Icon(Icons.save_as_outlined, size: 24),
        label: const Text(
          "SIMPAN PERUBAHAN",
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

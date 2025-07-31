import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:surgatani/services/pdf_service.dart';
import 'package:surgatani/widgets/gradient_app_bar.dart'; // Menggunakan AppBar statis
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// Import semua model dan screen yang dibutuhkan
import 'package:surgatani/models/pencatatan_tanaman_pangan_model.dart';
import 'package:surgatani/models/pencatatan_hortikultura_model.dart';
import 'package:surgatani/models/pencatatan_peternakan_model.dart';
import 'package:surgatani/models/pencatatan_perkebunan_model.dart';
import 'package:surgatani/screens/form_tanaman_pangan_screen.dart';
import 'package:surgatani/screens/detail_tanaman_pangan_screen.dart';
import 'package:surgatani/screens/form_hortikultura_screen.dart';
import 'package:surgatani/screens/detail_hortikultura_screen.dart';
import 'package:surgatani/screens/form_peternakan_screen.dart';
import 'package:surgatani/screens/detail_peternakan_screen.dart';
import 'package:surgatani/screens/form_perkebunan_screen.dart';
import 'package:surgatani/screens/detail_perkebunan_screen.dart';

class RecordListScreen extends StatelessWidget {
  final String title;
  final Box dataBox;
  final String categoryType;

  const RecordListScreen({
    super.key,
    required this.title,
    required this.dataBox,
    required this.categoryType,
  });

  //==================================================================
  // SEMUA FUNGSI HELPER DI BAWAH INI TIDAK DIUBAH SAMA SEKALI
  //==================================================================

  Color _getCategoryColor() {
    switch (categoryType) {
      case 'tanaman_pangan':
        return const Color(0xFFD4AF37);
      case 'hortikultura':
        return const Color(0xFFFF8F00);
      case 'peternakan':
        return const Color(0xFF5D4037);
      case 'perkebunan':
        return const Color(0xFF689F38);
      default:
        return const Color(0xFF2E7D32);
    }
  }

  IconData _getCategoryIcon() {
    switch (categoryType) {
      case 'tanaman_pangan':
        return MdiIcons.barley;
      case 'hortikultura':
        return MdiIcons.carrot;
      case 'peternakan':
        return MdiIcons.cow;
      case 'perkebunan':
        return Icons.park;
      default:
        return Icons.eco;
    }
  }

  void _navigateToAddForm(BuildContext context) {
    Widget? targetForm;
    switch (categoryType) {
      case 'tanaman_pangan':
        targetForm = const FormTanamanPanganScreen();
        break;
      case 'hortikultura':
        targetForm = const FormHortikulturaScreen();
        break;
      case 'peternakan':
        targetForm = const FormPeternakanScreen();
        break;
      case 'perkebunan':
        targetForm = const FormPerkebunanScreen();
        break;
    }

    if (targetForm != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => targetForm!));
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'Form untuk kategori "$title" belum tersedia.',
        ),
      );
    }
  }

  void _navigateToDetailScreen(
      BuildContext context, dynamic record, int recordKey) {
    Widget? targetScreen;
    switch (categoryType) {
      case 'tanaman_pangan':
        targetScreen = DetailTanamanPanganScreen(
            pencatatan: record, pencatatanKey: recordKey);
        break;
      case 'hortikultura':
        targetScreen = DetailHortikulturaScreen(
            pencatatan: record, pencatatanKey: recordKey);
        break;
      case 'peternakan':
        targetScreen = DetailPeternakanScreen(
            pencatatan: record, pencatatanKey: recordKey);
        break;
      case 'perkebunan':
        targetScreen = DetailPerkebunanScreen(
            pencatatan: record, pencatatanKey: recordKey);
        break;
    }
    if (targetScreen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => targetScreen!));
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'Halaman detail untuk "$title" belum tersedia.',
        ),
      );
    }
  }

  // Fungsi untuk mencetak PDF yang sesuai
  Future<void> _printPdf(BuildContext context, dynamic record) async {
    // Tampilkan dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_getCategoryColor()),
                ),
                const SizedBox(width: 24),
                const Text("Membuat PDF..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      // Proses pembuatan PDF
      switch (categoryType) {
        case 'tanaman_pangan':
          await PdfService.generateTanamanPanganPdf(
              record as PencatatanTanamanPangan);
          break;
        case 'hortikultura':
          await PdfService.generateHortikulturaPdf(
              record as PencatatanHortikultura);
          break;
        case 'peternakan':
          await PdfService.generatePeternakanPdf(
              record as PencatatanPeternakan);
          break;
        case 'perkebunan':
          await PdfService.generatePerkebunanPdf(
              record as PencatatanPerkebunan);
          break;
        default:
          throw Exception('Kategori tidak dikenali: $categoryType');
      }

      // Jika berhasil, tutup dialog loading lalu tampilkan notifikasi sukses
      if (context.mounted) {
        Navigator.of(context).pop(); // Tutup dialog
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: "PDF berhasil dibuat!",
          ),
        );
      }
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      // Jika gagal, tutup dialog loading lalu tampilkan notifikasi error
      if (context.mounted) {
        Navigator.of(context).pop(); // Tutup dialog
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Gagal membuat PDF: ${e.toString()}",
          ),
        );
      }
    }
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus
  void _showDeleteDialog(
      BuildContext context, Box box, int key, String location) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange.shade600,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              "Konfirmasi Hapus",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Anda yakin ingin menghapus catatan untuk lokasi:",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                location,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Data yang dihapus tidak dapat dikembalikan.",
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              "Batal",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              try {
                // Get record sebelum menghapus untuk mendapatkan path gambar
                final record = box.get(key);
                if (record == null) {
                  Navigator.of(ctx).pop();
                  if (context.mounted) {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.error(
                        message: "Data tidak ditemukan!",
                      ),
                    );
                  }
                  return;
                }

                // Ambil daftar path gambar untuk dihapus
                final List<String> pathsToDelete = [];
                if (record.imagePaths != null) {
                  pathsToDelete.addAll(List<String>.from(record.imagePaths!));
                }

                // Hapus data dari box
                await box.delete(key);

                // Tutup dialog
                Navigator.of(ctx).pop();

                // Hapus file gambar
                for (var path in pathsToDelete) {
                  try {
                    final file = File(path);
                    if (await file.exists()) {
                      await file.delete();
                      debugPrint('Deleted image file: $path');
                    }
                  } catch (e) {
                    debugPrint("Gagal menghapus file gambar: $e");
                  }
                }

                // ==========================================================
                // ANIMASI CUSTOM SNACKBAR UNTUK BERHASIL HAPUS
                // ==========================================================
                if (context.mounted) {
                  // Tunggu sebentar agar dialog tertutup sempurna
                  await Future.delayed(const Duration(milliseconds: 200));

                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.success(
                      message: "Catatan '$location' berhasil dihapus!",
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.delete_sweep_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      backgroundColor: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    // Konfigurasi animasi
                    animationDuration: const Duration(milliseconds: 800),
                    reverseAnimationDuration: const Duration(milliseconds: 600),
                    displayDuration: const Duration(seconds: 3),
                    // Kurva animasi yang smooth
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.easeInBack,
                    // Posisi dan padding
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );

                  // Tambahan: Animasi haptic feedback untuk feel yang lebih baik
                  // (Jika menggunakan haptic feedback)
                  // HapticFeedback.lightImpact();
                }
                // ==========================================================
              } catch (e) {
                Navigator.of(ctx).pop();
                debugPrint('Error deleting record: $e');
                if (context.mounted) {
                  // Tunggu sebentar agar dialog tertutup sempurna
                  await Future.delayed(const Duration(milliseconds: 200));

                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.error(
                      message: "❌ Gagal menghapus: ${e.toString()}",
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      backgroundColor: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    // Animasi untuk error
                    animationDuration: const Duration(milliseconds: 600),
                    reverseAnimationDuration: const Duration(milliseconds: 400),
                    displayDuration: const Duration(seconds: 4),
                    curve: Curves.bounceOut,
                    reverseCurve: Curves.easeIn,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );
                }
              }
            },
            child: const Text(
              "Ya, Hapus",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();
    final categoryIcon = _getCategoryIcon();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: GradientAppBar(
        title: 'Riwayat $title',
        subtitle: 'Data pencatatan survei harga',
        icon: categoryIcon,
        gradientColors: [
          categoryColor.withOpacity(0.8),
          categoryColor,
        ],
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: dataBox.listenable(),
        builder: (context, Box box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      size: 80,
                      color: categoryColor.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Belum Ada Catatan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Mulai catat data survei harga untuk kategori $title dengan menekan tombol "+ Catat Baru"',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          final reversedData = box.values.toList().reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reversedData.length,
            itemBuilder: (context, index) {
              final record = reversedData[index];
              final originalIndex = (box.length - 1) - index;
              final recordKey = box.keyAt(originalIndex);

              final String lokasi = record?.lokasi ?? 'Lokasi tidak tersedia';
              final String namaPetugas =
                  record?.namaPetugas ?? 'Petugas tidak tersedia';
              final DateTime tanggal = record?.tanggal ?? DateTime.now();
              final List<String>? imagePaths =
                  (record?.imagePaths as List?)?.cast<String>();

              return _buildRecordCard(
                context: context,
                box: box,
                record: record,
                recordKey: recordKey as int,
                lokasi: lokasi,
                namaPetugas: namaPetugas,
                tanggal: tanggal,
                imagePaths: imagePaths,
                categoryColor: categoryColor,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddForm(context),
        backgroundColor: _getCategoryColor(),
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        label: const Text(
          'Catat Baru',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        icon: const Icon(Icons.add, size: 24),
      ),
    );
  }

  //==================================================================
  // WIDGET `_buildRecordCard` TIDAK DIUBAH SAMA SEKALI
  //==================================================================

  Widget _buildRecordCard({
    required BuildContext context,
    required Box box,
    required dynamic record,
    required int recordKey,
    required String lokasi,
    required String namaPetugas,
    required DateTime tanggal,
    required Color categoryColor,
    List<String>? imagePaths,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetailScreen(context, record, recordKey),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagePaths != null && imagePaths.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.file(
                    File(imagePaths.first),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              categoryColor.withOpacity(0.1),
                              categoryColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported_outlined,
                                size: 48,
                                color: categoryColor.withOpacity(0.3),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Gambar tidak tersedia',
                                style: TextStyle(
                                  color: categoryColor.withOpacity(0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lokasi,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              height: 1.2,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            title,
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            namaPetugas,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                              .format(tanggal),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade600,
                          side: BorderSide(color: Colors.red.shade200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            _showDeleteDialog(context, box, recordKey, lokasi),
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text(
                          "Hapus",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: categoryColor,
                          side:
                              BorderSide(color: categoryColor.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _printPdf(context, record),
                        icon:
                            const Icon(Icons.picture_as_pdf_outlined, size: 18),
                        label: const Text(
                          "PDF",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: categoryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () =>
                            _navigateToDetailScreen(context, record, recordKey),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text(
                          "Edit",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

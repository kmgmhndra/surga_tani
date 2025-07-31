import 'package:flutter/material.dart';

// Tambahkan properti isDefault untuk membedakan komoditi
class KomoditiFormData {
  final String nama;
  final bool isDefault;
  final TextEditingController hargaEceranController = TextEditingController();
  final TextEditingController hargaGrosirController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  KomoditiFormData({required this.nama, this.isDefault = false});
}

class FormProvider with ChangeNotifier {
  List<KomoditiFormData> _items = [];

  List<KomoditiFormData> get items => _items;

  FormProvider() {
    _items = _getDefaultKomoditi();
  }

  // Daftar 14 komoditi default
  List<KomoditiFormData> _getDefaultKomoditi() {
    return [
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
    ].map((nama) => KomoditiFormData(nama: nama, isDefault: true)).toList();
  }

  // Fungsi untuk menambah komoditi baru ke dalam daftar
  void tambahKomoditi(String nama) {
    if (nama.isNotEmpty) {
      _items.add(KomoditiFormData(nama: nama, isDefault: false));
      notifyListeners();
    }
  }

  // FUNGSI BARU: Hapus komoditi berdasarkan index-nya
  void hapusKomoditi(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}

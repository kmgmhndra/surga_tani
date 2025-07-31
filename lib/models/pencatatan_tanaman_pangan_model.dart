import 'package:hive/hive.dart';

part 'pencatatan_tanaman_pangan_model.g.dart';

@HiveType(typeId: 0)
class PencatatanTanamanPangan extends HiveObject {
  @HiveField(0)
  late String namaInstansi;
  @HiveField(1)
  late String namaPetugas;
  @HiveField(2)
  late DateTime tanggal;
  @HiveField(3)
  late String lokasi;
  @HiveField(4)
  late String namaPedagang;
  @HiveField(5)
  late List<Komoditi> daftarKomoditi;
  @HiveField(6)
  late List<String>? imagePaths;
  @HiveField(7)
  late String jabatan;
}

@HiveType(typeId: 1)
class Komoditi extends HiveObject {
  @HiveField(0)
  late String nama;
  @HiveField(1)
  late double? hargaEceran;
  @HiveField(2)
  late double? hargaGrosir;
  @HiveField(3)
  late String? keterangan;
}

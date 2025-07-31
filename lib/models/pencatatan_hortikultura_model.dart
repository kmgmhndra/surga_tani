import 'package:hive/hive.dart';

part 'pencatatan_hortikultura_model.g.dart';

@HiveType(typeId: 2)
class PencatatanHortikultura extends HiveObject {
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
  late List<KomoditiSederhana> daftarKomoditi;
  @HiveField(6)
  late List<String>? imagePaths;
  @HiveField(7)
  late String jabatan;
}

@HiveType(typeId: 3)
class KomoditiSederhana extends HiveObject {
  @HiveField(0)
  late String nama;
  @HiveField(1)
  late double? hargaPerKg;
  @HiveField(2)
  late String? keterangan;
}

import 'package:hive/hive.dart';
// Import model KomoditiSederhana dari file hortikultura
import 'pencatatan_hortikultura_model.dart';

part 'pencatatan_perkebunan_model.g.dart';

@HiveType(typeId: 7)
class PencatatanPerkebunan extends HiveObject {
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

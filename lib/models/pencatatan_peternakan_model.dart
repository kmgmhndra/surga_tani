import 'package:hive/hive.dart';

part 'pencatatan_peternakan_model.g.dart';

@HiveType(typeId: 4)
class PencatatanPeternakan extends HiveObject {
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
  late List<ItemPeternakan> daftarKomoditi;
  @HiveField(6)
  late List<String>? imagePaths;
  @HiveField(7)
  late String jabatan;
}

@HiveType(typeId: 5)
class ItemPeternakan extends HiveObject {
  @HiveField(0)
  late String nama; // Contoh: "Harga Daging Ayam per Kg"
  @HiveField(1)
  late double? hargaUtama; // Untuk yang tidak punya sub-item
  @HiveField(2)
  late List<SubItemPeternakan> subItems;
  @HiveField(3)
  late String? keterangan;
}

@HiveType(typeId: 6)
class SubItemPeternakan extends HiveObject {
  @HiveField(0)
  late String nama; // Contoh: "daging campur"
  @HiveField(1)
  late double? harga;
}

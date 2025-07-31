// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pencatatan_perkebunan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PencatatanPerkebunanAdapter extends TypeAdapter<PencatatanPerkebunan> {
  @override
  final int typeId = 7;

  @override
  PencatatanPerkebunan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PencatatanPerkebunan()
      ..namaInstansi = fields[0] as String
      ..namaPetugas = fields[1] as String
      ..tanggal = fields[2] as DateTime
      ..lokasi = fields[3] as String
      ..namaPedagang = fields[4] as String
      ..daftarKomoditi = (fields[5] as List).cast<KomoditiSederhana>()
      ..imagePaths = (fields[6] as List?)?.cast<String>()
      ..jabatan = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, PencatatanPerkebunan obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.namaInstansi)
      ..writeByte(1)
      ..write(obj.namaPetugas)
      ..writeByte(2)
      ..write(obj.tanggal)
      ..writeByte(3)
      ..write(obj.lokasi)
      ..writeByte(4)
      ..write(obj.namaPedagang)
      ..writeByte(5)
      ..write(obj.daftarKomoditi)
      ..writeByte(6)
      ..write(obj.imagePaths)
      ..writeByte(7)
      ..write(obj.jabatan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PencatatanPerkebunanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

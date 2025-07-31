// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pencatatan_hortikultura_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PencatatanHortikulturaAdapter
    extends TypeAdapter<PencatatanHortikultura> {
  @override
  final int typeId = 2;

  @override
  PencatatanHortikultura read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PencatatanHortikultura()
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
  void write(BinaryWriter writer, PencatatanHortikultura obj) {
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
      other is PencatatanHortikulturaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KomoditiSederhanaAdapter extends TypeAdapter<KomoditiSederhana> {
  @override
  final int typeId = 3;

  @override
  KomoditiSederhana read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KomoditiSederhana()
      ..nama = fields[0] as String
      ..hargaPerKg = fields[1] as double?
      ..keterangan = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, KomoditiSederhana obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.hargaPerKg)
      ..writeByte(2)
      ..write(obj.keterangan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KomoditiSederhanaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

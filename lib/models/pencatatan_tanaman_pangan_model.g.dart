// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pencatatan_tanaman_pangan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PencatatanTanamanPanganAdapter
    extends TypeAdapter<PencatatanTanamanPangan> {
  @override
  final int typeId = 0;

  @override
  PencatatanTanamanPangan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PencatatanTanamanPangan()
      ..namaInstansi = fields[0] as String
      ..namaPetugas = fields[1] as String
      ..tanggal = fields[2] as DateTime
      ..lokasi = fields[3] as String
      ..namaPedagang = fields[4] as String
      ..daftarKomoditi = (fields[5] as List).cast<Komoditi>()
      ..imagePaths = (fields[6] as List?)?.cast<String>()
      ..jabatan = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, PencatatanTanamanPangan obj) {
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
      other is PencatatanTanamanPanganAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KomoditiAdapter extends TypeAdapter<Komoditi> {
  @override
  final int typeId = 1;

  @override
  Komoditi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Komoditi()
      ..nama = fields[0] as String
      ..hargaEceran = fields[1] as double?
      ..hargaGrosir = fields[2] as double?
      ..keterangan = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, Komoditi obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.hargaEceran)
      ..writeByte(2)
      ..write(obj.hargaGrosir)
      ..writeByte(3)
      ..write(obj.keterangan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KomoditiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

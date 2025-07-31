// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pencatatan_peternakan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PencatatanPeternakanAdapter extends TypeAdapter<PencatatanPeternakan> {
  @override
  final int typeId = 4;

  @override
  PencatatanPeternakan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PencatatanPeternakan()
      ..namaInstansi = fields[0] as String
      ..namaPetugas = fields[1] as String
      ..tanggal = fields[2] as DateTime
      ..lokasi = fields[3] as String
      ..namaPedagang = fields[4] as String
      ..daftarKomoditi = (fields[5] as List).cast<ItemPeternakan>()
      ..imagePaths = (fields[6] as List?)?.cast<String>()
      ..jabatan = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, PencatatanPeternakan obj) {
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
      other is PencatatanPeternakanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemPeternakanAdapter extends TypeAdapter<ItemPeternakan> {
  @override
  final int typeId = 5;

  @override
  ItemPeternakan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemPeternakan()
      ..nama = fields[0] as String
      ..hargaUtama = fields[1] as double?
      ..subItems = (fields[2] as List).cast<SubItemPeternakan>()
      ..keterangan = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, ItemPeternakan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.hargaUtama)
      ..writeByte(2)
      ..write(obj.subItems)
      ..writeByte(3)
      ..write(obj.keterangan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemPeternakanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubItemPeternakanAdapter extends TypeAdapter<SubItemPeternakan> {
  @override
  final int typeId = 6;

  @override
  SubItemPeternakan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubItemPeternakan()
      ..nama = fields[0] as String
      ..harga = fields[1] as double?;
  }

  @override
  void write(BinaryWriter writer, SubItemPeternakan obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.harga);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubItemPeternakanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

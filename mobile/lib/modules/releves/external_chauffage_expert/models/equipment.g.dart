// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EquipmentAdapter extends TypeAdapter<Equipment> {
  @override
  final int typeId = 1;

  @override
  Equipment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Equipment(
      id: fields[0] as String,
      equipmentName: fields[1] as String,
      type: fields[2] as String,
      marque: fields[3] as String?,
      modele: fields[4] as String?,
      numeroSerie: fields[5] as String?,
      dateInstallation: fields[6] as DateTime?,
      conforme: fields[7] as bool?,
      dateIntervention: fields[8] as DateTime?,
      nomClient: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Equipment obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.equipmentName)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.marque)
      ..writeByte(4)
      ..write(obj.modele)
      ..writeByte(5)
      ..write(obj.numeroSerie)
      ..writeByte(6)
      ..write(obj.dateInstallation)
      ..writeByte(7)
      ..write(obj.conforme)
      ..writeByte(8)
      ..write(obj.dateIntervention)
      ..writeByte(9)
      ..write(obj.nomClient);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquipmentImpl _$$EquipmentImplFromJson(Map<String, dynamic> json) =>
    _$EquipmentImpl(
      id: json['id'] as String,
      equipmentName: json['equipmentName'] as String,
      type: json['type'] as String,
      marque: json['marque'] as String?,
      modele: json['modele'] as String?,
      numeroSerie: json['numeroSerie'] as String?,
      dateInstallation: json['dateInstallation'] == null
          ? null
          : DateTime.parse(json['dateInstallation'] as String),
      conforme: json['conforme'] as bool?,
      dateIntervention: json['dateIntervention'] == null
          ? null
          : DateTime.parse(json['dateIntervention'] as String),
      nomClient: json['nomClient'] as String?,
    );

Map<String, dynamic> _$$EquipmentImplToJson(_$EquipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'equipmentName': instance.equipmentName,
      'type': instance.type,
      'marque': instance.marque,
      'modele': instance.modele,
      'numeroSerie': instance.numeroSerie,
      'dateInstallation': instance.dateInstallation?.toIso8601String(),
      'conforme': instance.conforme,
      'dateIntervention': instance.dateIntervention?.toIso8601String(),
      'nomClient': instance.nomClient,
    };

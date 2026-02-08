// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dimensionnement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DimensionnementAdapter extends TypeAdapter<Dimensionnement> {
  @override
  final int typeId = 3;

  @override
  Dimensionnement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dimensionnement(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      surfaceHabitable: fields[2] as double,
      hauteurSousPafond: fields[3] as double,
      zoneClimatique: fields[4] as String,
      coefficientG: fields[5] as double,
      temperatureExterieure: fields[6] as double,
      temperatureInterieure: fields[7] as double,
      deperditionsPieces: (fields[8] as Map).cast<String, double>(),
      commentaires: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Dimensionnement obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.surfaceHabitable)
      ..writeByte(3)
      ..write(obj.hauteurSousPafond)
      ..writeByte(4)
      ..write(obj.zoneClimatique)
      ..writeByte(5)
      ..write(obj.coefficientG)
      ..writeByte(6)
      ..write(obj.temperatureExterieure)
      ..writeByte(7)
      ..write(obj.temperatureInterieure)
      ..writeByte(8)
      ..write(obj.deperditionsPieces)
      ..writeByte(9)
      ..write(obj.commentaires);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DimensionnementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DimensionnementImpl _$$DimensionnementImplFromJson(
        Map<String, dynamic> json) =>
    _$DimensionnementImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      surfaceHabitable: (json['surfaceHabitable'] as num).toDouble(),
      hauteurSousPafond: (json['hauteurSousPafond'] as num).toDouble(),
      zoneClimatique: json['zoneClimatique'] as String,
      coefficientG: (json['coefficientG'] as num).toDouble(),
      temperatureExterieure: (json['temperatureExterieure'] as num).toDouble(),
      temperatureInterieure: (json['temperatureInterieure'] as num).toDouble(),
      deperditionsPieces:
          (json['deperditionsPieces'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      commentaires: json['commentaires'] as String?,
    );

Map<String, dynamic> _$$DimensionnementImplToJson(
        _$DimensionnementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'surfaceHabitable': instance.surfaceHabitable,
      'hauteurSousPafond': instance.hauteurSousPafond,
      'zoneClimatique': instance.zoneClimatique,
      'coefficientG': instance.coefficientG,
      'temperatureExterieure': instance.temperatureExterieure,
      'temperatureInterieure': instance.temperatureInterieure,
      'deperditionsPieces': instance.deperditionsPieces,
      'commentaires': instance.commentaires,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dgi_verification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DGIVerificationAdapter extends TypeAdapter<DGIVerification> {
  @override
  final int typeId = 1;

  @override
  DGIVerification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DGIVerification(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      isConforme: fields[2] as bool,
      nonConformites: (fields[3] as List?)?.cast<String>(),
      mesures: (fields[4] as Map).cast<String, dynamic>(),
      commentaires: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DGIVerification obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.isConforme)
      ..writeByte(3)
      ..write(obj.nonConformites)
      ..writeByte(4)
      ..write(obj.mesures)
      ..writeByte(5)
      ..write(obj.commentaires);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DGIVerificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DGIVerificationImpl _$$DGIVerificationImplFromJson(
        Map<String, dynamic> json) =>
    _$DGIVerificationImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      isConforme: json['isConforme'] as bool,
      nonConformites: (json['nonConformites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mesures: json['mesures'] as Map<String, dynamic>,
      commentaires: json['commentaires'] as String,
    );

Map<String, dynamic> _$$DGIVerificationImplToJson(
        _$DGIVerificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'isConforme': instance.isConforme,
      'nonConformites': instance.nonConformites,
      'mesures': instance.mesures,
      'commentaires': instance.commentaires,
    };

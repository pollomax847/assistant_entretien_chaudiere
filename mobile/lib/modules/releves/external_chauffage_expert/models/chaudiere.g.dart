// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chaudiere.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChaudiereAdapter extends TypeAdapter<Chaudiere> {
  @override
  final int typeId = 0;

  @override
  Chaudiere read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chaudiere(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      puissanceNominale: fields[3] as double,
      rendement: fields[4] as double,
      dateDernierEntretien: fields[5] as DateTime?,
      marque: fields[6] as String?,
      modele: fields[7] as String?,
      numeroSerie: fields[8] as String?,
      dateInstallation: fields[9] as DateTime?,
      adresse: fields[10] as String?,
      client: fields[11] as String?,
      parametresCombustion: (fields[12] as Map?)?.cast<String, dynamic>(),
      photos: (fields[13] as List?)?.cast<String>(),
      conforme: fields[14] as bool,
      nonConformites: (fields[15] as List?)?.cast<String>(),
      mesures: (fields[16] as Map?)?.cast<String, dynamic>(),
      signatureClient: fields[17] as String?,
      signatureTechnicien: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Chaudiere obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.puissanceNominale)
      ..writeByte(4)
      ..write(obj.rendement)
      ..writeByte(5)
      ..write(obj.dateDernierEntretien)
      ..writeByte(6)
      ..write(obj.marque)
      ..writeByte(7)
      ..write(obj.modele)
      ..writeByte(8)
      ..write(obj.numeroSerie)
      ..writeByte(9)
      ..write(obj.dateInstallation)
      ..writeByte(10)
      ..write(obj.adresse)
      ..writeByte(11)
      ..write(obj.client)
      ..writeByte(12)
      ..write(obj.parametresCombustion)
      ..writeByte(13)
      ..write(obj.photos)
      ..writeByte(14)
      ..write(obj.conforme)
      ..writeByte(15)
      ..write(obj.nonConformites)
      ..writeByte(16)
      ..write(obj.mesures)
      ..writeByte(17)
      ..write(obj.signatureClient)
      ..writeByte(18)
      ..write(obj.signatureTechnicien);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChaudiereAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChaudiereImpl _$$ChaudiereImplFromJson(Map<String, dynamic> json) =>
    _$ChaudiereImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      puissanceNominale: (json['puissanceNominale'] as num).toDouble(),
      rendement: (json['rendement'] as num).toDouble(),
      dateDernierEntretien: json['dateDernierEntretien'] == null
          ? null
          : DateTime.parse(json['dateDernierEntretien'] as String),
      marque: json['marque'] as String?,
      modele: json['modele'] as String?,
      numeroSerie: json['numeroSerie'] as String?,
      dateInstallation: json['dateInstallation'] == null
          ? null
          : DateTime.parse(json['dateInstallation'] as String),
      adresse: json['adresse'] as String?,
      client: json['client'] as String?,
      parametresCombustion:
          json['parametresCombustion'] as Map<String, dynamic>?,
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      conforme: json['conforme'] as bool? ?? false,
      nonConformites: (json['nonConformites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mesures: json['mesures'] as Map<String, dynamic>?,
      signatureClient: json['signatureClient'] as String?,
      signatureTechnicien: json['signatureTechnicien'] as String?,
    );

Map<String, dynamic> _$$ChaudiereImplToJson(_$ChaudiereImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'puissanceNominale': instance.puissanceNominale,
      'rendement': instance.rendement,
      'dateDernierEntretien': instance.dateDernierEntretien?.toIso8601String(),
      'marque': instance.marque,
      'modele': instance.modele,
      'numeroSerie': instance.numeroSerie,
      'dateInstallation': instance.dateInstallation?.toIso8601String(),
      'adresse': instance.adresse,
      'client': instance.client,
      'parametresCombustion': instance.parametresCombustion,
      'photos': instance.photos,
      'conforme': instance.conforme,
      'nonConformites': instance.nonConformites,
      'mesures': instance.mesures,
      'signatureClient': instance.signatureClient,
      'signatureTechnicien': instance.signatureTechnicien,
    };

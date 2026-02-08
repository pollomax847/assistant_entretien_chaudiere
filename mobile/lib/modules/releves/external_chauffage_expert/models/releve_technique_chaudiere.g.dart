// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'releve_technique_chaudiere.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReleveTechniqueChaudiereImpl _$$ReleveTechniqueChaudiereImplFromJson(
        Map<String, dynamic> json) =>
    _$ReleveTechniqueChaudiereImpl(
      id: json['id'] as String? ?? '',
      sections: (json['sections'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      photos: (json['photos'] as List<dynamic>)
          .map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
      dateCreation: DateTime.parse(json['dateCreation'] as String),
      adresse: json['adresse'] as String?,
      nomEntreprise: json['nomEntreprise'] as String?,
      nomTechnicien: json['nomTechnicien'] as String?,
      signatureTechnicien: json['signatureTechnicien'] as String?,
      signatureClient: json['signatureClient'] as String?,
    );

Map<String, dynamic> _$$ReleveTechniqueChaudiereImplToJson(
        _$ReleveTechniqueChaudiereImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sections': instance.sections,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'dateCreation': instance.dateCreation.toIso8601String(),
      'adresse': instance.adresse,
      'nomEntreprise': instance.nomEntreprise,
      'nomTechnicien': instance.nomTechnicien,
      'signatureTechnicien': instance.signatureTechnicien,
      'signatureClient': instance.signatureClient,
    };

_$PhotoImpl _$$PhotoImplFromJson(Map<String, dynamic> json) => _$PhotoImpl(
      path: json['path'] as String,
      description: json['description'] as String,
      datePrise: DateTime.parse(json['datePrise'] as String),
    );

Map<String, dynamic> _$$PhotoImplToJson(_$PhotoImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'description': instance.description,
      'datePrise': instance.datePrise.toIso8601String(),
    };

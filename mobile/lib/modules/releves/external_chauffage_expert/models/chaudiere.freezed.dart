// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chaudiere.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Chaudiere _$ChaudiereFromJson(Map<String, dynamic> json) {
  return _Chaudiere.fromJson(json);
}

/// @nodoc
mixin _$Chaudiere {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get type => throw _privateConstructorUsedError;
  @HiveField(3)
  double get puissanceNominale => throw _privateConstructorUsedError;
  @HiveField(4)
  double get rendement => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime? get dateDernierEntretien => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get marque => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get modele => throw _privateConstructorUsedError;
  @HiveField(8)
  String? get numeroSerie => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime? get dateInstallation => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get adresse => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get client => throw _privateConstructorUsedError;
  @HiveField(12)
  Map<String, dynamic>? get parametresCombustion =>
      throw _privateConstructorUsedError;
  @HiveField(13)
  List<String>? get photos => throw _privateConstructorUsedError;
  @HiveField(14)
  bool get conforme => throw _privateConstructorUsedError;
  @HiveField(15)
  List<String>? get nonConformites => throw _privateConstructorUsedError;
  @HiveField(16)
  Map<String, dynamic>? get mesures => throw _privateConstructorUsedError;
  @HiveField(17)
  String? get signatureClient => throw _privateConstructorUsedError;
  @HiveField(18)
  String? get signatureTechnicien => throw _privateConstructorUsedError;

  /// Serializes this Chaudiere to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Chaudiere
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChaudiereCopyWith<Chaudiere> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChaudiereCopyWith<$Res> {
  factory $ChaudiereCopyWith(Chaudiere value, $Res Function(Chaudiere) then) =
      _$ChaudiereCopyWithImpl<$Res, Chaudiere>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String type,
      @HiveField(3) double puissanceNominale,
      @HiveField(4) double rendement,
      @HiveField(5) DateTime? dateDernierEntretien,
      @HiveField(6) String? marque,
      @HiveField(7) String? modele,
      @HiveField(8) String? numeroSerie,
      @HiveField(9) DateTime? dateInstallation,
      @HiveField(10) String? adresse,
      @HiveField(11) String? client,
      @HiveField(12) Map<String, dynamic>? parametresCombustion,
      @HiveField(13) List<String>? photos,
      @HiveField(14) bool conforme,
      @HiveField(15) List<String>? nonConformites,
      @HiveField(16) Map<String, dynamic>? mesures,
      @HiveField(17) String? signatureClient,
      @HiveField(18) String? signatureTechnicien});
}

/// @nodoc
class _$ChaudiereCopyWithImpl<$Res, $Val extends Chaudiere>
    implements $ChaudiereCopyWith<$Res> {
  _$ChaudiereCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Chaudiere
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? puissanceNominale = null,
    Object? rendement = null,
    Object? dateDernierEntretien = freezed,
    Object? marque = freezed,
    Object? modele = freezed,
    Object? numeroSerie = freezed,
    Object? dateInstallation = freezed,
    Object? adresse = freezed,
    Object? client = freezed,
    Object? parametresCombustion = freezed,
    Object? photos = freezed,
    Object? conforme = null,
    Object? nonConformites = freezed,
    Object? mesures = freezed,
    Object? signatureClient = freezed,
    Object? signatureTechnicien = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      puissanceNominale: null == puissanceNominale
          ? _value.puissanceNominale
          : puissanceNominale // ignore: cast_nullable_to_non_nullable
              as double,
      rendement: null == rendement
          ? _value.rendement
          : rendement // ignore: cast_nullable_to_non_nullable
              as double,
      dateDernierEntretien: freezed == dateDernierEntretien
          ? _value.dateDernierEntretien
          : dateDernierEntretien // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      marque: freezed == marque
          ? _value.marque
          : marque // ignore: cast_nullable_to_non_nullable
              as String?,
      modele: freezed == modele
          ? _value.modele
          : modele // ignore: cast_nullable_to_non_nullable
              as String?,
      numeroSerie: freezed == numeroSerie
          ? _value.numeroSerie
          : numeroSerie // ignore: cast_nullable_to_non_nullable
              as String?,
      dateInstallation: freezed == dateInstallation
          ? _value.dateInstallation
          : dateInstallation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      adresse: freezed == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as String?,
      parametresCombustion: freezed == parametresCombustion
          ? _value.parametresCombustion
          : parametresCombustion // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      photos: freezed == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      conforme: null == conforme
          ? _value.conforme
          : conforme // ignore: cast_nullable_to_non_nullable
              as bool,
      nonConformites: freezed == nonConformites
          ? _value.nonConformites
          : nonConformites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      mesures: freezed == mesures
          ? _value.mesures
          : mesures // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      signatureClient: freezed == signatureClient
          ? _value.signatureClient
          : signatureClient // ignore: cast_nullable_to_non_nullable
              as String?,
      signatureTechnicien: freezed == signatureTechnicien
          ? _value.signatureTechnicien
          : signatureTechnicien // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChaudiereImplCopyWith<$Res>
    implements $ChaudiereCopyWith<$Res> {
  factory _$$ChaudiereImplCopyWith(
          _$ChaudiereImpl value, $Res Function(_$ChaudiereImpl) then) =
      __$$ChaudiereImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String type,
      @HiveField(3) double puissanceNominale,
      @HiveField(4) double rendement,
      @HiveField(5) DateTime? dateDernierEntretien,
      @HiveField(6) String? marque,
      @HiveField(7) String? modele,
      @HiveField(8) String? numeroSerie,
      @HiveField(9) DateTime? dateInstallation,
      @HiveField(10) String? adresse,
      @HiveField(11) String? client,
      @HiveField(12) Map<String, dynamic>? parametresCombustion,
      @HiveField(13) List<String>? photos,
      @HiveField(14) bool conforme,
      @HiveField(15) List<String>? nonConformites,
      @HiveField(16) Map<String, dynamic>? mesures,
      @HiveField(17) String? signatureClient,
      @HiveField(18) String? signatureTechnicien});
}

/// @nodoc
class __$$ChaudiereImplCopyWithImpl<$Res>
    extends _$ChaudiereCopyWithImpl<$Res, _$ChaudiereImpl>
    implements _$$ChaudiereImplCopyWith<$Res> {
  __$$ChaudiereImplCopyWithImpl(
      _$ChaudiereImpl _value, $Res Function(_$ChaudiereImpl) _then)
      : super(_value, _then);

  /// Create a copy of Chaudiere
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? puissanceNominale = null,
    Object? rendement = null,
    Object? dateDernierEntretien = freezed,
    Object? marque = freezed,
    Object? modele = freezed,
    Object? numeroSerie = freezed,
    Object? dateInstallation = freezed,
    Object? adresse = freezed,
    Object? client = freezed,
    Object? parametresCombustion = freezed,
    Object? photos = freezed,
    Object? conforme = null,
    Object? nonConformites = freezed,
    Object? mesures = freezed,
    Object? signatureClient = freezed,
    Object? signatureTechnicien = freezed,
  }) {
    return _then(_$ChaudiereImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      puissanceNominale: null == puissanceNominale
          ? _value.puissanceNominale
          : puissanceNominale // ignore: cast_nullable_to_non_nullable
              as double,
      rendement: null == rendement
          ? _value.rendement
          : rendement // ignore: cast_nullable_to_non_nullable
              as double,
      dateDernierEntretien: freezed == dateDernierEntretien
          ? _value.dateDernierEntretien
          : dateDernierEntretien // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      marque: freezed == marque
          ? _value.marque
          : marque // ignore: cast_nullable_to_non_nullable
              as String?,
      modele: freezed == modele
          ? _value.modele
          : modele // ignore: cast_nullable_to_non_nullable
              as String?,
      numeroSerie: freezed == numeroSerie
          ? _value.numeroSerie
          : numeroSerie // ignore: cast_nullable_to_non_nullable
              as String?,
      dateInstallation: freezed == dateInstallation
          ? _value.dateInstallation
          : dateInstallation // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      adresse: freezed == adresse
          ? _value.adresse
          : adresse // ignore: cast_nullable_to_non_nullable
              as String?,
      client: freezed == client
          ? _value.client
          : client // ignore: cast_nullable_to_non_nullable
              as String?,
      parametresCombustion: freezed == parametresCombustion
          ? _value._parametresCombustion
          : parametresCombustion // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      photos: freezed == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      conforme: null == conforme
          ? _value.conforme
          : conforme // ignore: cast_nullable_to_non_nullable
              as bool,
      nonConformites: freezed == nonConformites
          ? _value._nonConformites
          : nonConformites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      mesures: freezed == mesures
          ? _value._mesures
          : mesures // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      signatureClient: freezed == signatureClient
          ? _value.signatureClient
          : signatureClient // ignore: cast_nullable_to_non_nullable
              as String?,
      signatureTechnicien: freezed == signatureTechnicien
          ? _value.signatureTechnicien
          : signatureTechnicien // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChaudiereImpl extends _Chaudiere {
  const _$ChaudiereImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.type,
      @HiveField(3) required this.puissanceNominale,
      @HiveField(4) required this.rendement,
      @HiveField(5) this.dateDernierEntretien,
      @HiveField(6) this.marque,
      @HiveField(7) this.modele,
      @HiveField(8) this.numeroSerie,
      @HiveField(9) this.dateInstallation,
      @HiveField(10) this.adresse,
      @HiveField(11) this.client,
      @HiveField(12) final Map<String, dynamic>? parametresCombustion,
      @HiveField(13) final List<String>? photos,
      @HiveField(14) this.conforme = false,
      @HiveField(15) final List<String>? nonConformites,
      @HiveField(16) final Map<String, dynamic>? mesures,
      @HiveField(17) this.signatureClient,
      @HiveField(18) this.signatureTechnicien})
      : _parametresCombustion = parametresCombustion,
        _photos = photos,
        _nonConformites = nonConformites,
        _mesures = mesures,
        super._();

  factory _$ChaudiereImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChaudiereImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String type;
  @override
  @HiveField(3)
  final double puissanceNominale;
  @override
  @HiveField(4)
  final double rendement;
  @override
  @HiveField(5)
  final DateTime? dateDernierEntretien;
  @override
  @HiveField(6)
  final String? marque;
  @override
  @HiveField(7)
  final String? modele;
  @override
  @HiveField(8)
  final String? numeroSerie;
  @override
  @HiveField(9)
  final DateTime? dateInstallation;
  @override
  @HiveField(10)
  final String? adresse;
  @override
  @HiveField(11)
  final String? client;
  final Map<String, dynamic>? _parametresCombustion;
  @override
  @HiveField(12)
  Map<String, dynamic>? get parametresCombustion {
    final value = _parametresCombustion;
    if (value == null) return null;
    if (_parametresCombustion is EqualUnmodifiableMapView)
      return _parametresCombustion;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _photos;
  @override
  @HiveField(13)
  List<String>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  @HiveField(14)
  final bool conforme;
  final List<String>? _nonConformites;
  @override
  @HiveField(15)
  List<String>? get nonConformites {
    final value = _nonConformites;
    if (value == null) return null;
    if (_nonConformites is EqualUnmodifiableListView) return _nonConformites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _mesures;
  @override
  @HiveField(16)
  Map<String, dynamic>? get mesures {
    final value = _mesures;
    if (value == null) return null;
    if (_mesures is EqualUnmodifiableMapView) return _mesures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @HiveField(17)
  final String? signatureClient;
  @override
  @HiveField(18)
  final String? signatureTechnicien;

  @override
  String toString() {
    return 'Chaudiere(id: $id, name: $name, type: $type, puissanceNominale: $puissanceNominale, rendement: $rendement, dateDernierEntretien: $dateDernierEntretien, marque: $marque, modele: $modele, numeroSerie: $numeroSerie, dateInstallation: $dateInstallation, adresse: $adresse, client: $client, parametresCombustion: $parametresCombustion, photos: $photos, conforme: $conforme, nonConformites: $nonConformites, mesures: $mesures, signatureClient: $signatureClient, signatureTechnicien: $signatureTechnicien)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChaudiereImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.puissanceNominale, puissanceNominale) ||
                other.puissanceNominale == puissanceNominale) &&
            (identical(other.rendement, rendement) ||
                other.rendement == rendement) &&
            (identical(other.dateDernierEntretien, dateDernierEntretien) ||
                other.dateDernierEntretien == dateDernierEntretien) &&
            (identical(other.marque, marque) || other.marque == marque) &&
            (identical(other.modele, modele) || other.modele == modele) &&
            (identical(other.numeroSerie, numeroSerie) ||
                other.numeroSerie == numeroSerie) &&
            (identical(other.dateInstallation, dateInstallation) ||
                other.dateInstallation == dateInstallation) &&
            (identical(other.adresse, adresse) || other.adresse == adresse) &&
            (identical(other.client, client) || other.client == client) &&
            const DeepCollectionEquality()
                .equals(other._parametresCombustion, _parametresCombustion) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.conforme, conforme) ||
                other.conforme == conforme) &&
            const DeepCollectionEquality()
                .equals(other._nonConformites, _nonConformites) &&
            const DeepCollectionEquality().equals(other._mesures, _mesures) &&
            (identical(other.signatureClient, signatureClient) ||
                other.signatureClient == signatureClient) &&
            (identical(other.signatureTechnicien, signatureTechnicien) ||
                other.signatureTechnicien == signatureTechnicien));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        type,
        puissanceNominale,
        rendement,
        dateDernierEntretien,
        marque,
        modele,
        numeroSerie,
        dateInstallation,
        adresse,
        client,
        const DeepCollectionEquality().hash(_parametresCombustion),
        const DeepCollectionEquality().hash(_photos),
        conforme,
        const DeepCollectionEquality().hash(_nonConformites),
        const DeepCollectionEquality().hash(_mesures),
        signatureClient,
        signatureTechnicien
      ]);

  /// Create a copy of Chaudiere
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChaudiereImplCopyWith<_$ChaudiereImpl> get copyWith =>
      __$$ChaudiereImplCopyWithImpl<_$ChaudiereImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChaudiereImplToJson(
      this,
    );
  }
}

abstract class _Chaudiere extends Chaudiere {
  const factory _Chaudiere(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String type,
      @HiveField(3) required final double puissanceNominale,
      @HiveField(4) required final double rendement,
      @HiveField(5) final DateTime? dateDernierEntretien,
      @HiveField(6) final String? marque,
      @HiveField(7) final String? modele,
      @HiveField(8) final String? numeroSerie,
      @HiveField(9) final DateTime? dateInstallation,
      @HiveField(10) final String? adresse,
      @HiveField(11) final String? client,
      @HiveField(12) final Map<String, dynamic>? parametresCombustion,
      @HiveField(13) final List<String>? photos,
      @HiveField(14) final bool conforme,
      @HiveField(15) final List<String>? nonConformites,
      @HiveField(16) final Map<String, dynamic>? mesures,
      @HiveField(17) final String? signatureClient,
      @HiveField(18) final String? signatureTechnicien}) = _$ChaudiereImpl;
  const _Chaudiere._() : super._();

  factory _Chaudiere.fromJson(Map<String, dynamic> json) =
      _$ChaudiereImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get type;
  @override
  @HiveField(3)
  double get puissanceNominale;
  @override
  @HiveField(4)
  double get rendement;
  @override
  @HiveField(5)
  DateTime? get dateDernierEntretien;
  @override
  @HiveField(6)
  String? get marque;
  @override
  @HiveField(7)
  String? get modele;
  @override
  @HiveField(8)
  String? get numeroSerie;
  @override
  @HiveField(9)
  DateTime? get dateInstallation;
  @override
  @HiveField(10)
  String? get adresse;
  @override
  @HiveField(11)
  String? get client;
  @override
  @HiveField(12)
  Map<String, dynamic>? get parametresCombustion;
  @override
  @HiveField(13)
  List<String>? get photos;
  @override
  @HiveField(14)
  bool get conforme;
  @override
  @HiveField(15)
  List<String>? get nonConformites;
  @override
  @HiveField(16)
  Map<String, dynamic>? get mesures;
  @override
  @HiveField(17)
  String? get signatureClient;
  @override
  @HiveField(18)
  String? get signatureTechnicien;

  /// Create a copy of Chaudiere
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChaudiereImplCopyWith<_$ChaudiereImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

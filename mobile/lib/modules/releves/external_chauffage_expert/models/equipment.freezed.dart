// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'equipment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Equipment _$EquipmentFromJson(Map<String, dynamic> json) {
  return _Equipment.fromJson(json);
}

/// @nodoc
mixin _$Equipment {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get equipmentName => throw _privateConstructorUsedError;
  @HiveField(2)
  String get type => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get marque => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get modele => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get numeroSerie => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime? get dateInstallation => throw _privateConstructorUsedError;
  @HiveField(7)
  bool? get conforme => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get dateIntervention => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get nomClient => throw _privateConstructorUsedError;

  /// Serializes this Equipment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EquipmentCopyWith<Equipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentCopyWith<$Res> {
  factory $EquipmentCopyWith(Equipment value, $Res Function(Equipment) then) =
      _$EquipmentCopyWithImpl<$Res, Equipment>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String equipmentName,
      @HiveField(2) String type,
      @HiveField(3) String? marque,
      @HiveField(4) String? modele,
      @HiveField(5) String? numeroSerie,
      @HiveField(6) DateTime? dateInstallation,
      @HiveField(7) bool? conforme,
      @HiveField(8) DateTime? dateIntervention,
      @HiveField(9) String? nomClient});
}

/// @nodoc
class _$EquipmentCopyWithImpl<$Res, $Val extends Equipment>
    implements $EquipmentCopyWith<$Res> {
  _$EquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? equipmentName = null,
    Object? type = null,
    Object? marque = freezed,
    Object? modele = freezed,
    Object? numeroSerie = freezed,
    Object? dateInstallation = freezed,
    Object? conforme = freezed,
    Object? dateIntervention = freezed,
    Object? nomClient = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentName: null == equipmentName
          ? _value.equipmentName
          : equipmentName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
      conforme: freezed == conforme
          ? _value.conforme
          : conforme // ignore: cast_nullable_to_non_nullable
              as bool?,
      dateIntervention: freezed == dateIntervention
          ? _value.dateIntervention
          : dateIntervention // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nomClient: freezed == nomClient
          ? _value.nomClient
          : nomClient // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquipmentImplCopyWith<$Res>
    implements $EquipmentCopyWith<$Res> {
  factory _$$EquipmentImplCopyWith(
          _$EquipmentImpl value, $Res Function(_$EquipmentImpl) then) =
      __$$EquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String equipmentName,
      @HiveField(2) String type,
      @HiveField(3) String? marque,
      @HiveField(4) String? modele,
      @HiveField(5) String? numeroSerie,
      @HiveField(6) DateTime? dateInstallation,
      @HiveField(7) bool? conforme,
      @HiveField(8) DateTime? dateIntervention,
      @HiveField(9) String? nomClient});
}

/// @nodoc
class __$$EquipmentImplCopyWithImpl<$Res>
    extends _$EquipmentCopyWithImpl<$Res, _$EquipmentImpl>
    implements _$$EquipmentImplCopyWith<$Res> {
  __$$EquipmentImplCopyWithImpl(
      _$EquipmentImpl _value, $Res Function(_$EquipmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? equipmentName = null,
    Object? type = null,
    Object? marque = freezed,
    Object? modele = freezed,
    Object? numeroSerie = freezed,
    Object? dateInstallation = freezed,
    Object? conforme = freezed,
    Object? dateIntervention = freezed,
    Object? nomClient = freezed,
  }) {
    return _then(_$EquipmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      equipmentName: null == equipmentName
          ? _value.equipmentName
          : equipmentName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
      conforme: freezed == conforme
          ? _value.conforme
          : conforme // ignore: cast_nullable_to_non_nullable
              as bool?,
      dateIntervention: freezed == dateIntervention
          ? _value.dateIntervention
          : dateIntervention // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      nomClient: freezed == nomClient
          ? _value.nomClient
          : nomClient // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EquipmentImpl extends _Equipment {
  const _$EquipmentImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.equipmentName,
      @HiveField(2) required this.type,
      @HiveField(3) this.marque,
      @HiveField(4) this.modele,
      @HiveField(5) this.numeroSerie,
      @HiveField(6) this.dateInstallation,
      @HiveField(7) this.conforme,
      @HiveField(8) this.dateIntervention,
      @HiveField(9) this.nomClient})
      : super._();

  factory _$EquipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquipmentImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String equipmentName;
  @override
  @HiveField(2)
  final String type;
  @override
  @HiveField(3)
  final String? marque;
  @override
  @HiveField(4)
  final String? modele;
  @override
  @HiveField(5)
  final String? numeroSerie;
  @override
  @HiveField(6)
  final DateTime? dateInstallation;
  @override
  @HiveField(7)
  final bool? conforme;
  @override
  @HiveField(8)
  final DateTime? dateIntervention;
  @override
  @HiveField(9)
  final String? nomClient;

  @override
  String toString() {
    return 'Equipment(id: $id, equipmentName: $equipmentName, type: $type, marque: $marque, modele: $modele, numeroSerie: $numeroSerie, dateInstallation: $dateInstallation, conforme: $conforme, dateIntervention: $dateIntervention, nomClient: $nomClient)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.equipmentName, equipmentName) ||
                other.equipmentName == equipmentName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.marque, marque) || other.marque == marque) &&
            (identical(other.modele, modele) || other.modele == modele) &&
            (identical(other.numeroSerie, numeroSerie) ||
                other.numeroSerie == numeroSerie) &&
            (identical(other.dateInstallation, dateInstallation) ||
                other.dateInstallation == dateInstallation) &&
            (identical(other.conforme, conforme) ||
                other.conforme == conforme) &&
            (identical(other.dateIntervention, dateIntervention) ||
                other.dateIntervention == dateIntervention) &&
            (identical(other.nomClient, nomClient) ||
                other.nomClient == nomClient));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      equipmentName,
      type,
      marque,
      modele,
      numeroSerie,
      dateInstallation,
      conforme,
      dateIntervention,
      nomClient);

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      __$$EquipmentImplCopyWithImpl<_$EquipmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquipmentImplToJson(
      this,
    );
  }
}

abstract class _Equipment extends Equipment {
  const factory _Equipment(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String equipmentName,
      @HiveField(2) required final String type,
      @HiveField(3) final String? marque,
      @HiveField(4) final String? modele,
      @HiveField(5) final String? numeroSerie,
      @HiveField(6) final DateTime? dateInstallation,
      @HiveField(7) final bool? conforme,
      @HiveField(8) final DateTime? dateIntervention,
      @HiveField(9) final String? nomClient}) = _$EquipmentImpl;
  const _Equipment._() : super._();

  factory _Equipment.fromJson(Map<String, dynamic> json) =
      _$EquipmentImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get equipmentName;
  @override
  @HiveField(2)
  String get type;
  @override
  @HiveField(3)
  String? get marque;
  @override
  @HiveField(4)
  String? get modele;
  @override
  @HiveField(5)
  String? get numeroSerie;
  @override
  @HiveField(6)
  DateTime? get dateInstallation;
  @override
  @HiveField(7)
  bool? get conforme;
  @override
  @HiveField(8)
  DateTime? get dateIntervention;
  @override
  @HiveField(9)
  String? get nomClient;

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

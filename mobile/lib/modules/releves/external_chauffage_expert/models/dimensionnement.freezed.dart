// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dimensionnement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Dimensionnement _$DimensionnementFromJson(Map<String, dynamic> json) {
  return _Dimensionnement.fromJson(json);
}

/// @nodoc
mixin _$Dimensionnement {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(2)
  double get surfaceHabitable => throw _privateConstructorUsedError;
  @HiveField(3)
  double get hauteurSousPafond => throw _privateConstructorUsedError;
  @HiveField(4)
  String get zoneClimatique => throw _privateConstructorUsedError;
  @HiveField(5)
  double get coefficientG => throw _privateConstructorUsedError;
  @HiveField(6)
  double get temperatureExterieure => throw _privateConstructorUsedError;
  @HiveField(7)
  double get temperatureInterieure => throw _privateConstructorUsedError;
  @HiveField(8)
  Map<String, double> get deperditionsPieces =>
      throw _privateConstructorUsedError;
  @HiveField(9)
  String? get commentaires => throw _privateConstructorUsedError;

  /// Serializes this Dimensionnement to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dimensionnement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DimensionnementCopyWith<Dimensionnement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DimensionnementCopyWith<$Res> {
  factory $DimensionnementCopyWith(
          Dimensionnement value, $Res Function(Dimensionnement) then) =
      _$DimensionnementCopyWithImpl<$Res, Dimensionnement>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) DateTime date,
      @HiveField(2) double surfaceHabitable,
      @HiveField(3) double hauteurSousPafond,
      @HiveField(4) String zoneClimatique,
      @HiveField(5) double coefficientG,
      @HiveField(6) double temperatureExterieure,
      @HiveField(7) double temperatureInterieure,
      @HiveField(8) Map<String, double> deperditionsPieces,
      @HiveField(9) String? commentaires});
}

/// @nodoc
class _$DimensionnementCopyWithImpl<$Res, $Val extends Dimensionnement>
    implements $DimensionnementCopyWith<$Res> {
  _$DimensionnementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dimensionnement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? surfaceHabitable = null,
    Object? hauteurSousPafond = null,
    Object? zoneClimatique = null,
    Object? coefficientG = null,
    Object? temperatureExterieure = null,
    Object? temperatureInterieure = null,
    Object? deperditionsPieces = null,
    Object? commentaires = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      surfaceHabitable: null == surfaceHabitable
          ? _value.surfaceHabitable
          : surfaceHabitable // ignore: cast_nullable_to_non_nullable
              as double,
      hauteurSousPafond: null == hauteurSousPafond
          ? _value.hauteurSousPafond
          : hauteurSousPafond // ignore: cast_nullable_to_non_nullable
              as double,
      zoneClimatique: null == zoneClimatique
          ? _value.zoneClimatique
          : zoneClimatique // ignore: cast_nullable_to_non_nullable
              as String,
      coefficientG: null == coefficientG
          ? _value.coefficientG
          : coefficientG // ignore: cast_nullable_to_non_nullable
              as double,
      temperatureExterieure: null == temperatureExterieure
          ? _value.temperatureExterieure
          : temperatureExterieure // ignore: cast_nullable_to_non_nullable
              as double,
      temperatureInterieure: null == temperatureInterieure
          ? _value.temperatureInterieure
          : temperatureInterieure // ignore: cast_nullable_to_non_nullable
              as double,
      deperditionsPieces: null == deperditionsPieces
          ? _value.deperditionsPieces
          : deperditionsPieces // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      commentaires: freezed == commentaires
          ? _value.commentaires
          : commentaires // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DimensionnementImplCopyWith<$Res>
    implements $DimensionnementCopyWith<$Res> {
  factory _$$DimensionnementImplCopyWith(_$DimensionnementImpl value,
          $Res Function(_$DimensionnementImpl) then) =
      __$$DimensionnementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) DateTime date,
      @HiveField(2) double surfaceHabitable,
      @HiveField(3) double hauteurSousPafond,
      @HiveField(4) String zoneClimatique,
      @HiveField(5) double coefficientG,
      @HiveField(6) double temperatureExterieure,
      @HiveField(7) double temperatureInterieure,
      @HiveField(8) Map<String, double> deperditionsPieces,
      @HiveField(9) String? commentaires});
}

/// @nodoc
class __$$DimensionnementImplCopyWithImpl<$Res>
    extends _$DimensionnementCopyWithImpl<$Res, _$DimensionnementImpl>
    implements _$$DimensionnementImplCopyWith<$Res> {
  __$$DimensionnementImplCopyWithImpl(
      _$DimensionnementImpl _value, $Res Function(_$DimensionnementImpl) _then)
      : super(_value, _then);

  /// Create a copy of Dimensionnement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? surfaceHabitable = null,
    Object? hauteurSousPafond = null,
    Object? zoneClimatique = null,
    Object? coefficientG = null,
    Object? temperatureExterieure = null,
    Object? temperatureInterieure = null,
    Object? deperditionsPieces = null,
    Object? commentaires = freezed,
  }) {
    return _then(_$DimensionnementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      surfaceHabitable: null == surfaceHabitable
          ? _value.surfaceHabitable
          : surfaceHabitable // ignore: cast_nullable_to_non_nullable
              as double,
      hauteurSousPafond: null == hauteurSousPafond
          ? _value.hauteurSousPafond
          : hauteurSousPafond // ignore: cast_nullable_to_non_nullable
              as double,
      zoneClimatique: null == zoneClimatique
          ? _value.zoneClimatique
          : zoneClimatique // ignore: cast_nullable_to_non_nullable
              as String,
      coefficientG: null == coefficientG
          ? _value.coefficientG
          : coefficientG // ignore: cast_nullable_to_non_nullable
              as double,
      temperatureExterieure: null == temperatureExterieure
          ? _value.temperatureExterieure
          : temperatureExterieure // ignore: cast_nullable_to_non_nullable
              as double,
      temperatureInterieure: null == temperatureInterieure
          ? _value.temperatureInterieure
          : temperatureInterieure // ignore: cast_nullable_to_non_nullable
              as double,
      deperditionsPieces: null == deperditionsPieces
          ? _value._deperditionsPieces
          : deperditionsPieces // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      commentaires: freezed == commentaires
          ? _value.commentaires
          : commentaires // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DimensionnementImpl extends _Dimensionnement {
  const _$DimensionnementImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.date,
      @HiveField(2) required this.surfaceHabitable,
      @HiveField(3) required this.hauteurSousPafond,
      @HiveField(4) required this.zoneClimatique,
      @HiveField(5) required this.coefficientG,
      @HiveField(6) required this.temperatureExterieure,
      @HiveField(7) required this.temperatureInterieure,
      @HiveField(8) required final Map<String, double> deperditionsPieces,
      @HiveField(9) this.commentaires})
      : _deperditionsPieces = deperditionsPieces,
        super._();

  factory _$DimensionnementImpl.fromJson(Map<String, dynamic> json) =>
      _$$DimensionnementImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final DateTime date;
  @override
  @HiveField(2)
  final double surfaceHabitable;
  @override
  @HiveField(3)
  final double hauteurSousPafond;
  @override
  @HiveField(4)
  final String zoneClimatique;
  @override
  @HiveField(5)
  final double coefficientG;
  @override
  @HiveField(6)
  final double temperatureExterieure;
  @override
  @HiveField(7)
  final double temperatureInterieure;
  final Map<String, double> _deperditionsPieces;
  @override
  @HiveField(8)
  Map<String, double> get deperditionsPieces {
    if (_deperditionsPieces is EqualUnmodifiableMapView)
      return _deperditionsPieces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deperditionsPieces);
  }

  @override
  @HiveField(9)
  final String? commentaires;

  @override
  String toString() {
    return 'Dimensionnement(id: $id, date: $date, surfaceHabitable: $surfaceHabitable, hauteurSousPafond: $hauteurSousPafond, zoneClimatique: $zoneClimatique, coefficientG: $coefficientG, temperatureExterieure: $temperatureExterieure, temperatureInterieure: $temperatureInterieure, deperditionsPieces: $deperditionsPieces, commentaires: $commentaires)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DimensionnementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.surfaceHabitable, surfaceHabitable) ||
                other.surfaceHabitable == surfaceHabitable) &&
            (identical(other.hauteurSousPafond, hauteurSousPafond) ||
                other.hauteurSousPafond == hauteurSousPafond) &&
            (identical(other.zoneClimatique, zoneClimatique) ||
                other.zoneClimatique == zoneClimatique) &&
            (identical(other.coefficientG, coefficientG) ||
                other.coefficientG == coefficientG) &&
            (identical(other.temperatureExterieure, temperatureExterieure) ||
                other.temperatureExterieure == temperatureExterieure) &&
            (identical(other.temperatureInterieure, temperatureInterieure) ||
                other.temperatureInterieure == temperatureInterieure) &&
            const DeepCollectionEquality()
                .equals(other._deperditionsPieces, _deperditionsPieces) &&
            (identical(other.commentaires, commentaires) ||
                other.commentaires == commentaires));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      date,
      surfaceHabitable,
      hauteurSousPafond,
      zoneClimatique,
      coefficientG,
      temperatureExterieure,
      temperatureInterieure,
      const DeepCollectionEquality().hash(_deperditionsPieces),
      commentaires);

  /// Create a copy of Dimensionnement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DimensionnementImplCopyWith<_$DimensionnementImpl> get copyWith =>
      __$$DimensionnementImplCopyWithImpl<_$DimensionnementImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DimensionnementImplToJson(
      this,
    );
  }
}

abstract class _Dimensionnement extends Dimensionnement {
  const factory _Dimensionnement(
      {@HiveField(0) required final String id,
      @HiveField(1) required final DateTime date,
      @HiveField(2) required final double surfaceHabitable,
      @HiveField(3) required final double hauteurSousPafond,
      @HiveField(4) required final String zoneClimatique,
      @HiveField(5) required final double coefficientG,
      @HiveField(6) required final double temperatureExterieure,
      @HiveField(7) required final double temperatureInterieure,
      @HiveField(8) required final Map<String, double> deperditionsPieces,
      @HiveField(9) final String? commentaires}) = _$DimensionnementImpl;
  const _Dimensionnement._() : super._();

  factory _Dimensionnement.fromJson(Map<String, dynamic> json) =
      _$DimensionnementImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  DateTime get date;
  @override
  @HiveField(2)
  double get surfaceHabitable;
  @override
  @HiveField(3)
  double get hauteurSousPafond;
  @override
  @HiveField(4)
  String get zoneClimatique;
  @override
  @HiveField(5)
  double get coefficientG;
  @override
  @HiveField(6)
  double get temperatureExterieure;
  @override
  @HiveField(7)
  double get temperatureInterieure;
  @override
  @HiveField(8)
  Map<String, double> get deperditionsPieces;
  @override
  @HiveField(9)
  String? get commentaires;

  /// Create a copy of Dimensionnement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DimensionnementImplCopyWith<_$DimensionnementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dgi_verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DGIVerification _$DGIVerificationFromJson(Map<String, dynamic> json) {
  return _DGIVerification.fromJson(json);
}

/// @nodoc
mixin _$DGIVerification {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(2)
  bool get isConforme => throw _privateConstructorUsedError;
  @HiveField(3)
  List<String>? get nonConformites => throw _privateConstructorUsedError;
  @HiveField(4)
  Map<String, dynamic> get mesures => throw _privateConstructorUsedError;
  @HiveField(5)
  String get commentaires => throw _privateConstructorUsedError;

  /// Serializes this DGIVerification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DGIVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DGIVerificationCopyWith<DGIVerification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DGIVerificationCopyWith<$Res> {
  factory $DGIVerificationCopyWith(
          DGIVerification value, $Res Function(DGIVerification) then) =
      _$DGIVerificationCopyWithImpl<$Res, DGIVerification>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) DateTime date,
      @HiveField(2) bool isConforme,
      @HiveField(3) List<String>? nonConformites,
      @HiveField(4) Map<String, dynamic> mesures,
      @HiveField(5) String commentaires});
}

/// @nodoc
class _$DGIVerificationCopyWithImpl<$Res, $Val extends DGIVerification>
    implements $DGIVerificationCopyWith<$Res> {
  _$DGIVerificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DGIVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? isConforme = null,
    Object? nonConformites = freezed,
    Object? mesures = null,
    Object? commentaires = null,
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
      isConforme: null == isConforme
          ? _value.isConforme
          : isConforme // ignore: cast_nullable_to_non_nullable
              as bool,
      nonConformites: freezed == nonConformites
          ? _value.nonConformites
          : nonConformites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      mesures: null == mesures
          ? _value.mesures
          : mesures // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      commentaires: null == commentaires
          ? _value.commentaires
          : commentaires // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DGIVerificationImplCopyWith<$Res>
    implements $DGIVerificationCopyWith<$Res> {
  factory _$$DGIVerificationImplCopyWith(_$DGIVerificationImpl value,
          $Res Function(_$DGIVerificationImpl) then) =
      __$$DGIVerificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) DateTime date,
      @HiveField(2) bool isConforme,
      @HiveField(3) List<String>? nonConformites,
      @HiveField(4) Map<String, dynamic> mesures,
      @HiveField(5) String commentaires});
}

/// @nodoc
class __$$DGIVerificationImplCopyWithImpl<$Res>
    extends _$DGIVerificationCopyWithImpl<$Res, _$DGIVerificationImpl>
    implements _$$DGIVerificationImplCopyWith<$Res> {
  __$$DGIVerificationImplCopyWithImpl(
      _$DGIVerificationImpl _value, $Res Function(_$DGIVerificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of DGIVerification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? isConforme = null,
    Object? nonConformites = freezed,
    Object? mesures = null,
    Object? commentaires = null,
  }) {
    return _then(_$DGIVerificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isConforme: null == isConforme
          ? _value.isConforme
          : isConforme // ignore: cast_nullable_to_non_nullable
              as bool,
      nonConformites: freezed == nonConformites
          ? _value._nonConformites
          : nonConformites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      mesures: null == mesures
          ? _value._mesures
          : mesures // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      commentaires: null == commentaires
          ? _value.commentaires
          : commentaires // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DGIVerificationImpl extends _DGIVerification {
  const _$DGIVerificationImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.date,
      @HiveField(2) required this.isConforme,
      @HiveField(3) final List<String>? nonConformites,
      @HiveField(4) required final Map<String, dynamic> mesures,
      @HiveField(5) required this.commentaires})
      : _nonConformites = nonConformites,
        _mesures = mesures,
        super._();

  factory _$DGIVerificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$DGIVerificationImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final DateTime date;
  @override
  @HiveField(2)
  final bool isConforme;
  final List<String>? _nonConformites;
  @override
  @HiveField(3)
  List<String>? get nonConformites {
    final value = _nonConformites;
    if (value == null) return null;
    if (_nonConformites is EqualUnmodifiableListView) return _nonConformites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic> _mesures;
  @override
  @HiveField(4)
  Map<String, dynamic> get mesures {
    if (_mesures is EqualUnmodifiableMapView) return _mesures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_mesures);
  }

  @override
  @HiveField(5)
  final String commentaires;

  @override
  String toString() {
    return 'DGIVerification(id: $id, date: $date, isConforme: $isConforme, nonConformites: $nonConformites, mesures: $mesures, commentaires: $commentaires)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DGIVerificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.isConforme, isConforme) ||
                other.isConforme == isConforme) &&
            const DeepCollectionEquality()
                .equals(other._nonConformites, _nonConformites) &&
            const DeepCollectionEquality().equals(other._mesures, _mesures) &&
            (identical(other.commentaires, commentaires) ||
                other.commentaires == commentaires));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      date,
      isConforme,
      const DeepCollectionEquality().hash(_nonConformites),
      const DeepCollectionEquality().hash(_mesures),
      commentaires);

  /// Create a copy of DGIVerification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DGIVerificationImplCopyWith<_$DGIVerificationImpl> get copyWith =>
      __$$DGIVerificationImplCopyWithImpl<_$DGIVerificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DGIVerificationImplToJson(
      this,
    );
  }
}

abstract class _DGIVerification extends DGIVerification {
  const factory _DGIVerification(
          {@HiveField(0) required final String id,
          @HiveField(1) required final DateTime date,
          @HiveField(2) required final bool isConforme,
          @HiveField(3) final List<String>? nonConformites,
          @HiveField(4) required final Map<String, dynamic> mesures,
          @HiveField(5) required final String commentaires}) =
      _$DGIVerificationImpl;
  const _DGIVerification._() : super._();

  factory _DGIVerification.fromJson(Map<String, dynamic> json) =
      _$DGIVerificationImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  DateTime get date;
  @override
  @HiveField(2)
  bool get isConforme;
  @override
  @HiveField(3)
  List<String>? get nonConformites;
  @override
  @HiveField(4)
  Map<String, dynamic> get mesures;
  @override
  @HiveField(5)
  String get commentaires;

  /// Create a copy of DGIVerification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DGIVerificationImplCopyWith<_$DGIVerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

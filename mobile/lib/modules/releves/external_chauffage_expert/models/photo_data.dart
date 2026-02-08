// models/photo_data.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';

class PhotoData {
  final String id;
  final Uint8List data;
  final String? description;
  final DateTime dateCreation;
  final String? category;
  final List<Annotation> annotations;

  PhotoData({
    required this.id,
    required this.data,
    this.description,
    DateTime? dateCreation,
    this.category,
    List<Annotation>? annotations,
  })  : dateCreation = dateCreation ?? DateTime.now(),
        annotations = annotations ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': base64Encode(data),
      'description': description,
      'dateCreation': dateCreation.toIso8601String(),
      'category': category,
      'annotations': annotations.map((a) => a.toMap()).toList(),
    };
  }

  factory PhotoData.fromMap(Map<String, dynamic> map) {
    return PhotoData(
      id: map['id'] as String,
      data: base64Decode(map['data'] as String),
      description: map['description'] as String?,
      dateCreation: DateTime.parse(map['dateCreation'] as String),
      category: map['category'] as String?,
      annotations: (map['annotations'] as List<dynamic>?)
              ?.map((a) => Annotation.fromMap(a as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': base64Encode(data),
      'description': description,
      'dateCreation': dateCreation.toIso8601String(),
      'category': category,
      'annotations': annotations.map((a) => a.toMap()).toList(),
    };
  }

  factory PhotoData.fromJson(Map<String, dynamic> json) {
    return PhotoData(
      id: json['id'] as String,
      data: base64Decode(json['data'] as String),
      description: json['description'] as String?,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
      category: json['category'] as String?,
      annotations: (json['annotations'] as List<dynamic>?)
              ?.map((a) => Annotation.fromMap(a as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  PhotoData copyWith({
    String? id,
    Uint8List? data,
    String? description,
    DateTime? dateCreation,
    String? category,
    List<Annotation>? annotations,
  }) {
    return PhotoData(
      id: id ?? this.id,
      data: data ?? this.data,
      description: description ?? this.description,
      dateCreation: dateCreation ?? this.dateCreation,
      category: category ?? this.category,
      annotations: annotations ?? List.from(this.annotations),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          listEquals(data, other.data) &&
          description == other.description &&
          dateCreation == other.dateCreation &&
          category == other.category &&
          listEquals(annotations, other.annotations);

  @override
  int get hashCode => Object.hash(
        id,
        Object.hashAll(data),
        description,
        dateCreation,
        category,
        Object.hashAll(annotations),
      );

  @override
  String toString() {
    return 'PhotoData{id: $id, data: ${base64Encode(data)}, description: $description, dateCreation: $dateCreation, category: $category, annotations: $annotations}';
  }
}

class Annotation {
  final String id;
  final String text;
  final double x;
  final double y;
  final String? pictogrammeId;

  Annotation({
    required this.id,
    required this.text,
    required this.x,
    required this.y,
    this.pictogrammeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'x': x,
      'y': y,
      'pictogrammeId': pictogrammeId,
    };
  }

  factory Annotation.fromMap(Map<String, dynamic> map) {
    return Annotation(
      id: map['id'] as String,
      text: map['text'] as String,
      x: (map['x'] as num).toDouble(),
      y: (map['y'] as num).toDouble(),
      pictogrammeId: map['pictogrammeId'] as String?,
    );
  }

  Annotation copyWith({
    String? id,
    String? text,
    double? x,
    double? y,
    String? pictogrammeId,
  }) {
    return Annotation(
      id: id ?? this.id,
      text: text ?? this.text,
      x: x ?? this.x,
      y: y ?? this.y,
      pictogrammeId: pictogrammeId ?? this.pictogrammeId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Annotation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          x == other.x &&
          y == other.y &&
          pictogrammeId == other.pictogrammeId;

  @override
  int get hashCode => Object.hash(id, text, x, y, pictogrammeId);

  @override
  String toString() {
    return 'Annotation{id: $id, text: $text, x: $x, y: $y, pictogrammeId: $pictogrammeId}';
  }
}

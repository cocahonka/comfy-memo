import 'package:flutter/foundation.dart';

enum SelfVerifyType {
  none,
  written,
}

@immutable
final class Flashcard implements Comparable<Flashcard> {
  const Flashcard({
    required this.id,
    required this.title,
    required this.term,
    required this.definition,
    required this.selfVerifyType,
  });

  factory Flashcard.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {
        'id': final int id,
        'title': final String title,
        'term': final String term,
        'definition': final String definition,
        'selfVerifyType': final String selfVerifyTypeName,
      } =>
        Flashcard(
          id: id,
          title: title,
          term: term,
          definition: definition,
          selfVerifyType: SelfVerifyType.values.byName(selfVerifyTypeName),
        ),
      _ => throw FormatException('Invalid JSON Schema for Flashcard: $json'),
    };
  }

  final int id;
  final String title;
  final String term;
  final String definition;
  final SelfVerifyType selfVerifyType;

  Map<String, Object?> toJson() => {
        'id': id,
        'title': title,
        'term': term,
        'definition': definition,
        'selfVerifyType': selfVerifyType.name,
      };

  Flashcard copyWith({
    int? id,
    String? title,
    String? term,
    String? definition,
    SelfVerifyType? selfVerifyType,
  }) {
    return Flashcard(
      id: id ?? this.id,
      title: title ?? this.title,
      term: term ?? this.term,
      definition: definition ?? this.definition,
      selfVerifyType: selfVerifyType ?? this.selfVerifyType,
    );
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        term,
        definition,
        selfVerifyType,
      ]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Flashcard &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            title == other.title &&
            term == other.term &&
            definition == other.definition &&
            selfVerifyType == other.selfVerifyType;
  }

  @override
  int compareTo(Flashcard other) => id.compareTo(other.id);

  @override
  String toString() =>
      'Flashcard($id, $title, $term, $definition, $selfVerifyType)';
}

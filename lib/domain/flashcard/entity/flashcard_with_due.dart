import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_with_due.freezed.dart';

@freezed
base class FlashcardWithDue with _$FlashcardWithDue {
  const factory FlashcardWithDue({
    required int id,
    required String title,
    required String term,
    required String definition,
    required SelfVerify selfVerify,
    required DateTime due,
  }) = _FlashcardWithDue;

  const FlashcardWithDue._();

  Flashcard toEntity() => Flashcard(
        id: id,
        title: title,
        term: term,
        definition: definition,
        selfVerify: selfVerify,
      );
}

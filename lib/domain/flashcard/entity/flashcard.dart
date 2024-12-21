import 'package:comfy_memo/domain/flashcard/entity/flashcard_with_due.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard.freezed.dart';

enum SelfVerify { none, written }

@freezed
class Flashcard with _$Flashcard {
  const factory Flashcard({
    required int id,
    required String title,
    required String term,
    required String definition,
    required SelfVerify selfVerify,
  }) = _Flashcard;

  const Flashcard._();

  FlashcardWithDue withDue(DateTime due) => FlashcardWithDue(
        id: id,
        title: title,
        term: term,
        definition: definition,
        selfVerify: selfVerify,
        due: due,
      );
}

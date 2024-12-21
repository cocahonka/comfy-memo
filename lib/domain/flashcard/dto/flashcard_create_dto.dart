import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_create_dto.freezed.dart';

@freezed
class FlashcardCreateDto with _$FlashcardCreateDto {
  const factory FlashcardCreateDto({
    required String title,
    required String term,
    required String definition,
    required SelfVerify selfVerify,
  }) = _FlashcardCreateDto;
}

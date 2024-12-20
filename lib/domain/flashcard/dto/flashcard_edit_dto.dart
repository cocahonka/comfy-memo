import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_edit_dto.freezed.dart';

@freezed
base class FlashcardEditDto with _$FlashcardEditDto {
  const factory FlashcardEditDto({
    required String? title,
    required String? term,
    required String? definition,
    required SelfVerify? selfVerify,
  }) = _FlashcardEditDto;
}

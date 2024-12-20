import 'dart:async';

import 'package:comfy_memo/domain/common/controller.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/domain/flashcard/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_edit_controller.freezed.dart';

@freezed
sealed class FlashcardEditState with _$FlashcardEditState {
  const factory FlashcardEditState.loading() = Loading;
  const factory FlashcardEditState.idle() = Idle;
  const factory FlashcardEditState.success() = Success;
  const factory FlashcardEditState.error(String message) = Error;
}

base class FlashcardEditController extends Controller<FlashcardEditState> {
  FlashcardEditController({required IFlashcardRepository repository})
      : _flashcardRepository = repository,
        super(const FlashcardEditState.idle());

  final IFlashcardRepository _flashcardRepository;

  Future<void> create(FlashcardCreateDto dto) => handle(() async {
        await _flashcardRepository.create(dto);
      });

  Future<void> edit(FlashcardEditDto dto, int cardId) => handle(() async {
        await _flashcardRepository.update(dto, cardId);
      });

  Future<void> delete(int cardId) => handle(() async {
        await _flashcardRepository.delete(cardId);
      });

  @override
  Future<void> handle(Future<void> Function() action) async {
    setState(const FlashcardEditState.loading());
    try {
      await action();
    } on Object {
      setState(
        const FlashcardEditState.error('An unknown error occurred'),
      );
    }
    setState(const FlashcardEditState.success());
  }
}

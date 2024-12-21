import 'dart:async';

import 'package:comfy_memo/domain/common/controller.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:comfy_memo/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/domain/review_log/repository/repository.dart';
import 'package:comfy_memo/domain/scheduler_entry/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_edit_controller.freezed.dart';

@freezed
sealed class EditState with _$EditState {
  const factory EditState.loading() = EditState$Loading;
  const factory EditState.idle() = EditState$Idle;
  const factory EditState.success() = EditState$Success;
  const factory EditState.error(String message) = EditState$Error;
}

base class FlashcardEditController extends Controller<EditState> {
  FlashcardEditController({
    required IFlashcardRepository flashcardRepository,
    required ISchedulerEntryRepository schedulerEntryRepository,
    required IReviewLogRepository reviewLogRepository,
  })  : _flashcardRepository = flashcardRepository,
        _schedulerEntryRepository = schedulerEntryRepository,
        _reviewLogRepository = reviewLogRepository,
        super(const EditState.idle());

  final IFlashcardRepository _flashcardRepository;
  final ISchedulerEntryRepository _schedulerEntryRepository;
  final IReviewLogRepository _reviewLogRepository;

  Future<void> create(
    FlashcardCreateDto dto, {
    void Function(Flashcard)? created,
  }) =>
      handle(() async {
        final flashcard = await _flashcardRepository.create(dto);
        await _schedulerEntryRepository.create(flashcard.id);
        created?.call(flashcard);
      });

  Future<void> edit(
    FlashcardEditDto dto,
    int cardId, {
    void Function()? edited,
  }) =>
      handle(() async {
        await _flashcardRepository.update(dto, cardId);
        edited?.call();
      });

  Future<void> delete(
    int cardId, {
    void Function()? deleted,
  }) =>
      handle(() async {
        await _flashcardRepository.delete(cardId);
        await _schedulerEntryRepository.delete(cardId);
        await _reviewLogRepository.delete(cardId);
        deleted?.call();
      });

  @override
  Future<void> handle(Future<void> Function() action) async {
    setState(const EditState.loading());
    try {
      await action();
    } on Object {
      setState(
        const EditState.error('An unknown error occurred'),
      );
    }
    setState(const EditState.success());
  }
}

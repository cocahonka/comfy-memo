import 'dart:async';

import 'package:comfy_memo/src/domain/algorithm/entity/algorithm_type.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_with_due_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/src/domain/preferences/repository/repository.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/repository/repository.dart';
import 'package:meta/meta.dart';

@immutable
final class GetFlashcardsUsecase {
  const GetFlashcardsUsecase({
    required IFlashcardRepository flashcardRepository,
    required ISchedulerEntryRepository schedulerEntryRepository,
    required IPreferencesRepository preferencesRepository,
  })  : _flashcardRepository = flashcardRepository,
        _schedulerEntryRepository = schedulerEntryRepository,
        _preferencesRepository = preferencesRepository;

  final IFlashcardRepository _flashcardRepository;
  final ISchedulerEntryRepository _schedulerEntryRepository;
  final IPreferencesRepository _preferencesRepository;

  Stream<List<FlashcardWithDueEntity>> call() async* {
    await for (final flashcards in _flashcardRepository.flashcards) {
      final transformedFlashcards = await Future.wait(
        flashcards.map(_transform),
      );

      yield transformedFlashcards;
    }
  }

  Future<FlashcardWithDueEntity> _transform(FlashcardEntity flashcard) async {
    final algorithmType =
        await _preferencesRepository.fetchAlgorithmType(flashcard.id);
    final scheduler = await switch (algorithmType) {
      AlgorithmType.fsrs => _schedulerEntryRepository.fetchFsrs(flashcard.id)
    };
    return FlashcardWithDueEntity(
      id: flashcard.id,
      title: flashcard.title,
      term: flashcard.term,
      definition: flashcard.definition,
      selfVerifyType: flashcard.selfVerifyType,
      due: scheduler.due,
    );
  }
}

import 'dart:async';

import 'package:comfy_memo/domain/algorithm/entity/algorithm_type.dart';
import 'package:comfy_memo/domain/common/controller.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard_with_due.dart';
import 'package:comfy_memo/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/domain/preferences/repository/repository.dart';
import 'package:comfy_memo/domain/scheduler_entry/repository/repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashcard_overview_controller.freezed.dart';

@freezed
sealed class OverviewState with _$OverviewState {
  const factory OverviewState.loading([
    @Default([]) List<FlashcardWithDue> flashcards,
  ]) = OverviewState$Loading;
  const factory OverviewState.idle(List<FlashcardWithDue> flashcards) =
      OverviewState$Idle;
  const factory OverviewState.error(
    List<FlashcardWithDue> flashcards,
    String message,
  ) = OverviewState$Error;
}

base class FlashcardOverviewController extends Controller<OverviewState> {
  FlashcardOverviewController({
    required IFlashcardRepository flashcardRepository,
    required ISchedulerEntryRepository schedulerEntryRepository,
    required IPreferencesRepository preferencesRepository,
  })  : _flashcardRepository = flashcardRepository,
        _schedulerEntryRepository = schedulerEntryRepository,
        _preferencesRepository = preferencesRepository,
        super(const OverviewState.loading());

  final IFlashcardRepository _flashcardRepository;
  final ISchedulerEntryRepository _schedulerEntryRepository;
  final IPreferencesRepository _preferencesRepository;
  Timer? _dueTimer;

  Future<void> fetchAll() async => handle(() async {
        final flashcards = await _flashcardRepository.fetch();
        final transformed = await Future.wait(flashcards.map(_transform))
          ..sort(_compareForSort);
        setState(OverviewState.idle(transformed));
      });

  Future<void> fetchSchedulerOnly() async => handle(() async {
        final transformed = await Future.wait(
          value.flashcards.map((card) => card.toEntity()).map(_transform),
        )
          ..sort(_compareForSort);
        setState(OverviewState.idle(transformed));
      });

  int _compareForSort(FlashcardWithDue first, FlashcardWithDue second) {
    if (first.isRepetitionTime && second.isRepetitionTime) {
      return first.id.compareTo(second.id);
    } else if (first.isRepetitionTime) {
      return -1;
    } else {
      return 1;
    }
  }

  Future<FlashcardWithDue> _transform(Flashcard flashcard) async {
    final algorithmType = await _preferencesRepository.fetch(flashcard.id);
    final scheduler = await switch (algorithmType) {
      AlgorithmType.fsrs => _schedulerEntryRepository.fetchFsrs(flashcard.id)
    };
    return flashcard.withDue(scheduler.due);
  }

  void _scheduleDueNotifications(List<FlashcardWithDue> flashcards) {
    _dueTimer?.cancel();

    final now = DateTime.now().toUtc();
    final upcomingDueDates = flashcards
        .map((card) => card.due)
        .where((due) => due.isAfter(now))
        .toList()
      ..sort();

    void scheduleNext(Iterable<DateTime> remaining) {
      if (remaining.isEmpty) return;

      final now = DateTime.now().toUtc();
      final nextDue = remaining.first;
      final duration = nextDue.difference(now);

      if (duration.isNegative || duration == Duration.zero) {
        notifyListeners();
        scheduleNext(remaining.skip(1));
        return;
      }

      _dueTimer = Timer(duration + const Duration(milliseconds: 500), () {
        notifyListeners();
        scheduleNext(remaining.skip(1));
      });
    }

    scheduleNext(upcomingDueDates);
  }

  @override
  void dispose() {
    _dueTimer?.cancel();
    super.dispose();
  }

  @override
  Future<void> handle(Future<void> Function() action) async {
    try {
      await action();
      _scheduleDueNotifications(value.flashcards);
    } on Object {
      setState(
        OverviewState.error(
          value.flashcards,
          'An unknown error occurred',
        ),
      );
    }
  }
}

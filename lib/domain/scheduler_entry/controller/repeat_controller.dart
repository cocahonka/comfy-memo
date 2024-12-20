import 'package:comfy_memo/domain/algorithm/entity/algorithm_type.dart';
import 'package:comfy_memo/domain/algorithm/entity/repeat_rating.dart';
import 'package:comfy_memo/domain/algorithm/fsrs/fsrs.dart';
import 'package:comfy_memo/domain/common/controller.dart';
import 'package:comfy_memo/domain/preferences/repository/repository.dart';
import 'package:comfy_memo/domain/review_log/repository/repository.dart';
import 'package:comfy_memo/domain/scheduler_entry/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'repeat_controller.freezed.dart';

@freezed
sealed class RepeatState with _$RepeatState {
  const factory RepeatState.loading() = Loading;
  const factory RepeatState.idle() = Idle;
  const factory RepeatState.success(DateTime nextDue) = Success;
  const factory RepeatState.error(String message) = Error;
}

base class RepeatController extends Controller<RepeatState> {
  RepeatController({
    required ISchedulerEntryRepository schedulerEntryRepository,
    required IReviewLogRepository reviewLogRepository,
    required IPreferencesRepository preferencesRepository,
    required FsrsAlgorithm fsrsAlgorithm,
  })  : _schedulerEntryRepository = schedulerEntryRepository,
        _reviewLogRepository = reviewLogRepository,
        _preferencesRepository = preferencesRepository,
        _fsrsAlgorithm = fsrsAlgorithm,
        super(const RepeatState.idle());

  final ISchedulerEntryRepository _schedulerEntryRepository;
  final IReviewLogRepository _reviewLogRepository;
  final IPreferencesRepository _preferencesRepository;
  final FsrsAlgorithm _fsrsAlgorithm;

  Future<void> rate({
    required RepeatRating rating,
    required int cardId,
    DateTime? repeatTime,
  }) async =>
      handle(() async {
        final algorithmType = await _preferencesRepository.fetch(cardId);
        return switch (algorithmType) {
          AlgorithmType.fsrs => _rateFsrs(cardId, rating, repeatTime)
        };
      });

  Future<void> _rateFsrs(
    int cardId,
    RepeatRating rating,
    DateTime? repeatTime,
  ) async {
    final scheduler = await _schedulerEntryRepository.fetchFsrs(cardId);
    final (:schedulerUpdateDto, :reviewDto) = _fsrsAlgorithm.process(
      rating: rating,
      scheduler: scheduler,
      repeatTime: repeatTime,
    );
    await _schedulerEntryRepository.updateFsrs(
      schedulerUpdateDto,
      cardId,
    );
    await _reviewLogRepository.logFsrs(reviewDto, cardId);
    setState(RepeatState.success(schedulerUpdateDto.due));
  }

  @override
  Future<void> handle(Future<void> Function() action) async {
    setState(const RepeatState.loading());
    try {
      await action();
    } on Object {
      setState(
        const RepeatState.error('An unknown error occurred'),
      );
    }
  }
}

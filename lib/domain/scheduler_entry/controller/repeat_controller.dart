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
  const factory RepeatState.initial({
    required RepeatRating? rating,
    required bool hasEverAnswered,
    required bool hasEverRated,
  }) = RepeatState$Initial;
  const factory RepeatState.answered({
    required RepeatRating? rating,
    required bool hasEverAnswered,
    required bool hasEverRated,
  }) = RepeatState$Answered;
  const factory RepeatState.loading({
    required RepeatRating? rating,
    required bool hasEverAnswered,
    required bool hasEverRated,
  }) = RepeatState$Loading;
  const factory RepeatState.error(
    String message, {
    required RepeatRating? rating,
    required bool hasEverAnswered,
    required bool hasEverRated,
  }) = RepeatState$Error;
  const factory RepeatState.success(
    DateTime due, {
    required RepeatRating? rating,
    required bool hasEverAnswered,
    required bool hasEverRated,
  }) = RepeatState$Success;
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
        super(
          const RepeatState.initial(
            rating: null,
            hasEverAnswered: false,
            hasEverRated: false,
          ),
        );

  final ISchedulerEntryRepository _schedulerEntryRepository;
  final IReviewLogRepository _reviewLogRepository;
  final IPreferencesRepository _preferencesRepository;
  final FsrsAlgorithm _fsrsAlgorithm;

  void answer() {
    if (value is RepeatState$Answered) {
      setState(
        RepeatState.initial(
          rating: value.rating,
          hasEverAnswered: true,
          hasEverRated: value.hasEverRated,
        ),
      );
    } else {
      setState(
        RepeatState.answered(
          rating: value.rating,
          hasEverAnswered: true,
          hasEverRated: value.hasEverRated,
        ),
      );
    }
  }

  void rate(RepeatRating? rating, {void Function()? onFirstRate}) {
    if (!value.hasEverRated && rating != null) onFirstRate?.call();

    setState(
      value.copyWith(
        rating: rating,
        hasEverAnswered: true,
        hasEverRated: value.hasEverRated || rating != null,
      ),
    );
  }

  Future<void> submitRating({
    required int cardId,
    DateTime? submitTime,
  }) async {
    final RepeatRating rating;
    if (value.rating case final nonNullableRating?) {
      rating = nonNullableRating;
    } else {
      return;
    }

    return handle(() async {
      final algorithmType = await _preferencesRepository.fetch(cardId);
      await switch (algorithmType) {
        AlgorithmType.fsrs => _submitFsrs(
            cardId: cardId,
            rating: rating,
            submitTime: submitTime,
          ),
      };
    });
  }

  Future<void> _submitFsrs({
    required int cardId,
    required RepeatRating rating,
    DateTime? submitTime,
  }) async {
    final scheduler = await _schedulerEntryRepository.fetchFsrs(cardId);
    final (:schedulerUpdateDto, :reviewDto) = _fsrsAlgorithm.process(
      rating: rating,
      scheduler: scheduler,
      repeatTime: submitTime,
    );
    await _schedulerEntryRepository.updateFsrs(
      schedulerUpdateDto,
      cardId,
    );
    await _reviewLogRepository.logFsrs(reviewDto, cardId);
    setState(
      RepeatState.success(
        schedulerUpdateDto.due,
        rating: rating,
        hasEverRated: true,
        hasEverAnswered: true,
      ),
    );
  }

  @override
  Future<void> handle(Future<void> Function() action) async {
    setState(
      RepeatState.loading(
        rating: value.rating,
        hasEverAnswered: value.hasEverAnswered,
        hasEverRated: value.hasEverRated,
      ),
    );
    try {
      await action();
    } on Object {
      setState(
        RepeatState.error(
          'An unknown error occurred',
          rating: value.rating,
          hasEverAnswered: value.hasEverAnswered,
          hasEverRated: value.hasEverRated,
        ),
      );
    }
  }
}

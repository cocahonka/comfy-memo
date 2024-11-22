import 'package:comfy_memo/src/domain/algorithm/entity/algorithm_type.dart';
import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
import 'package:comfy_memo/src/domain/preferences/repository/repository.dart';
import 'package:comfy_memo/src/domain/review_log/repository/repository.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/repository/repository.dart';
import 'package:meta/meta.dart';

@immutable
final class RateFlashcardUsecase {
  const RateFlashcardUsecase({
    required ISchedulerEntryRepository schedulerEntryRepository,
    required IReviewLogRepository reviewLogRepository,
    required IPreferencesRepository preferencesRepository,
    required FsrsAlgorithmUsecase fsrsAlgorithmUsecase,
  })  : _schedulerEntryRepository = schedulerEntryRepository,
        _reviewLogRepository = reviewLogRepository,
        _preferencesRepository = preferencesRepository,
        _fsrsAlgorithmUsecase = fsrsAlgorithmUsecase;

  final ISchedulerEntryRepository _schedulerEntryRepository;
  final IReviewLogRepository _reviewLogRepository;
  final IPreferencesRepository _preferencesRepository;
  final FsrsAlgorithmUsecase _fsrsAlgorithmUsecase;

  Future<DateTime> call({
    required int cardId,
    required LearningRating rating,
  }) async {
    final algorithmType =
        await _preferencesRepository.fetchAlgorithmType(cardId);

    switch (algorithmType) {
      case AlgorithmType.fsrs:
        final scheduler = await _schedulerEntryRepository.fetchFsrs(cardId);
        final (:schedulerUpdateDto, :reviewDto) =
            _fsrsAlgorithmUsecase(rating: rating, scheduler: scheduler);

        await _schedulerEntryRepository.updateFsrs(cardId, schedulerUpdateDto);
        await _reviewLogRepository.logFsrs(cardId, reviewDto);
        return schedulerUpdateDto.due;
    }
  }
}

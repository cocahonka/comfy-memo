import 'package:comfy_memo/src/domain/algorithm/entity/algorithm_type.dart';
import 'package:comfy_memo/src/domain/algorithm/entity/learning_rating.dart';
import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/rate_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/preferences/repository/repository.dart';
import 'package:comfy_memo/src/domain/review_log/repository/repository.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/entity/fsrs_scheduler_entry_entity.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/repository/repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([
  MockSpec<ISchedulerEntryRepository>(as: #MockSchedulerEntryRepository),
  MockSpec<IReviewLogRepository>(as: #MockReviewLogRepository),
  MockSpec<IPreferencesRepository>(as: #MockPreferencesRepository),
])
import 'rate_flashcard_usecase_test.mocks.dart';

void main() {
  late MockSchedulerEntryRepository mockSchedulerEntryRepository;
  late MockReviewLogRepository mockReviewLogRepository;
  late MockPreferencesRepository mockPreferencesRepository;
  late FsrsAlgorithmUsecase fsrsAlgorithmUsecase;
  late RateFlashcardUsecase usecase;

  late FsrsSchedulerEntryEntity dummyFsrsSchedulerEntryEntity;
  late LearningRating dummyLearningRating;

  setUp(() {
    mockSchedulerEntryRepository = MockSchedulerEntryRepository();
    mockReviewLogRepository = MockReviewLogRepository();
    mockPreferencesRepository = MockPreferencesRepository();
    fsrsAlgorithmUsecase = FsrsAlgorithmUsecase();
    usecase = RateFlashcardUsecase(
      schedulerEntryRepository: mockSchedulerEntryRepository,
      reviewLogRepository: mockReviewLogRepository,
      preferencesRepository: mockPreferencesRepository,
      fsrsAlgorithmUsecase: fsrsAlgorithmUsecase,
    );

    dummyFsrsSchedulerEntryEntity = FsrsSchedulerEntryEntity(
      cardId: 0,
      due: DateTime.now().toUtc(),
      scheduledDays: 0,
      elapsedDays: 0,
      reps: 0,
      lapses: 0,
      lastReview: null,
      schedulerId: 0,
      stability: 0,
      difficulty: 0,
      learningState: LearningState.newState,
    );
    dummyLearningRating = LearningRating.good;

    provideDummy(dummyFsrsSchedulerEntryEntity);
    provideDummy(dummyLearningRating);
  });

  tearDown(resetMockitoState);

  test(
    'RateFlashcardUsecase correct working with dependencies '
    'and return expected value when algorithm type is fsrs',
    () async {
      provideDummy(AlgorithmType.fsrs);

      final now = DateTime.utc(2022, 11, 29, 12, 30, 0, 0);

      final (:schedulerUpdateDto, :reviewDto) = fsrsAlgorithmUsecase(
        rating: dummyLearningRating,
        scheduler: dummyFsrsSchedulerEntryEntity,
        repeatTime: now,
      );

      final result = await usecase(
        cardId: 0,
        rating: dummyLearningRating,
        repeatTime: now,
      );
      expect(result, equals(schedulerUpdateDto.due));

      verifyInOrder([
        mockPreferencesRepository.fetchAlgorithmType(0),
        mockSchedulerEntryRepository.fetchFsrs(0),
        mockSchedulerEntryRepository.updateFsrs(0, schedulerUpdateDto),
        mockReviewLogRepository.logFsrs(0, reviewDto),
      ]);

      verifyNoMoreInteractions(mockSchedulerEntryRepository);
      verifyNoMoreInteractions(mockReviewLogRepository);
      verifyNoMoreInteractions(mockPreferencesRepository);
    },
  );
}

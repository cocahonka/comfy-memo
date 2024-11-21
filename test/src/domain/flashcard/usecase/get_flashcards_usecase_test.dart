import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/maping/maping.dart';
import 'package:comfy_memo/src/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/get_flashcards_usecase.dart';
import 'package:comfy_memo/src/domain/preferences/repository/repository.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/entity/fsrs_scheduler_entry_entity.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/repository/repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([
  MockSpec<IFlashcardRepository>(as: #MockFlashcardRepository),
  MockSpec<ISchedulerEntryRepository>(as: #MockSchedulerEntryRepository),
  MockSpec<IPreferencesRepository>(as: #MockPreferencesRepository),
])
import 'get_flashcards_usecase_test.mocks.dart';

void main() {
  late GetFlashcardsUsecase usecase;
  late MockFlashcardRepository mockFlashcardRepository;
  late MockSchedulerEntryRepository mockSchedulerEntryRepository;
  late MockPreferencesRepository mockPreferencesRepository;
  late DateTime mockDue;

  setUp(() {
    mockFlashcardRepository = MockFlashcardRepository();
    mockSchedulerEntryRepository = MockSchedulerEntryRepository();
    mockPreferencesRepository = MockPreferencesRepository();
    usecase = GetFlashcardsUsecase(
      flashcardRepository: mockFlashcardRepository,
      schedulerEntryRepository: mockSchedulerEntryRepository,
      preferencesRepository: mockPreferencesRepository,
    );
    mockDue = DateTime.now();
    provideDummy(
      FsrsSchedulerEntryEntity(
        cardId: 0,
        due: mockDue,
        scheduledDays: 0,
        elapsedDays: 0,
        reps: 0,
        lapses: 0,
        lastReview: mockDue,
        schedulerId: 0,
        stability: 0,
        difficulty: 0,
        learningState: LearningState.newState,
      ),
    );
  });

  tearDown(resetMockitoState);

  test('GetFlashcardsUsecase emits transformed flashcards', () async {
    const flashcards = [
      FlashcardEntity(
        id: 0,
        title: 'title',
        term: 'term',
        definition: 'definition',
        selfVerifyType: SelfVerifyType.none,
      ),
      FlashcardEntity(
        id: 1,
        title: 'title',
        term: 'term',
        definition: 'definition',
        selfVerifyType: SelfVerifyType.none,
      ),
    ];

    when(mockFlashcardRepository.flashcards).thenAnswer(
      (_) => Stream.fromIterable([flashcards]),
    );

    final stream = usecase();

    await expectLater(
      stream,
      emitsInOrder([
        flashcards.map((flashcard) => flashcard.withDue(mockDue)).toList(),
      ]),
    );

    verifyInOrder([
      mockFlashcardRepository.flashcards,
      mockPreferencesRepository.fetchAlgorithmType(any),
      mockPreferencesRepository.fetchAlgorithmType(any),
      mockSchedulerEntryRepository.fetchFsrs(any),
      mockSchedulerEntryRepository.fetchFsrs(any),
    ]);
    verifyNoMoreInteractions(mockFlashcardRepository);
    verifyNoMoreInteractions(mockPreferencesRepository);
    verifyNoMoreInteractions(mockSchedulerEntryRepository);
  });
}

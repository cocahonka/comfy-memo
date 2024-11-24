import 'package:comfy_memo/src/domain/algorithm/entity/algorithm_type.dart';
import 'package:comfy_memo/src/domain/algorithm/usecase/fsrs_algorithm_usecase.dart';
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

  late DateTime dummyDue;

  setUp(() {
    mockFlashcardRepository = MockFlashcardRepository();
    mockSchedulerEntryRepository = MockSchedulerEntryRepository();
    mockPreferencesRepository = MockPreferencesRepository();
    usecase = GetFlashcardsUsecase(
      flashcardRepository: mockFlashcardRepository,
      schedulerEntryRepository: mockSchedulerEntryRepository,
      preferencesRepository: mockPreferencesRepository,
    );

    dummyDue = DateTime.now().toUtc();

    provideDummy(
      FsrsSchedulerEntryEntity(
        cardId: 0,
        due: dummyDue,
        scheduledDays: 0,
        elapsedDays: 0,
        reps: 0,
        lapses: 0,
        lastReview: null,
        schedulerId: 0,
        stability: 0,
        difficulty: 0,
        learningState: LearningState.newState,
      ),
    );
  });

  tearDown(resetMockitoState);

  test(
      'GetFlashcardsUsecase emits transformed flashcards '
      'when the algorithm preference of all cards is fsrs', () async {
    provideDummy(AlgorithmType.fsrs);

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
        title: 'another title',
        term: 'another term',
        definition: 'another definition',
        selfVerifyType: SelfVerifyType.written,
      ),
    ];

    when(mockFlashcardRepository.flashcards).thenAnswer(
      (_) => Stream.fromIterable([flashcards]),
    );

    final stream = usecase();

    await expectLater(
      stream,
      emitsInOrder([
        flashcards.map((flashcard) => flashcard.withDue(dummyDue)).toList(),
      ]),
    );

    verifyInOrder([
      mockFlashcardRepository.flashcards,
      mockPreferencesRepository.fetchAlgorithmType(0),
      mockPreferencesRepository.fetchAlgorithmType(1),
      mockSchedulerEntryRepository.fetchFsrs(0),
      mockSchedulerEntryRepository.fetchFsrs(1),
    ]);
    verifyNoMoreInteractions(mockFlashcardRepository);
    verifyNoMoreInteractions(mockPreferencesRepository);
    verifyNoMoreInteractions(mockSchedulerEntryRepository);
  });
}

import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/exception/exception.dart';
import 'package:comfy_memo/src/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/create_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/repository/repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([
  MockSpec<IFlashcardRepository>(as: #MockFlashcardRepository),
  MockSpec<ISchedulerEntryRepository>(as: #MockSchedulerEntryRepository),
])
import 'create_flashcard_usecase_test.mocks.dart';

void main() {
  late CreateFlashcardUsecase usecase;
  late MockFlashcardRepository mockFlashcardRepository;
  late MockSchedulerEntryRepository mockSchedulerEntryRepository;

  setUp(() {
    mockFlashcardRepository = MockFlashcardRepository();
    mockSchedulerEntryRepository = MockSchedulerEntryRepository();
    usecase = CreateFlashcardUsecase(
      flashcardRepository: mockFlashcardRepository,
      schedulerEntryRepository: mockSchedulerEntryRepository,
    );
    provideDummy(
      const FlashcardEntity(
        id: 0,
        title: 'title',
        term: 'term',
        definition: 'definition',
        selfVerifyType: SelfVerifyType.none,
      ),
    );
  });

  tearDown(resetMockitoState);

  test(
      'CreateFlashcardUsecase throws FlashcardValidationException '
      'when title is empty', () async {
    const dto = FlashcardCreateDto(
      title: '',
      term: '1',
      definition: '1',
      selfVerifyType: SelfVerifyType.none,
    );
    final future = usecase(flashcardCreateData: dto);
    await expectLater(future, throwsA(isA<FlashcardValidationException>()));
  });

  test(
      'CreateFlashcardUsecase throws FlashcardValidationException '
      'when term is empty', () async {
    const dto = FlashcardCreateDto(
      title: '1',
      term: '',
      definition: '1',
      selfVerifyType: SelfVerifyType.none,
    );
    final future = usecase(flashcardCreateData: dto);
    await expectLater(future, throwsA(isA<FlashcardValidationException>()));
  });

  test(
      'CreateFlashcardUsecase throws FlashcardValidationException '
      'when definition is empty', () async {
    const dto = FlashcardCreateDto(
      title: '1',
      term: '1',
      definition: '',
      selfVerifyType: SelfVerifyType.none,
    );
    final future = usecase(flashcardCreateData: dto);
    await expectLater(future, throwsA(isA<FlashcardValidationException>()));
  });

  test('CreateFlashcardUsecase trigger create method in both repositories',
      () async {
    const dto = FlashcardCreateDto(
      title: 'title',
      term: 'term',
      definition: 'definition',
      selfVerifyType: SelfVerifyType.none,
    );

    await usecase(flashcardCreateData: dto);

    verify(mockFlashcardRepository.create(any)).called(1);
    verifyNoMoreInteractions(mockFlashcardRepository);

    verify(mockSchedulerEntryRepository.create(any)).called(1);
    verifyNoMoreInteractions(mockSchedulerEntryRepository);
  });
}

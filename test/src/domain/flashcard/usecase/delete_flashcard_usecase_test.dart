import 'package:comfy_memo/src/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/delete_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/review_log/repository/repository.dart';
import 'package:comfy_memo/src/domain/scheduler_entry/repository/repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([
  MockSpec<IFlashcardRepository>(as: #MockFlashcardRepository),
  MockSpec<ISchedulerEntryRepository>(as: #MockSchedulerEntryRepository),
  MockSpec<IReviewLogRepository>(as: #MockReviewLogRepository),
])
import 'delete_flashcard_usecase_test.mocks.dart';

void main() {
  late DeleteFlashcardUsecase usecase;
  late MockFlashcardRepository mockFlashcardRepository;
  late MockSchedulerEntryRepository mockSchedulerEntryRepository;
  late MockReviewLogRepository mockReviewLogRepository;

  setUp(() {
    mockFlashcardRepository = MockFlashcardRepository();
    mockSchedulerEntryRepository = MockSchedulerEntryRepository();
    mockReviewLogRepository = MockReviewLogRepository();
    usecase = DeleteFlashcardUsecase(
      flashcardRepository: mockFlashcardRepository,
      schedulerEntryRepository: mockSchedulerEntryRepository,
      reviewLogRepository: mockReviewLogRepository,
    );
  });

  tearDown(resetMockitoState);

  test('DeleteFlashcardUsecase deletes all related data', () async {
    const cardId = 0;
    await usecase(cardId: cardId);
    verify(mockFlashcardRepository.delete(cardId)).called(1);
    verify(mockSchedulerEntryRepository.delete(cardId)).called(1);
    verify(mockReviewLogRepository.delete(cardId)).called(1);

    verifyNoMoreInteractions(mockFlashcardRepository);
    verifyNoMoreInteractions(mockSchedulerEntryRepository);
    verifyNoMoreInteractions(mockReviewLogRepository);
  });
}

import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/exception/exception.dart';
import 'package:comfy_memo/src/domain/flashcard/repository/repository.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/edit_flashcard_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([
  MockSpec<IFlashcardRepository>(as: #MockFlashcardRepository),
])
import 'edit_flashcard_usecase_test.mocks.dart';

void main() {
  late EditFlashcardUsecase usecase;
  late MockFlashcardRepository mockFlashcardRepository;

  setUp(() async {
    mockFlashcardRepository = MockFlashcardRepository();
    usecase = EditFlashcardUsecase(
      flashcardRepository: mockFlashcardRepository,
    );
  });

  tearDown(resetMockitoState);

  test(
      'EditFlashcardUsecase throws FlashcardValidationException '
      'when title is empty', () async {
    const dto = FlashcardEditDto(
      title: '',
      term: null,
      definition: null,
      selfVerifyType: null,
    );
    final future = usecase(
      flashcardIdForEditing: 0,
      flashcardEditData: dto,
    );
    await expectLater(future, throwsA(isA<FlashcardValidationException>()));
  });

  test(
      'EditFlashcardUsecase throws FlashcardValidationException '
      'when term is empty', () async {
    const dto = FlashcardEditDto(
      title: null,
      term: '',
      definition: null,
      selfVerifyType: null,
    );
    final future = usecase(
      flashcardIdForEditing: 0,
      flashcardEditData: dto,
    );
    await expectLater(future, throwsA(isA<FlashcardValidationException>()));
  });

  test(
      'EditFlashcardUsecase throws FlashcardValidationException '
      'when definition is empty', () async {
    const dto = FlashcardEditDto(
      title: null,
      term: null,
      definition: '',
      selfVerifyType: null,
    );
    final future = usecase(
      flashcardIdForEditing: 0,
      flashcardEditData: dto,
    );
    await expectLater(future, throwsA(isA<FlashcardValidationException>()));
  });

  test('EditFlashcardUsecase trigger update method in repository', () async {
    const dto = FlashcardEditDto(
      title: 'New title',
      term: 'New term',
      definition: 'New definition',
      selfVerifyType: SelfVerifyType.written,
    );

    await usecase(
      flashcardIdForEditing: 0,
      flashcardEditData: dto,
    );

    verify(mockFlashcardRepository.update(0, dto)).called(1);
    verifyNoMoreInteractions(mockFlashcardRepository);
  });
}

import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';

base class FlashcardInMemoryDataSource {
  final Map<int, FlashcardEntity> _flashcards = {};

  int _elementsForAllTime = 0;
  int get _nextId => _elementsForAllTime++;

  FlashcardEntity create(FlashcardCreateDto dto) {
    final id = _nextId;
    _flashcards[id] = FlashcardEntity(
      id: id,
      title: dto.title,
      term: dto.term,
      definition: dto.definition,
      selfVerifyType: dto.selfVerifyType,
    );

    return _flashcards[id]!;
  }

  FlashcardEntity fetch(int id) => _flashcards[id]!;

  List<FlashcardEntity> fetchAll() => [..._flashcards.values];

  void update(int id, FlashcardEditDto dto) {
    final oldFlashcard = _flashcards[id]!;
    _flashcards[id] = FlashcardEntity(
      id: id,
      title: dto.title ?? oldFlashcard.title,
      term: dto.term ?? oldFlashcard.term,
      definition: dto.definition ?? oldFlashcard.definition,
      selfVerifyType: dto.selfVerifyType ?? oldFlashcard.selfVerifyType,
    );
  }

  void delete(int id) => _flashcards.remove(id);
}

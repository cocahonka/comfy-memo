import 'package:comfy_memo/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:comfy_memo/domain/flashcard/repository/repository.dart';

base class FlashcardRepositoryImpl implements IFlashcardRepository {
  final Map<int, Flashcard> _flashcards = {};

  int _elementsForAllTime = 0;
  int get _nextId => _elementsForAllTime++;

  @override
  Future<Flashcard> create(FlashcardCreateDto dto) async {
    final id = _nextId;
    _flashcards[id] = Flashcard(
      id: id,
      title: dto.title,
      term: dto.term,
      definition: dto.definition,
      selfVerify: dto.selfVerify,
    );
    return _flashcards[id]!;
  }

  @override
  Future<void> delete(int cardId) async {
    _flashcards.remove(cardId);
  }

  @override
  Future<List<Flashcard>> fetch() async {
    return _flashcards.values.toList();
  }

  @override
  Future<void> update(FlashcardEditDto dto, int cardId) async {
    final old = _flashcards[cardId]!;
    _flashcards[cardId] = Flashcard(
      id: cardId,
      title: dto.title ?? old.title,
      term: dto.term ?? old.term,
      definition: dto.definition ?? old.definition,
      selfVerify: dto.selfVerify ?? old.selfVerify,
    );
  }
}

import 'dart:async';

import 'package:comfy_memo/src/data/flashcard/source/data_source.dart';
import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/repository/repository.dart';
import 'package:meta/meta.dart';

@immutable
base class FlashcardRepository implements IFlashcardRepository {
  FlashcardRepository({
    required FlashcardInMemoryDataSource source,
  })  : _source = source,
        _controller = StreamController.broadcast();

  final FlashcardInMemoryDataSource _source;
  final StreamController<List<FlashcardEntity>> _controller;

  Future<void> _updateController() async {
    _controller.sink.add(_source.fetchAll());
  }

  @override
  Future<FlashcardEntity> create(FlashcardCreateDto params) async {
    final model = _source.create(params);
    await _updateController();
    return model;
  }

  @override
  Future<void> delete(int id) async {
    _source.delete(id);
    await _updateController();
  }

  @override
  Future<FlashcardEntity> fetch(int id) async {
    return _source.fetch(id);
  }

  @override
  Future<List<FlashcardEntity>> fetchAll() async {
    return _source.fetchAll();
  }

  @override
  Stream<List<FlashcardEntity>> get flashcards => _controller.stream;

  @override
  Future<void> update(int id, FlashcardEditDto params) async {
    await _updateController();
    return _source.update(id, params);
  }
}

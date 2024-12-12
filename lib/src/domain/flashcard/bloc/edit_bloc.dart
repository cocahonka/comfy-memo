import 'dart:async';

import 'package:comfy_memo/src/domain/common/bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_edit_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/exception/exception.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/create_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/delete_flashcard_usecase.dart';
import 'package:comfy_memo/src/domain/flashcard/usecase/edit_flashcard_usecase.dart';
import 'package:meta/meta.dart';

@immutable
sealed class FlashcardEditEvent {
  const FlashcardEditEvent();
}

final class FlashcardEditEvent$Create extends FlashcardEditEvent {
  const FlashcardEditEvent$Create({required this.dto});

  final FlashcardCreateDto dto;
}

final class FlashcardEditEvent$Edit extends FlashcardEditEvent {
  const FlashcardEditEvent$Edit({required this.cardId, required this.dto});

  final int cardId;
  final FlashcardEditDto dto;
}

final class FlashcardEditEvent$Delete extends FlashcardEditEvent {
  const FlashcardEditEvent$Delete({required this.cardId});

  final int cardId;
}

@immutable
sealed class FlashcardEditState {
  const FlashcardEditState();
}

final class FlashcardEditState$Idle extends FlashcardEditState {
  const FlashcardEditState$Idle();
}

final class FlashcardEditState$Loading extends FlashcardEditState {
  const FlashcardEditState$Loading();
}

final class FlashcardEditState$Success extends FlashcardEditState {
  const FlashcardEditState$Success();
}

final class FlashcardEditState$Error extends FlashcardEditState {
  const FlashcardEditState$Error(this.message);

  final String message;
}

base class FlashcardEditBloc
    extends Bloc<FlashcardEditEvent, FlashcardEditState> {
  FlashcardEditBloc({
    required CreateFlashcardUsecase createFlashcardUsecase,
    required EditFlashcardUsecase editFlashcardUsecase,
    required DeleteFlashcardUsecase deleteFlashcardUsecase,
  })  : _createFlashcardUsecase = createFlashcardUsecase,
        _editFlashcardUsecase = editFlashcardUsecase,
        _deleteFlashcardUsecase = deleteFlashcardUsecase,
        super(const FlashcardEditState$Idle());

  final CreateFlashcardUsecase _createFlashcardUsecase;
  final EditFlashcardUsecase _editFlashcardUsecase;
  final DeleteFlashcardUsecase _deleteFlashcardUsecase;

  @override
  Stream<FlashcardEditState> mapEventToState(FlashcardEditEvent event) async* {
    yield* switch (event) {
      final FlashcardEditEvent$Create e => _create(e),
      final FlashcardEditEvent$Edit e => _edit(e),
      final FlashcardEditEvent$Delete e => _delete(e),
    };
  }

  Stream<FlashcardEditState> _handle(Future<void> Function() action) async* {
    yield const FlashcardEditState$Loading();
    try {
      await action();
    } on FlashcardValidationException catch (e) {
      yield FlashcardEditState$Error(e.message);
    } on Object {
      yield const FlashcardEditState$Error('Unknown error');
      rethrow;
    }
    yield const FlashcardEditState$Success();
  }

  Stream<FlashcardEditState> _create(FlashcardEditEvent$Create event) async* {
    yield* _handle(
      () async => _createFlashcardUsecase(flashcardCreateData: event.dto),
    );
  }

  Stream<FlashcardEditState> _edit(FlashcardEditEvent$Edit event) async* {
    yield* _handle(
      () => _editFlashcardUsecase(
        flashcardEditData: event.dto,
        flashcardIdForEditing: event.cardId,
      ),
    );
  }

  Stream<FlashcardEditState> _delete(FlashcardEditEvent$Delete event) async* {
    yield* _handle(
      () => _deleteFlashcardUsecase(cardId: event.cardId),
    );
  }
}

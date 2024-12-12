import 'dart:async';

import 'package:comfy_memo/src/common/bloc_scope.dart';
import 'package:comfy_memo/src/common/constants.dart';
import 'package:comfy_memo/src/domain/flashcard/bloc/edit_bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/bloc/overview_bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_with_due_entity.dart';
import 'package:comfy_memo/src/presentation/add_card/add_card_screen.dart';
import 'package:comfy_memo/src/presentation/main_list/repeat_card.dart';
import 'package:comfy_memo/src/presentation/repeat/repeat_screen.dart';
import 'package:flutter/material.dart';

base class MainListScreen extends StatelessWidget {
  const MainListScreen({super.key});

  Future<void> _onAdd(BuildContext context) async {
    final editBloc = BlocScope.of(context).editBloc;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog.fullscreen(
        child: AddCardScreen.createMode(
          onCreate: (dto) => editBloc.sink.add(
            FlashcardEditEvent$Create(dto: dto),
          ),
        ),
      ),
    );
  }

  Future<void> _onEdit(
    BuildContext context,
    FlashcardWithDueEntity flashcard,
  ) async {
    final editBloc = BlocScope.of(context).editBloc;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog.fullscreen(
        child: AddCardScreen.editMode(
          onEdit: (dto) => editBloc.sink.add(
            FlashcardEditEvent$Edit(
              cardId: flashcard.id,
              dto: dto,
            ),
          ),
          onDelete: () => editBloc.sink.add(
            FlashcardEditEvent$Delete(cardId: flashcard.id),
          ),
          titleInitialValue: flashcard.title,
          termInitialValue: flashcard.term,
          definitionInitialValue: flashcard.definition,
          selfVerifyTypeInitialValue: flashcard.selfVerifyType,
        ),
      ),
    );
  }

  Future<void> _onOpen(
    BuildContext context,
    FlashcardWithDueEntity flashcard,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RepeatScreen(
          title: flashcard.title,
          term: flashcard.term,
          definition: flashcard.definition,
          selfVerifyType: flashcard.selfVerifyType,
          onRate: (rating) {
            // Todo implement this
          },
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text('An error occured: $message'),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final blocScope = BlocScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: colorScheme.onTertiaryContainer,
        backgroundColor: colorScheme.tertiaryContainer,
        child: const Icon(Icons.add_rounded),
        onPressed: () async => _onAdd(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder(
          stream: blocScope.overviewBloc.stream,
          builder: (context, snapshot) {
            final state = snapshot.data;

            if (state == null || state is FlashcardOverviewState$Loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (state is FlashcardOverviewState$Error) {
              _showError(context, state.message);
            }

            final flashcards = state.flashcards;
            return ListView.builder(
              itemCount: flashcards.length,
              itemBuilder: (_, index) {
                final card = flashcards[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == flashcards.length - 1 ? 16 : 12,
                  ),
                  child: RepeatCard(
                    title: card.title,
                    term: card.term,
                    isRepeatTime: card.isRepetitionTime,
                    onOpen: () async => _onOpen(context, card),
                    onEdit: () async => _onEdit(context, card),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:comfy_memo/src/common/bloc_scope.dart';
import 'package:comfy_memo/src/common/constants.dart';
import 'package:comfy_memo/src/domain/flashcard/bloc/edit_bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/bloc/overview_bloc.dart';
import 'package:comfy_memo/src/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_entity.dart';
import 'package:comfy_memo/src/domain/flashcard/entity/flashcard_with_due_entity.dart';
import 'package:comfy_memo/src/presentation/add_card/add_card_screen.dart';
import 'package:comfy_memo/src/presentation/main_list/generate_random_data.dart';
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
        builder: (context) => RepeatScreen(entity: flashcard),
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

  void _generateSampleData(FlashcardEditBloc editBloc) {
    final random = Random();
    for (var i = 0; i < 3; ++i) {
      editBloc.sink.add(
        FlashcardEditEvent$Create(
          dto: FlashcardCreateDto(
            title: kTitles[i],
            term: kTerms[i],
            definition: kDefinitions[i],
            selfVerifyType: random.nextBool()
                ? SelfVerifyType.none
                : SelfVerifyType.written,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blocScope = BlocScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () => _generateSampleData(blocScope.editBloc),
            icon: const Icon(Icons.generating_tokens),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: theme.colorScheme.onTertiaryContainer,
        backgroundColor: theme.colorScheme.tertiaryContainer,
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
            if (flashcards.isEmpty) {
              return Center(
                child: Text(
                  'Uh oh ... nothing there!\n'
                  'Add new cards using the button below',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              );
            }

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

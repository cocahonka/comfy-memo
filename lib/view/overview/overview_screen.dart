import 'dart:async';
import 'dart:math';

import 'package:comfy_memo/domain/flashcard/controller/flashcard_edit_controller.dart';
import 'package:comfy_memo/domain/flashcard/controller/flashcard_overview_controller.dart';
import 'package:comfy_memo/domain/flashcard/dto/flashcard_create_dto.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard.dart';
import 'package:comfy_memo/view/edit_card/edit_card_screen.dart';
import 'package:comfy_memo/view/overview/flashcard_widget.dart';
import 'package:comfy_memo/view/overview/generate_random_data.dart';
import 'package:comfy_memo/view/scopes/controller_scope.dart';
import 'package:comfy_memo/view/scopes/dependencies_scope.dart';
import 'package:flutter/material.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  void _onAdd(BuildContext context) {
    if (!context.mounted) return;

    final overviewController =
        context.controllerOf<FlashcardOverviewController>();
    final dependencies = DependenciesScope.of(context, listen: true);
    final editController = FlashcardEditController(
      flashcardRepository: dependencies.flashcardRepository,
      schedulerEntryRepository: dependencies.schedulerEntryRepository,
      reviewLogRepository: dependencies.reviewLogRepository,
    );

    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ControllerScope(
            controller: editController,
            child: const Dialog.fullscreen(child: EditCardScreen.createMode()),
          );
        },
      ).then((_) => overviewController.fetchAll()),
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

  void _generateSampleData(BuildContext context) {
    final overviewController =
        context.controllerOf<FlashcardOverviewController>();
    final dependencies = DependenciesScope.of(context);
    final editController = FlashcardEditController(
      flashcardRepository: dependencies.flashcardRepository,
      schedulerEntryRepository: dependencies.schedulerEntryRepository,
      reviewLogRepository: dependencies.reviewLogRepository,
    );

    final random = Random();
    for (var i = 0; i < 3; ++i) {
      unawaited(
        editController.create(
          FlashcardCreateDto(
            title: kTitles[i],
            term: kTerms[i],
            definition: kDefinitions[i],
            selfVerify:
                random.nextBool() ? SelfVerify.none : SelfVerify.written,
          ),
        ),
      );
    }
    unawaited(overviewController.fetchAll());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overviewController =
        context.controllerOf<FlashcardOverviewController>(listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comfy memo'),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            onPressed: () => _generateSampleData(context),
            icon: const Icon(Icons.generating_tokens),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: theme.colorScheme.onTertiaryContainer,
        backgroundColor: theme.colorScheme.tertiaryContainer,
        child: const Icon(Icons.add_rounded),
        onPressed: () => _onAdd(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: RepaintBoundary(
          child: ValueListenableBuilder(
            valueListenable: overviewController,
            builder: (context, state, child) {
              if (state is OverviewState$Loading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (state is OverviewState$Error) {
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
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
                    child: FlashcardWidget(flashcard: card),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

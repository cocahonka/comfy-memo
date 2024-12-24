import 'package:comfy_memo/domain/flashcard/controller/flashcard_edit_controller.dart';
import 'package:comfy_memo/domain/flashcard/controller/flashcard_overview_controller.dart';
import 'package:comfy_memo/domain/flashcard/entity/flashcard_with_due.dart';
import 'package:comfy_memo/domain/scheduler_entry/controller/repeat_controller.dart';
import 'package:comfy_memo/view/edit_card/edit_card_screen.dart';
import 'package:comfy_memo/view/repeat/repeat_screen.dart';
import 'package:comfy_memo/view/scopes/controller_scope.dart';
import 'package:comfy_memo/view/scopes/dependencies_scope.dart';
import 'package:flutter/material.dart';

class FlashcardWidget extends StatelessWidget {
  const FlashcardWidget({required this.flashcard, super.key});

  final FlashcardWithDue flashcard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async => _onOpen(context),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FlashcardWidget$Headline(flashcard: flashcard),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: FlashcardWidget$Body(term: flashcard.term),
              ),
              if (flashcard.isRepetitionTime)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: FlashcardWidget$Notification(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onOpen(BuildContext context) async {
    if (!context.mounted) return;

    final dependencies = DependenciesScope.of(context, listen: true);
    final repeatController = RepeatController(
      schedulerEntryRepository: dependencies.schedulerEntryRepository,
      reviewLogRepository: dependencies.reviewLogRepository,
      preferencesRepository: dependencies.preferencesRepository,
      fsrsAlgorithm: dependencies.fsrsAlgorithm,
    );
    final overviewController =
        context.controllerOf<FlashcardOverviewController>();

    await Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (context) => ControllerScope(
              controller: repeatController,
              child: RepeatScreen(flashcard: flashcard.toEntity()),
            ),
          ),
        )
        .then((_) => overviewController.fetchSchedulerOnly());
  }
}

class FlashcardWidget$Headline extends StatelessWidget {
  const FlashcardWidget$Headline({required this.flashcard, super.key});

  final FlashcardWithDue flashcard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 9),
            child: Text(
              flashcard.title,
              style: theme.textTheme.titleLarge,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton.filledTonal(
            onPressed: () async => _onEdit(context),
            icon: const Icon(Icons.edit_outlined),
          ),
        ),
      ],
    );
  }

  Future<void> _onEdit(BuildContext context) async {
    if (!context.mounted) return;

    final overviewController =
        context.controllerOf<FlashcardOverviewController>();
    final dependencies = DependenciesScope.of(context, listen: true);
    final editController = FlashcardEditController(
      flashcardRepository: dependencies.flashcardRepository,
      schedulerEntryRepository: dependencies.schedulerEntryRepository,
      reviewLogRepository: dependencies.reviewLogRepository,
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ControllerScope(
        controller: editController,
        child: Dialog.fullscreen(
          child: EditCardScreen.editMode(flashcard: flashcard.toEntity()),
        ),
      ),
    ).then((_) => overviewController.fetchAll());
  }
}

class FlashcardWidget$Body extends StatelessWidget {
  const FlashcardWidget$Body({required this.term, super.key});

  final String term;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      term,
      style: theme.textTheme.bodyMedium
          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    );
  }
}

class FlashcardWidget$Notification extends StatelessWidget {
  const FlashcardWidget$Notification({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'Time to repeat!',
      style: theme.textTheme.labelLarge?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }
}
